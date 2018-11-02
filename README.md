# How to run the pipelines

# Alignment of ATAC-seq data (align.nf)

## Nextflow parameters of interest

If you open the file called align.nf in the atac-seq-pipeline folder you will find, on the very top, a section called "Parameters". This section contains is a set of input information that is given to the pipeline. The parameters are run-specific, meaning that one can give different parameters for different datasets. However, some of the parameters here do not need to be changed, so the ones you (may) need to provide are the following:

**params.bams:** this is the path to the folder where you have your raw (demultiplexed) bam files followed by  '/\*.bam' which tells the pipeline to take all files with the .bam extension as input files (NB the folder should contain ONLY the bam files your are interested in). **If you follow the 'recommended project setup', then the default path will work for you and you can leave it as it is.**<br/>

**params.seqtype:** this should be set to SR (Single read) or PR  (Paired read). As most RNA-seq is single read, SR is set to be the default, meaning that **if you have single read data you do not need to change this parameter.**<br/>

**params.strand:** this parameter tells the pipeline what type of strand specificity your data has. This is decided by the kit used for library preparation. The most common type is "reverse first" (RF-strand), this means that the read (or the first read if paired) comes from the reverse strand. RF-strand is the default setting so **if you have "reverse first" strand specificity you do not need to change this parameter.** The other options are: fr-stand (read, or first read in paired data, comes from forward strand) and NULL for un-stranded data (e.g from SMART2)<br/>

**params.anno_set:** which annotations you want to use. Options so far (more can be added on demand) are "tair10" and "araport11" and "tair10_TE" where "tair10" is the default and the "tair10_TE" was added on request by Maggie and Bhagyshree (contact them for details on what is included).

In addition, if you have single read data, you might consider changing the following two parameters:

**params.fragment_len**: this is an estimate of the mean fragment length. The default setting is 180 bp.<br/>
**params.fragment_sd**: this is an estimate of the fragment length standard deviation. The default is set to 20.<br/>

In my experience it's not super critical to get those two parameters 100% right. But if you know the mean and standard deviation it makes sense to provide this information.

# The main pipeline (main.nd)

## Introduction

## Requirements

## Data requirements

## Get pipeline 

### Using git (recommended)

## Recommended project setup


## Data setup

## Running the pipeline

### Nextflow parameters of interest



### How to use non-default parameters


### Starting the pipeline


### Advanced run options

This section is for advanced users. In most cases you will not need to read this (unless you are interested!)

**Run in background**</br>
If you want to continue working in the terminal where you launch the pipeline, then you can use the -bg option (bg = background). Nextflow will still send messages to the terminal when new processes are being submitted.

nextflow run -bg  rna_seq1.nf<br/>


**Restart failed/interrupted run**</br>
If your run fails for reasons that you know*, e.g. you killed it, you can use the resume option. This means that any process that had finished before the pipeline failed will be "reused" and the pipeline will not spend time on re-running those.

nextflow run rna_seq1.nf -resume

*If the pipeline fails and it's not obvious why - contact me (Elin)


**More options**</br>
The pipeline uses Nextflow, a software developed for reproducible scientific workflows. If you type the following commands in login node terminal:</br>

ml Nextflow</br>
nextflow -h</br>
and/or</br>
nextflow run -h</br>

Then all available options and commands will be listed in your terminal.

For more information about Nextflow see <https://www.nextflow.io/> and read the paper: P. Di Tommaso, et al. *Nextflow enables reproducible computational workflows.* Nature Biotechnology 35, 316–319 (2017) [doi:10.1038/nbt.3820](https://www.nature.com/articles/nbt.3820)


### Output
