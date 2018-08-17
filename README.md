# somatic-snvs-indels

### Purpose : 
Workflows for somatic short variant analysis with GATK4. 

### mutect2 :
Implements Somatic short variant discovery using [GATK Best Practices](https://software.broadinstitute.org/gatk/best-practices/workflow).
Note: Also provided in this repo is mutect2_nio which is a NIO supported version of the wdl.  

#### Requirements/expectations
- Tumor bam and index
- Normal bam and index

#### Outputs 
- unfiltered vcf 
- unfiltered vcf index 
- filtered vcf 
- filtered vcf index 

### mutect2_pon :
Creates a Panel of Norms to be implemented in somatic short variant discovery. 

#### Requirements/expectations
- Normal bams and index

#### Outputs 
- PON vcf and index
- Normal calls vcf and index

### mutect2-normal-normal :
Used to validate mutect2 workflow.

#### Requirements/expectations
- One analysis-ready BAM file (and its index) for each replicate

#### Outputs
- False Positive VCF files and its index with summary  
     
### Software version requirements :
- GATK4 or later 

Cromwell version support 
- Successfully tested on v31


### Parameter descriptions :
#### mutect2 (single pair/sample)  


``Mutect2.gatk4_jar`` -- Location within the docker file of the GATK4 jar file. If you wish you to use a different jar file, such as one on your local filesystem or a google bucket, specify that location with Mutect2_Multi.gatk4_jar_override. This parameter is ignored if Mutect2_Multi.gatk4_jar_override is specified. Running local version of the tool requires the `gatk` executable to be included in your $PATH. 
``Mutect2.intervals`` -- A file listing genomic intervals to search for somatic mutations. This should be in the standard GATK4 format. 
``Mutect2.ref_fasta`` -- reference fasta. For Broad internal VM: /seq/references/Homo_sapiens_assembly19/v1/Homo_sapiens_assembly19.fasta 
``Mutect2.ref_fasta_index`` -- For Broad internal VM: /seq/references/Homo_sapiens_assembly19/v1/Homo_sapiens_assembly19.fasta.fai 
``Mutect2.ref_dict`` -- For Broad internal VM: /seq/references/Homo_sapiens_assembly19/v1/Homo_sapiens_assembly19.dict 
``Mutect2.tumor_bam`` -- File path or storage location (depending on backend) of the tumor bam file. 
``Mutect2.tumor_bam_index`` -- File path or storage location (depending on backend) of the tumor bam file index. 
``Mutect2.normal_bam`` -- (optional) File path or storage location (depending on backend) of the normal bam file. 
``Mutect2.normal_bam_index`` -- (optional, but required if ``Mutect2.normal_bam`` is specified) File path or storage location (depending on backend) of the normal bam file index. 
``Mutect2.pon`` -- (optional) Panel of normals VCF to use for false positive reduction.  
``Mutect2.pon_index`` -- (optional, but required if ``Mutect2.pon`` is specified) VCF index for the panel of normals. Please see GATK4 tool IndexFeatureFile for creation of an index.  
``Mutect2.scatter_count`` -- Number of executions to split the Mutect2 task into. The more you put here, the faster Mutect2 will return results, but at a higher cost of resources.  
``Mutect2.gnomad`` -- (optional) gnomAD vcf containing population allele frequencies (AF) of common and rare alleles. Download an exome or genome sites vcf here. Essential for determining possible germline variants in tumor-only calling and helpful in tumor-normal calling as well.  
``Mutect2.gnomad_index`` -- (optional, but required if ``Mutect2.gnomad`` is specified) VCF index for gnomAD. Please see GATK4 tool IndexFeatureFile for creation of an index.  
``Mutect2.variants_for_contamination`` -- (optional) vcf containing population allele frequencies (AF) of common SNPs. If omitted, cross-sample contamination will not be calculated and contamination filtering will not be applied. This can be generated from a gnomAD vcf using the GATK4 tool SelectVariants with the argument --select "AF > 0.05". For speed, one can get very good results using only SNPs on chromosome 1. For example, java -jar $gatk SelectVariants -V gnomad.vcf -L 1 --select "AF > 0.05" -O variants_for_contamination.vcf.  
``Mutect2.variants_for_contamination_index`` -- (optional, but required if ``Mutect2.variants_for_contamination`` is specified) VCF index for contamination variants. Please see GATK4 tool IndexFeatureFile for creation of an index.  
``Mutect2.is_run_orientation_bias_filter`` -- true/false whether the orientation bias filter should be run.  
``Mutect2.is_run_oncotator`` -- true/false whether the command-line version of oncotator should be run. If false, Mutect2_Multi.oncotator_docker parameter is ignored.  
``Mutect2.gatk_docker`` -- Docker image to use for Mutect2 tasks. This is only used for backends configured to use docker.  
``Mutect2.oncotator_docker`` -- Docker image to use for Oncotator tasks. This is only used for backends configured to use docker.  
``Mutect2.gatk4_jar_override`` -- (optional) A GATK4 jar file to be used instead of the jar file in the docker image. (See ``Mutect2.gatk4_jar``) This can be very useful for developers. Please note that you need to be careful that the docker image you use is compatible with the GATK4 jar file given here -- no automated checks are made.  
``Mutect2.preemptible_attempts`` -- Number of times to attempt running a task on a preemptible VM. This is only used for cloud backends in cromwell and is ignored for local and SGE backends.  
``Mutect2.onco_ds_tar_gz`` -- (optional)  A tar.gz file of the oncotator datasources -- often quite large (>15GB).  This will be uncompressed as part of the oncotator task.  Depending on backend used, this can be specified as a path on the local filesystem of a cloud storage container (e.g. gs://...).  Typically the Oncotator default datasource can be downloaded at ``ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/oncotator/``.  Do not put the FTP URL into the json file.  
``Mutect2.onco_ds_local_db_dir`` -- (optional)  A direct path to the Oncotator datasource directory (uncompressed).  While this is the fastest approach, it cannot be used with docker unless your docker image already has the datasources in it.  For cromwell backends without docker, this can be a local filesystem path.  *This cannot be a cloud storage location*  
``Mutect2.artifact_modes`` -- List of artifact modes to search for in the orientation bias filter. For example to filter the OxoG artifact, you would specify ["G/T"]. For both the FFPE artifact and the OxoG artifact, specify ["G/T", "C/T"]. If you do not wish to search for any artifacts, please set Mutect2_Multi.is_run_orientation_bias_filter to false.  
``Mutect2.picard_jar`` -- A direct path to a picard jar for using CollectSequencingArtifactMetrics. This parameter requirement will be eliminated in the future.  
``Mutect2.m2_extra_args`` -- (optional) a string of additional command line arguments of the form "-argument1 value1 -argument2 value2" for Mutect 2. Most users will not need this.  
``Mutect2.m2_extra_filtering_args`` -- (optional) a string of additional command line arguments of the form "-argument1 value1 -argument2 value2" for Mutect 2 filtering. Most users will not need this.  
``Mutect2.sequencing_center`` -- (optional) center reporting this variant.     Please see ``https://wiki.nci.nih.gov/display/TCGA/Mutation+Annotation+Format+%28MAF%29+Specification+-+v2.4`` for more details.  
``Mutect2.sequence_source`` -- (optional)  ``WGS`` or ``WXS`` for whole genome or whole exome sequencing, respectively.  Please note that the controlled vocabulary of the TCGA MAF spec is *not* enforced.  Please see ``https://wiki.nci.nih.gov/display/TCGA/Mutation+Annotation+Format+%28MAF%29+Specification+-+v2.4`` for more details.  
``Mutect2.default_config_file`` -- (optional)  A configuration file that can direct oncotator to use default values for unspecified annotations in the TCGA MAF.  This help prevents having MAF files with a lot of "__UNKNOWN__" values.  An usable example is given below.  Here is an example that should work for most users:
```
[manual_annotations]
override:NCBI_Build=37,Strand=+,status=Somatic,phase=Phase_I,sequencer=Illumina,Tumor_Validation_Allele1=,Tumor_Validation_Allele2=,Match_Norm_Validation_Allele1=,Match_Norm_Validation_Allele2=,Verification_Status=,Validation_Status=,Validation_Method=,Score=,BAM_file=,Match_Norm_Seq_Allele1=,Match_Norm_Seq_Allele2=
```

### Important Note :
- Runtime parameters are optimized for Broad's Google Cloud Platform implementation. 
- For help running workflows on the Google Cloud Platform or locally please
view the following tutorial [(How to) Execute Workflows from the gatk-workflows Git Organization](https://software.broadinstitute.org/gatk/documentation/article?id=12521)
