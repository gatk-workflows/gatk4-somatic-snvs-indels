# somatic-snvs-indels

### Purpose : 
Workflows for somatic short variant analysis with GATK4. 

### mutect2 :
Implements Somatic short variant discovery using [GATK Best Practices](https://software.broadinstitute.org/gatk/best-practices/workflow) (June 2016).


#### Requirements/expectations
- Tumor bam and index
- normal bam and index

#### Outputs 
- unfiltered vcf 
- unfiltered vcf index 
- filtered vcf 
- filtered vcf index 

### Software version requirements :
- GATK4 or later 

Cromwell version support 
- Successfully tested on v30
