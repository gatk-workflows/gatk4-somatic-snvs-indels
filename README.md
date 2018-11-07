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
- ``Mutect2.gatk4_jar`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.intervals`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.ref_fasta`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.ref_fasta_index`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.ref_dict`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.tumor_bam`` -- File path or storage location (depending on backend) of the tumor bam file.
- ``Mutect2.tumor_bam_index`` --  File path or storage location (depending on backend) of the tumor bam file index.
- ``Mutect2.normal_bam`` -- (optional) File path or storage location (depending on backend) of the normal bam file.
- ``Mutect2.normal_bam_index`` --  (optional, but required if ``Mutect2.normal_bam`` is specified)  File path or storage location (depending on backend) of the normal bam file index.
- ``Mutect2.pon`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.pon_index`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.scatter_count`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.gnomad`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.gnomad_index`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.variants_for_contamination`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.variants_for_contamination_index`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.is_run_orientation_bias_filter`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.is_run_oncotator`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.gatk_docker`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.oncotator_docker`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.gatk4_jar_override`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.preemptible_attempts`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.onco_ds_tar_gz`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.onco_ds_local_db_dir`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.artifact_modes`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.picard_jar`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.m2_extra_args`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.m2_extra_filtering_args`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.sequencing_center`` -- Please see parameter description above in the mutect2_multi_sample.   
- ``Mutect2.sequence_source`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.default_config_file`` -- Please see parameter description above in the mutect2_multi_sample.
- ``Mutect2.filter_oncotator_maf`` -- (optional, default true) Whether Oncotator should remove filtered variants when rendering the MAF.  Ignored if `run_oncotator` is false.

### Important Note :
- Runtime parameters are optimized for Broad's Google Cloud Platform implementation.
- For help running workflows on the Google Cloud Platform or locally please
view the following tutorial [(How to) Execute Workflows from the gatk-workflows Git Organization](https://software.broadinstitute.org/gatk/documentation/article?id=12521).
- Please post questions to the [GATK forum](https://gatkforums.broadinstitute.org/gatk/categories/ask-the-team).
- Please visit the [User Guide](https://software.broadinstitute.org/gatk/documentation/) site for furthr documentation on our workflows and tools.

### LICENSING :
Copyright Broad Institute, 2018 | BSD-3

This script is released under the WDL open source code license (BSD-3) (full license text at https://github.com/openwdl/wdl/blob/master/LICENSE). Note however that the programs it calls may be subject to different licenses. Users are responsible for checking that they are authorized to run all programs before running this script.
