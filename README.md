# About the atac-seq-pipeline

The folder contains two nextflow files (align.nf and main.nf). 

**The align.nf pipeline** takes demultiplexed unaligned bam files and performs the following steps: <br/>
1,  converts bam to fastq files and trimms reads to set length <br/>
2,  removes adapter sequences using cutadapt <br/>
3,  alignes the reads using bowtie2 and saves the alignment logs.

**The main.nf pipeline** carries on using the aligned bam files genearted by align.nf and performs the following: <br/>
1, Generates bam files that are filtered for quality and contains only uniqely mapped reads. <br/>
2, Generates bigwig files from the bam files in 1, <br/>
3, Merges the files from 1, so that all replicates are in one large bam file <br/>
4, Runs statistics on the large bam files from 3, <br/>
5, Using the stats from 4, the files from 3 are subsampled so that all conditions have the same read depth <br/>
6, Sorts the files from 5 <br/>
7, Generates bigwig files from the files generated in 6 <br/>
8, Calls macs2 on the files from 5 <br/>
9, Merges peaks using the macs2 output from 8 <br/>
10, Makes some plots using the peaks from 8 <br/>
11, Creates a gff file for rhe merged peaks <br/>
12, Counts reads in each merged peak <br/>
13, Counts reads in all narrow peaks <br/>
14, Runs dese2q analysis on the merged peaks <br/>
15, Combines results from the different steps

# Nextflow version

The pipeline was developed for nextflow version  0.27.5-Java-1.8.0_112. Please use this version to run the pipeline (module load Nextflow/0.27.5-Java-1.8.0_112)


# Nextflow parameters 

If you open the file called align.nf or the file main.nf in the atac-seq-pipeline folder you will find, on the very top, a section called "Parameters". This section contains is a set of input information that is given to the pipeline. The parameters are run-specific, meaning that one can give different parameters for different datasets. However, some of the parameters here do not need to be changed!

## ALIGNMENT PIPELINE (align.nf)

**params.bams:** this is the path to the folder where you have your raw (demultiplexed) bam files followed by  '/\*.bam' which tells the pipeline to take all files with the .bam extension as input files (NB the folder should contain ONLY the bam files your are interested in). **If you follow the 'recommended project setup', then the default path will work for you and you can leave it as it is.**<br/>

**params.read_length:** this the read length of the bam files with the shortest reads. By default it is set to 50 bp. If all your samples were sequences with e.g. 120 bp then you can/should set this parameter to 120 (or 0 - read on to learn why). If some of your samples were sequenced e.g. 50bp whereas other samples where longer, they you should set this to 50.  If you set the read_length parameter to 0, this means that the reads will not be trimmed down, meaning samples sequenced with 50bp will have 50pb reads and samples with e.g. 120 bp will have reads that are 120 bp long. **I recommend to set this parameter to the length of the shortest read length sample, even when all samples were sequenced to the same length.** 

**params.output:** the path where the aligned bam files will end up when the pipeline has finished. **I recommend NOT to change this parameter**.

**params.stats:** the path where the alignment logs will be saved to. 

**params.min_length:** this parameter is used by cutadapt. After removing adapter sequences, reads that are shorter than this are removed from the analysis. (Does not make sense to try to align reads that are just a few bp long)

**params.overlap:** this parameter is used by cutadapt. When identifying adapter sequences, this is the overlap required between the adapter sequence and the read.  **If this parameter is not set to 1, there will be a a dip in the aligned fragment distribution, so DO NOT CHANGE THIS unless you have really good reasons**. 

**params.A:** this parameter is used by cutadapt. It is the adaptor sequence that should be detected and cut away. The default is for Tn5 tagmentation used in atac-seq. **DO NOT CHANGE THIS unless you have really good reasons**

**params.a:** this parameter is used by cutadapt.  It is the adaptor sequence that should be detected and cut away. The default is for Tn5 tagmentation used in atac-seq. **DO NOT CHANGE THIS unless you have really good reasons**

**params.index:** this is the index that Bowtie2 will use to align the reads.

## MAIN PIPELINE (main.nf)

**params.design:**  The file with the experimental design.  **If you follow the 'recommended project setup', then the default path will work for you and you can leave it as it is.**<br/>

**params.macs_call:** The call passed to macs2.

**params.genome:** At the moment only Athaliana is available. For adding other organisms or annotation sets please contact me.

**params.bams:**  The path to the folder with the aligned bam files, followd by '/\*.bam' which tells the pipeline to take all files with the .bam extension as input files (NB the folder should contain ONLY the bam files your are interested in). **If you follow the 'recommended project setup', then the default path will work for you and you can leave it as it is.**<br/>

**params.quality:** The quality threshold for the alignment

**params.output:** The path to the forlder where the results will end up when the pipeline has finished

**params.anno_distance:** Distance up and downstream from TSS to be considered when annotating peaks

**params.peak_merge_dist:** Peaks closer than this will be merged

**params.deseq_p:** The p-value threshold used in DESeq2 (only in plots)

**params.deseq_fc:** The fold change threshold used in DESeq2 (only in plots)

**params.bw_binsize:** Desired binsize for bigwig files

## Recommended project setup

Create a folder and name it something fitting. In this new folder, clone the pipeline from git:

git clone https://github.com/Gregor-Mendel-Institute/atac-seq-pipeline.git

and create a folder called demult

mkdir demult

then copy all demultiplexed files to the demult folder (using data moving node!)

in the file atac-seq-pipeline/align.nf make sure that that the following parameters are set correctly:

**params.read_length,  params.index** 

for the other parameters the default values should work.

Now you can run the pipeline!  **(Consider using the screen command as the alignments usually takes some time)**

module load Nextflow/0.27.5-Java-1.8.0_112
nextflow run align.nf

Once you have the aligned files you can start the main.nf pipeline. For this pipeline there is only one critical step (as long as you want to use the default settings - please read the parameters section above to confirm that that is what you want). To create the design file:

In the atac-seq-pipeline folder create a file called exp.tab

In this file write (with , as sep) one row per sample:

The name you want to use for the sample, the name of the aligned bam file, the condition

E.g.:

Cond1_rep1, Cond1_rep1_aligned.bam, cond1 <br/>
Cond1_rep2, Cond1_rep2_aligned.bam, cond1 <br/>
Cond2_rep1, Cond2_rep1_aligned.bam, cond2 <br/>
Cond2_rep2, Cond2_rep2_aligned.bam, cond2 <br/>

Now you can run the pipeline:
module load Nextflow/0.27.5-Java-1.8.0_112
nextflow run main.nf




# Running the pipeline

To run the pipeline (once all parameters and files are set up as described above):

module load Nexflow

nextflow run align.nf

nextflow run main.nf


**Run in background**</br>
If you want to continue working in the terminal where you launch the pipeline, then you can use the -bg option (bg = background). Nextflow will still send messages to the terminal when new processes are being submitted.

nextflow run -bg  rna_seq1.nf<br/>


**Restart failed/interrupted run**</br>
If your run fails for reasons that you know*, e.g. you killed it, you can use the resume option. This means that any process that had finished before the pipeline failed will be "reused" and the pipeline will not spend time on re-running those.

nextflow run align.nf -resume
nextflow run main.nf -resume


*If the pipeline fails and it's not obvious why - contact me (Elin)


**More options**</br>
The pipeline uses Nextflow, a software developed for reproducible scientific workflows. If you type the following commands in login node terminal:</br>

ml Nextflow/0.27.5-Java-1.8.0_112</br>
nextflow -h</br>
and/or</br>
nextflow run -h</br>

Then all available options and commands will be listed in your terminal.

For more information about Nextflow see <https://www.nextflow.io/> and read the paper: P. Di Tommaso, et al. *Nextflow enables reproducible computational workflows.* Nature Biotechnology 35, 316–319 (2017) [doi:10.1038/nbt.3820](https://www.nature.com/articles/nbt.3820)


