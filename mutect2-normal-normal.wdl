## Copyright Broad Institute, 2017
##
## This WDL workflow calls pairs of replicates as tumor-normal pairs, 
## counts the number of variants (i.e. false positives) and reports false 
## positive rates.
##
## Main requirements/expectations :
## - One analysis-ready BAM file (and its index) for each replicate
##
## Outputs :
## - False Positive VCF files and its index with summary
##
## Cromwell version support
## - Successfully tested on v36
##
## LICENSING :
## This script is released under the WDL source code license (BSD-3) (see LICENSE in
## https://github.com/broadinstitute/wdl). Note however that the programs it calls may
## be subject to different licenses. Users are responsible for checking that they are
## authorized to run all programs before running this script. Please see the docker
## pages at https://hub.docker.com/r/broadinstitute/* for detailed licensing information
## pertaining to the included programs.

import "https://raw.githubusercontent.com/gatk-workflows/gatk4-somatic-snvs-indels/2.5.0/mutect2_nio.wdl" as m2

workflow Mutect2NormalNormal {
	File? intervals
	File ref_fasta
	File ref_fai
	File ref_dict
	Int scatter_count
	Array[File] bams
	Array[File] bais
	File? pon
	File? gnomad
	File? variants_for_contamination
	Boolean? run_orientation_bias_mixture_model_filter
	File? realignment_index_bundle
	String? realignment_extra_args
	String? m2_extra_args
	String? m2_extra_filtering_args
	Boolean? make_bamout

	File? gatk_override
	String gatk_docker
	Int? preemptible_attempts

	Array[Pair[File,File]] bam_pairs = cross(bams, bams)
	Array[Pair[File,File]] bai_pairs = cross(bais, bais)

	scatter(n in range(length(bam_pairs))) {
	    File tumor_bam = bam_pairs[n].left
	    File normal_bam = bam_pairs[n].right
	    File tumor_bai = bai_pairs[n].left
            File normal_bai = bai_pairs[n].right

        if (tumor_bam != normal_bam) {
            call m2.Mutect2 {
                input:
                    intervals = intervals,
                    ref_fasta = ref_fasta,
                    ref_fai = ref_fai,
                    ref_dict = ref_dict,
                    tumor_reads = tumor_bam,
                    tumor_reads_index = tumor_bai,
                    normal_reads = normal_bam,
                    normal_reads_index = normal_bai,
                    pon = pon,
                    scatter_count = scatter_count,
                    gnomad = gnomad,
                    variants_for_contamination = variants_for_contamination,
                    run_orientation_bias_mixture_model_filter = run_orientation_bias_mixture_model_filter,
                    preemptible_attempts = preemptible_attempts,
                    realignment_index_bundle = realignment_index_bundle,
                    realignment_extra_args = realignment_extra_args,
                    m2_extra_args = m2_extra_args,
                    m2_extra_filtering_args = m2_extra_filtering_args,
                    gatk_override = gatk_override,
                    gatk_docker = gatk_docker
            }

            call CountFalsePositives {
                input:
                    intervals = intervals,
                    ref_fasta = ref_fasta,
                    ref_fai = ref_fai,
                    ref_dict = ref_dict,
                    filtered_vcf = Mutect2.filtered_vcf,
                    filtered_vcf_index = Mutect2.filtered_vcf_idx,
                    gatk_override = gatk_override,
                    gatk_docker = gatk_docker
            }
		}
	}

	call GatherTables { input: tables = select_all(CountFalsePositives.false_positive_counts) }

	output {
		File summary = GatherTables.summary
		Array[File] false_positives_vcfs = select_all(Mutect2.filtered_vcf)
		Array[File] false_positives_vcf_indices = select_all(Mutect2.filtered_vcf_idx)
	}
}

task GatherTables {
    # we assume that each table consists of two lines: one header line and one record
	Array[File] tables

	command {
	    # extract the header from one of the files
		head -n 1 ${tables[0]} > summary.txt

		# then append the record from each table
		for table in ${sep=" " tables}; do
			tail -n +2 $table >> summary.txt
		done
	}

	runtime {
        docker: "broadinstitute/genomes-in-the-cloud:2.2.4-1469632282"
        memory: "1 GB"
        disks: "local-disk " + 100 + " HDD"
    }

	output {
		File summary = "summary.txt"
	}
}

task CountFalsePositives {
	File? intervals
	File ref_fasta
	File ref_fai
	File ref_dict
	File filtered_vcf
	File filtered_vcf_index

	File? gatk_override

	String gatk_docker

	command {
        export GATK_LOCAL_JAR=${default="/root/gatk.jar" gatk_override}

	    gatk --java-options "-Xmx4g" CountFalsePositives \
		    -V ${filtered_vcf} \
		    -R ${ref_fasta} \
		    ${"-L " + intervals} \
		    -O false-positives.txt \
	}

    runtime {
        docker: gatk_docker
        bootDiskSizeGb: 12
        memory: "5 GB"
        disks: "local-disk " + 500 + " HDD"
    }

	output {
		File false_positive_counts = "false-positives.txt"
	}
}

