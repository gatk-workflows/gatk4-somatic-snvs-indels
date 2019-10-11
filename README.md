# somatic-snvs-indels

### Purpose : 
Workflows for somatic short variant analysis with GATK4. 

### mutect2 :
Implements Somatic short variant discovery using [GATK Best Practices](https://software.broadinstitute.org/gatk/best-practices/workflow).  

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
- GATK4.1.4.0 

Cromwell version support 
- Successfully tested on v46


### Parameter descriptions :
#### mutect2 (single pair/sample)  
- ``Mutect2.gatk4_jar`` -- Location *within the docker file* of the GATK4 jar file.  If you wish you to use a different jar file, such as one on your local filesystem or a google bucket, specify that location with ``Mutect2_Multi.gatk4_jar_override``.  This parameter is ignored if ``Mutect2_Multi.gatk4_jar_override`` is specified.
- ``Mutect2.intervals`` -- A file listing genomic intervals to search for somatic mutations.  This should be in the standard GATK4 format.
- ``Mutect2.ref_fasta`` 	-- reference fasta.  In google bucket:  ``gs://gatk-best-practices/somatic-b37/Homo_sapiens_assembly19.fasta``
- ``Mutect2.ref_fasta_index`` -- In google bucket:  ``gs://gatk-best-practices/somatic-b37/Homo_sapiens_assembly19.fasta.fai``
- ``Mutect2.ref_dict`` -- In google bucket:  ``gs://gatk-best-practices/somatic-b37/Homo_sapiens_assembly19.dict``
- ``Mutect2.tumor_bam`` -- File path or storage location (depending on backend) of the tumor bam file.
- ``Mutect2.tumor_bam_index`` -- File path or storage location (depending on backend) of the tumor bam file index.
- ``Mutect2.normal_bam`` -- (optional) File path or storage location (depending on backend) of the normal bam file.
- ``Mutect2.normal_bam_index`` -- (optional, but required if ``Mutect2.normal_bam`` is specified)  File path or storage location (depending on backend) of the normal bam file index.
- ``Mutect2.pon`` -- (optional) Panel of normals VCF to use for false positive reduction.
- ``Mutect2.pon_index`` -- (optional, but required if ``Mutect2_Multi.pon`` is specified)  VCF index for the panel of normals.  Please see GATK4 tool ``IndexFeatureFile`` for creation of an index.
- ``Mutect2.scatter_count`` -- Number of executions to split the Mutect2 task into.  The more you put here, the faster Mutect2 will return results, but at a higher cost of resources.
- ``Mutect2.gnomad`` -- (optional)  gnomAD vcf containing population allele frequencies (AF) of common and rare alleles.  Download an exome or genome sites vcf [here](http://gnomad.broadinstitute.org/downloads).  Essential for determining possible germline variants in tumor
- ``Mutect2.gnomad_index`` -- (optional, but required if ``Mutect2_Multi.gnomad`` is specified)  VCF index for gnomAD.  Please see GATK4 tool ``IndexFeatureFile`` for creation of an index.
- ``Mutect2.variants_for_contamination`` -- (optional)  vcf containing population allele frequencies (AF) of common SNPs.  If omitted, cross-sample contamination will not be calculated and contamination filtering will not be applied.  This can be generated from a gnomAD vcf using the GATK4 tool ``SelectVariants`` with the argument ``--select "AF > 0.05"``.  For speed, one can get very good results using only SNPs on chromosome 1.  For example, ``java -jar $gatk SelectVariants -V gnomad.vcf -L 1 --select "AF > 0.05" -O variants_for_contamination.vcf``.
- ``Mutect2.variants_for_contamination_index`` -- (optional, but required if ``Mutect2_Multi.variants_for_contamination`` is specified)  VCF index for contamination variants.  Please see GATK4 tool ``IndexFeatureFile`` for creation of an index.
- ``Mutect2.is_run_orientation_bias_filter`` -- ``true``/``false`` whether the orientation bias filter should be run.
- ``Mutect2.is_run_oncotator`` -- ``true``/``false`` whether the command-line version of oncotator should be run.  If ``false``, ``Mutect2_Multi.oncotator_docker`` parameter is ignored.
- ``Mutect2.gatk_docker`` -- Docker image to use for Mutect2 tasks.  This is only used for backends configured to use docker.
- ``Mutect2.oncotator_docker`` -- (optional)  A GATK4 jar file to be used instead of the jar file in the docker image.  (See ``Mutect2_Multi.gatk4_jar``)  This can be very useful for developers.  Please note that you need to be careful that the docker image you use is compatible with the GATK4 jar file given here -- no automated checks are made.
- ``Mutect2.gatk4_jar_override`` -- (optional)  A GATK4 jar file to be used instead of the jar file in the docker image.  (See ``Mutect2_Multi.gatk4_jar``)  This can be very useful for developers.  Please note that you need to be careful that the docker image you use is compatible with the GATK4 jar file given here 
- ``Mutect2.preemptible_attempts`` -- Number of times to attempt running a task on a preemptible VM.  This is only used for cloud backends in cromwell and is ignored for local and SGE backends.
- ``Mutect2.onco_ds_tar_gz`` -- (optional)  A tar.gz file of the oncotator datasources -- often quite large (>15GB).  This will be uncompressed as part of the oncotator task.  Depending on backend used, this can be specified as a path on the local filesystem of a cloud storage container (e.g. gs://...).  Typically the Oncotator default datasource can be downloaded at ``ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/oncotator/``.  Do not put the FTP URL into the json file.
- ``Mutect2.onco_ds_local_db_dir`` -- "(optional)  A direct path to the Oncotator datasource directory (uncompressed).  While this is the fastest approach, it cannot be used with docker unless your docker image already has the datasources in it.  For cromwell backends without docker, this can be a local filesystem path.  *This cannot be a cloud storage location*

 Note:  If neither ``Mutect2_Multi.onco_ds_tar_gz``, nor ``Mutect2_Multi.onco_ds_local_db_dir``, is specified, the Oncotator task will download and uncompress for each execution.

The following three parameters are useful for rendering TCGA MAFs using oncotator.  These parameters are ignored if ``is_run_oncotator`` is ``false``."
- ``Mutect2.artifact_modes`` -- List of artifact modes to search for in the orientation bias filter.  For example to filter the OxoG artifact, you would specify ``["G/T"]``.  For both the FFPE artifact and the OxoG artifact, specify ``["G/T", "C/T"]``.  If you do not wish to search for any artifacts, please set ``Mutect2_Multi.is_run_orientation_bias_filter`` to ``false``.
- ``Mutect2.picard_jar`` -- A direct path to a picard jar for using ``CollectSequencingArtifactMetrics``.  This parameter requirement will be eliminated in the future.
- ``Mutect2.m2_extra_args`` -- (optional) a string of additional command line arguments of the form "-argument1 value1 -argument2 value2" for Mutect 2.  Most users will not need this.
- ``Mutect2.m2_extra_filtering_args`` -- (optional) a string of additional command line arguments of the form "-argument1 value1 -argument2 value2" for Mutect 2.  Most users will not need this.
- ``Mutect2.sequencing_center`` 	-- (optional) center reporting this variant.     Please see ``https://wiki.nci.nih.gov/display/TCGA/Mutation+Annotation+Format+%28MAF%29+Specification+-+v2.4`` for more details.   
- ``Mutect2.sequence_source`` -- (optional)  ``WGS`` or ``WXS`` for whole genome or whole exome sequencing, respectively.  Please note that the controlled vocabulary of the TCGA MAF spec is *not* enforced.  Please see ``https://wiki.nci.nih.gov/display/TCGA/Mutation+Annotation+Format+%28MAF%29+Specification+-+v2.4`` for more details.
- ``Mutect2.default_config_file`` -- "(optional)  A configuration file that can direct oncotator to use default values for unspecified annotations in the TCGA MAF.  This help prevents having MAF files with a lot of ""__UNKNOWN__"" values.  An usable example is given below.  Here is an example that should work for most users:

```
[manual_annotations]
override:NCBI_Build=37,Strand=+,status=Somatic,phase=Phase_I,sequencer=Illumina,Tumor_Validation_Allele1=,Tumor_Validation_Allele2=,Match_Norm_Validation_Allele1=,Match_Norm_Validation_Allele2=,Verification_Status=,Validation_Status=,Validation_Method=,Score=,BAM_file=,Match_Norm_Seq_Allele1=,Match_Norm_Seq_Allele2=
```
- ``Mutect2.filter_oncotator_maf`` -- (optional, default true) Whether Oncotator should remove filtered variants when rendering the MAF.  Ignored if `run_oncotator` is false.

### Functional annotation (Funcotator)

Funcotator (**FUNC**tional ann**OTATOR**) is a functional annotation tool in the core GATK toolset and was designed to handle both somatic and germline use cases. It analyzes given variants for their function (as retrieved from a set of data sources) and produces the analysis in a specified output file.  Funcotator reads in a VCF file, labels each variant with one of twenty-three distinct variant classifications, produces gene information (e.g. affected gene, predicted variant amino acid sequence, etc.), and associations to information in datasources. Default supported datasources include GENCODE (gene information and protein change prediction), dbSNP, gnomAD, and COSMIC (among others). The corpus of datasources is extensible and user-configurable and includes cloud-based datasources supported with Google Cloud Storage. Funcotator produces either a Variant Call Format (VCF) file (with annotations in the INFO field) or a Mutation Annotation Format (MAF) file.

Funcotator allows the user to add their own annotations to variants based on a set of data sources.  Each data source can be customized to annotate a variant based on several matching criteria.  This allows a user to create their own custom annotations easily, without modifying any Java code.

By default the M2 WDL runs Funcotator for functional annotation and produce a TCGA MAF from the M2 VCF.  There are several notes and caveats
- Several parameters should be passed in to populate the TCGA MAF metadata fields.  Default values are provided, though we recommend that you specify the values.  These parameters are ignored if you do not run Funcotator.
- Several fields in a TCGA MAF cannot be generated by M2 and Funcotator, such as all fields relating to validation alleles.  These will need to be populated by a downstream process created by the user.
- Funcotator does not enforce the TCGA MAF controlled vocabulary, since it is often too restrictive for general use.  This is up to the user to specify correctly.
  *Therefore, we cannot guarantee that a TCGA MAF generated here will pass the TCGA Validator*.  If you are unsure about the ramifications of this statement, then it probably does not concern you.
- More information about Funcotator can be found at: https://gatkforums.broadinstitute.org/dsde/discussion/11193/funcotator-information-and-tutorial/ 

### Important Note :
- Runtime parameters are optimized for Broad's Google Cloud Platform implementation.
- For help running workflows on the Google Cloud Platform or locally please
view the following tutorial [(How to) Execute Workflows from the gatk-workflows Git Organization](https://software.broadinstitute.org/gatk/documentation/article?id=12521).
- The following material is provided by the GATK Team. Please post any questions or concerns to one of our forum sites : [GATK](https://gatkforums.broadinstitute.org/gatk/categories/ask-the-team/) , [Terra](https://support.terra.bio/hc/en-us/community/topics/360000500432) , [WDL/Cromwell](https://gatkforums.broadinstitute.org/wdl/categories/ask-the-wdl-team).
- Please visit the [User Guide](https://software.broadinstitute.org/gatk/documentation/) site for further documentation on our workflows and tools.

### LICENSING :
Copyright Broad Institute, 2018 | BSD-3

This script is released under the WDL open source code license (BSD-3) (full license text at https://github.com/openwdl/wdl/blob/master/LICENSE). Note however that the programs it calls may be subject to different licenses. Users are responsible for checking that they are authorized to run all programs before running this script.
