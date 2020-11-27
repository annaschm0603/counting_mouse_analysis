#!/bin/bash
set -o errexit
set -o pipefail

################################################################
##
################################################################

cd ..
T_DIR="t/test_01"

nextflow run align.nf -profile test_local \
  --bams "t/test_files/bams/*.bam" \
  --output ${T_DIR}/results \
  -w ${T_DIR}/work -resume


  ################################################################
  echo "output"

    if [ ! -d ${T_DIR}/results ]; then
        echo "no results"
        exit 1
    fi

    if [ ! $(ls -1q ${T_DIR}/results/ | wc -l) -eq 12 ] ; then
        echo "wrong number output"
        exit 1
    fi

    if [ ! -f ${T_DIR}/results/s_34762.aligned_cut_sorted.bam ] || \
     [ ! -f ${T_DIR}/results/s_34782.aligned_cut_sorted.bam ] || \
     [ ! -f ${T_DIR}/results/s_38701_2.aligned_cut_sorted.bam ] || \
     [ ! -f ${T_DIR}/results/s_38702_2.aligned_cut_sorted.bam ] || \
     [ ! -f ${T_DIR}/results/s_38702_2.cutadapt.log ] || \
     [ ! -f ${T_DIR}/results/s_38701_2.cutadapt.log ] || \
     [ ! -f ${T_DIR}/results/s_34782.cutadapt.log ] || \
     [ ! -f ${T_DIR}/results/s_34762.cutadapt.log ] || \
     [ ! -f ${T_DIR}/results/s_34762.bowtie2.log ] || \
     [ ! -f ${T_DIR}/results/s_34782.bowtie2.log ] || \
     [ ! -f ${T_DIR}/results/s_38701_2.bowtie2.log ] || \
     [ ! -f ${T_DIR}/results/s_38702_2.bowtie2.log ] \
     ; then
        echo "wrong bam files"
        exit 1
    fi


    if [ $(md5sum ${T_DIR}/results/s_38701_2.aligned_cut_sorted.bam  | \
      awk '{print $1}') != "065b97d7b880b046dbff3215ddb96fb8" ]; then
      echo "wrong md5sum "
      exit 1
    fi


  ################################################################
