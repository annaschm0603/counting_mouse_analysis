#!/usr/bin/env nextflow
//#########################
// Parameters
//#########################
params.bams          = "../demult/*.bam" // path to demultiplexed bam files. ALL bam files in folder will be aligned!!
params.read_length   = 50
params.output        = "bam/" // path to folder where aligned files will end up
params.stats         = "align_logs/"  // path to folder where alignment stats end up
params.min_length    = 5 // minimal length (after trimmining) to keep reed
params.overlap       = 1 // minimal length of adapter seq to be removed (if not 1, there will be a dip in the  fragment size distribution!!)
params.A             = "CTGTCTCTTATACACATCTGACGCTGCCGACGA"
params.a             = "CTGTCTCTTATACACATCTCCGAGCCCACGAGAC"
//params.index         = "/groups/berger/lab/NGS_annotations/backup_berger_common/Bowtie2Index/genome"
params.genomeIndex = "tair10"

//params.index         = "/lustre/scratch/projects/berger_common/mm10/mm10_index_4Bowtie/mm10"


// index
if ( params.genomeIndex == "tair10"){
  params.index="library://elin.axelsson/index/index_bowtie2_tair10:v2.4.1-release-47"
}

/****************************
* STEP 0 PULL INDEX IMAGE
*****************************/


process get_bowtie2_index {

  input:
  file params.index

  output:
  file params.genomeIndex into bw2index
  file "*.fa.gz" into fasta
  file "*.txt" into doc

script:
"""
singularity run ${params.index}
"""
}





// start channel
bams = Channel
       .fromPath(params.bams)
       .map { file -> tuple(file.baseName, file) }

bams.into { bam_read1; bam_read2 }

// bam2fastq 1st and 2nd read in parallel , reads trimmed if read_length not 0

process bam_to_fastq1 {
tag "name: $name"

   input:
   set name, file(bam) from bam_read1

   output:
   set name, file("${name}_R1_.fastq") into fq1

   script:
   if( params.read_length == 0 )
       """
       samtools view -f 0x40 -b ${bam} | samtools bam2fq - > "${name}_R1_.fastq"
       """

   else if( params.read_length > 0 )
       """
       samtools view -f 0x40 -b ${bam} | samtools bam2fq - | fastx_trimmer -l $params.read_length -Q33 -o "${name}_R1_.fastq"
       """

   else
       error "Invalid read_length argument"
}

process bam_to_fastq2 {
tag "name: $name"

   input:
   set name, file(bam) from bam_read2

   output:
   set name, file("${name}_R2_.fastq") into fq2

   script:
   if( params.read_length == 0 )
       """
       samtools view -f 0x80 -b ${bam} | samtools bam2fq - > "${name}_R2_.fastq"
       """

   else if( params.read_length > 0 )
       """
       samtools view -f 0x80 -b ${bam} | samtools bam2fq - | fastx_trimmer -l ${params.read_length} -Q33 -o "${name}_R2_.fastq"
       """

   else
       error "Invalid read_length argument"
}

// downstream pipeline needs the first and second read at once.

fqs = fq1.cross(fq2).map{ it -> tuple( it[0][0], it[0][1],it[1][1] )}


process cutadapt {
tag "name: $name"
publishDir params.output, mode: 'copy', pattern: '{*.log}'

   input:
   set name, file(fq1), file(fq2) from fqs

   output:
   set name, file("${name}_cutadapt_R1_fastq"), file("${name}_cutadapt_R2_fastq") into trimmed
   file("${name}.cutadapt.log") into calogs

   script:
   """
   cutadapt --minimum-length ${params.min_length} --overlap ${params.overlap} -a ${params.a}  -A ${params.A} -o ${name}_cutadapt_R1_fastq -p ${name}_cutadapt_R2_fastq ${fq1} ${fq2} > ${name}.cutadapt.log
   """
}

process bowtie2 {
tag "name: $name"
publishDir params.output, mode: 'copy', pattern: '{*.log}'

   input:
   set name, file(cut1), file(cut2) from trimmed
   file(genomeIndex) from bw2index

   output:
   set name, file("${name}.aligned_cut.sam") into sams
   file("${name}.bowtie2.log") into btlogs

   script:
   """
   bowtie2 --end-to-end -X 2000 -x ${genomeIndex}/${genomeIndex} -1 ${cut1} -2 ${cut2} -S ${name}.aligned_cut.sam 2> ${name}.bowtie2.log

   """
}

process sort {
tag "name: $name"
publishDir params.output, mode: 'copy'

   input:
   set name, file(sam) from sams

   output:
   set name, file("${name}.aligned_cut_sorted.bam")

   script:
   """
   export TMPDIR=./${name}_tmp
# make sure the directory exists
   mkdir -p \$TMPDIR
   samtools view -b ${sam} | samtools sort -T \$TMPDIR - > ${name}.aligned_cut_sorted.bam
   """
}

logs=calogs.mix(btlogs)


process savelog {
tag "name: $name"
publishDir params.stats, mode: 'copy'

 input:
 file(mylog) from logs

 output:
 file "${mylog.baseName}.logfile"

  script:
  """
  fname=\$(basename ${mylog})
  fbname=\${fname%.*}
  cp ${mylog} \${fbname}.logfile
  """
}


println "Project : $workflow.projectDir/$params.stats"
