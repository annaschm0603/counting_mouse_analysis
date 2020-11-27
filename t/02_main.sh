#!/bin/bash
set -o errexit
set -o pipefail

################################################################
##
################################################################

cd ..
T_DIR="t/test_02"

nextflow run main.nf -profile test_local \
  --bams "t/test_files/aligned/*.bam" \
  --output ${T_DIR}/results \
  --design "t/test_files/exps/exp1.tab" \
  -w ${T_DIR}/work \
  -resume

################################################################
echo "output"

  if [ ! -d ${T_DIR}/results ]; then
      echo "no results"
      exit 1
  fi

  if [ ! $(ls -1q ${T_DIR}/results/ | wc -l) -eq 7 ] ; then # bam    counts deseq  ds_bam fpkm   gff    macs2
      echo "wrong number output dirs"
      exit 1
  fi

################################################################
echo "bam"

  if [ ! -d ${T_DIR}/results/bam ]; then
      echo "no bam"
      exit 1
  fi

  if [ ! $(ls -1q ${T_DIR}/results/bam | wc -l) -eq 4 ] ; then
      echo "wrong number in bam"
      exit 1
  fi

  if [ ! -f ${T_DIR}/results/bam/34762_5_uniq_filtered.bam ] || \
   [ ! -f ${T_DIR}/results/bam/34782_5_uniq_filtered.bam ] || \
   [ ! -f ${T_DIR}/results/bam/38701_5_uniq_filtered.bam ] || \
   [ ! -f ${T_DIR}/results/bam/38702_5_uniq_filtered.bam ] ; then
      echo "wrong bam files"
      exit 1
  fi


  if [ $(md5sum ${T_DIR}/results/bam/38701_5_uniq_filtered.bam  | \
    awk '{print $1}') != "0dbd1687a95e77eb0f0307055648db2e" ]; then
    echo "wrong md5sum 38701_5_uniq_filtered.bam"
    exit 1
  fi

################################################################
echo "counts"

if [ ! -d ${T_DIR}/results/counts ]; then
    echo "no counts"
    exit 1
fi


if [ ! $(ls -1q ${T_DIR}/results/counts | wc -l) -eq 24 ] ; then
    echo "wrong number in counts"
    exit 1
fi


if [ ! -f ${T_DIR}/results/counts/34762_5_uniq_filtered.bam_cond1_peaks.narrowPeak.gff_counts.tab ] || \
 [ ! -f ${T_DIR}/results/counts/34762_5_uniq_filtered.bam_cond2_peaks.narrowPeak.gff_counts.tab ] || \
 [ ! -f ${T_DIR}/results/counts/34762_5_uniq_filtered.bam_cond1_peaks.narrowPeak.gff_fpkm.tab ] || \
 [ ! -f ${T_DIR}/results/counts/34762_5_uniq_filtered.bam_cond2_peaks.narrowPeak.gff_fpkm.tab ] || \
 [ ! -f ${T_DIR}/results/counts/34762_5_uniq_filtered.bam_master_counts.tab ] || \
 [ ! -f ${T_DIR}/results/counts/34762_5_uniq_filtered.bam_master_fpkm.tab ] || \
 [ ! -f ${T_DIR}/results/counts/34782_5_uniq_filtered.bam_cond1_peaks.narrowPeak.gff_counts.tab ] || \
 [ ! -f ${T_DIR}/results/counts/34782_5_uniq_filtered.bam_cond2_peaks.narrowPeak.gff_counts.tab ] || \
 [ ! -f ${T_DIR}/results/counts/34782_5_uniq_filtered.bam_cond1_peaks.narrowPeak.gff_fpkm.tab ] || \
 [ ! -f ${T_DIR}/results/counts/34782_5_uniq_filtered.bam_cond2_peaks.narrowPeak.gff_fpkm.tab ] || \
 [ ! -f ${T_DIR}/results/counts/34782_5_uniq_filtered.bam_master_counts.tab ] || \
 [ ! -f ${T_DIR}/results/counts/34782_5_uniq_filtered.bam_master_fpkm.tab ] || \
 [ ! -f ${T_DIR}/results/counts/38701_5_uniq_filtered.bam_cond1_peaks.narrowPeak.gff_counts.tab ] || \
 [ ! -f ${T_DIR}/results/counts/38701_5_uniq_filtered.bam_cond2_peaks.narrowPeak.gff_counts.tab ] || \
 [ ! -f ${T_DIR}/results/counts/38701_5_uniq_filtered.bam_cond1_peaks.narrowPeak.gff_fpkm.tab ] || \
 [ ! -f ${T_DIR}/results/counts/38701_5_uniq_filtered.bam_cond2_peaks.narrowPeak.gff_fpkm.tab ] || \
 [ ! -f ${T_DIR}/results/counts/38701_5_uniq_filtered.bam_master_counts.tab ] || \
 [ ! -f ${T_DIR}/results/counts/38701_5_uniq_filtered.bam_master_fpkm.tab ] || \
 [ ! -f ${T_DIR}/results/counts/38702_5_uniq_filtered.bam_cond1_peaks.narrowPeak.gff_counts.tab ] || \
 [ ! -f ${T_DIR}/results/counts/38702_5_uniq_filtered.bam_cond2_peaks.narrowPeak.gff_counts.tab ] || \
 [ ! -f ${T_DIR}/results/counts/38702_5_uniq_filtered.bam_cond1_peaks.narrowPeak.gff_fpkm.tab ] || \
 [ ! -f ${T_DIR}/results/counts/38702_5_uniq_filtered.bam_cond2_peaks.narrowPeak.gff_fpkm.tab ] || \
 [ ! -f ${T_DIR}/results/counts/38702_5_uniq_filtered.bam_master_counts.tab ] || \
 [ ! -f ${T_DIR}/results/counts/38701_5_uniq_filtered.bam_master_fpkm.tab ]  \
 ; then
    echo "wrong counts files"
    exit 1
fi

if [ $(md5sum ${T_DIR}/results/counts/38701_5_uniq_filtered.bam_master_fpkm.tab  | \
  awk '{print $1}') != "007289e7d928f9064fa6be70ba85e13d" ]; then
  echo "wrong md5sum 38701_5_uniq_filtered.bam_master_fpkm.tab"
  exit 1
fi


################################################################
echo "deseq2"

  if [ ! -d ${T_DIR}/results/deseq ]; then
      echo "no deseq"
      exit 1
  fi


  if [ ! $(ls -1q ${T_DIR}/results/deseq | wc -l) -eq 14 ] ; then
      echo "wrong number in deseq"
      exit 1
  fi


  if [ ! -f ${T_DIR}/results/deseq/dds.Rdata ] || \
   [ ! -f ${T_DIR}/results/deseq/deseq_results.csv ] || \
   [ ! -f ${T_DIR}/results/deseq/master_peaks_deseq_fig1.pdf ] || \
   [ ! -f ${T_DIR}/results/deseq/master_peaks_deseq_fig2.pdf ] || \
   [ ! -f ${T_DIR}/results/deseq/master_peaks_deseq_fig3.pdf ] || \
   [ ! -f ${T_DIR}/results/deseq/master_peaks_deseq_fig4.pdf ] || \
   [ ! -f ${T_DIR}/results/deseq/master_peaks_deseq_fig5.pdf ] || \
   [ ! -f ${T_DIR}/results/deseq/master_peaks_deseq_fig6.pdf ] || \
   [ ! -f ${T_DIR}/results/deseq/master_peaks_deseq_fig1.png ] || \
   [ ! -f ${T_DIR}/results/deseq/master_peaks_deseq_fig2.png ] || \
   [ ! -f ${T_DIR}/results/deseq/master_peaks_deseq_fig3.png ] || \
   [ ! -f ${T_DIR}/results/deseq/master_peaks_deseq_fig4.png ] || \
   [ ! -f ${T_DIR}/results/deseq/master_peaks_deseq_fig5.png ] || \
   [ ! -f ${T_DIR}/results/deseq/master_peaks_deseq_fig6.png ] \
   ; then
      echo "wrong deseq files"
      exit 1
  fi

  if [ $(md5sum ${T_DIR}/results/deseq/dds.Rdata  | \
    awk '{print $1}') != "ab5027444275391ad93d377a6671f66d" ]; then
    echo "wrong md5sum dds.Rdata"
    exit 1
  fi

################################################################
echo "ds_bam"

  if [ ! -d ${T_DIR}/results/ds_bam ]; then
      echo "no ds_bam"
      exit 1
  fi


  if [ ! $(ls -1q ${T_DIR}/results/ds_bam | wc -l) -eq 8 ] ; then
      echo "wrong number in ds_bam"
      exit 1
  fi

  if [ ! -f ${T_DIR}/results/ds_bam/34762_5.bw ] || \
   [ ! -f ${T_DIR}/results/ds_bam/34782_5.bw ] || \
   [ ! -f ${T_DIR}/results/ds_bam/38701_5.bw ] || \
   [ ! -f ${T_DIR}/results/ds_bam/38702_5.bw ] || \
   [ ! -f ${T_DIR}/results/ds_bam/cond1.subset.bam ] || \
   [ ! -f ${T_DIR}/results/ds_bam/cond2.subset.bam ] || \
   [ ! -f ${T_DIR}/results/ds_bam/cond1.subset.bw ] || \
   [ ! -f ${T_DIR}/results/ds_bam/cond2.subset.bw ]  \
   ; then
      echo "wrong ds_bam files"
      exit 1
  fi


  if [ $(md5sum ${T_DIR}/results/ds_bam/38702_5.bw  | \
    awk '{print $1}') != "a6147b3faa4595497b0f3b4ee6154b8f" ]; then
    echo "wrong md5sum 38702_5.bw"
    exit 1
  fi

################################################################
echo "fpkm"

  if [ ! -d ${T_DIR}/results/fpkm ]; then
      echo "no fpkm"
      exit 1
  fi


  if [ ! $(ls -1q ${T_DIR}/results/fpkm | wc -l) -eq 4 ] ; then
      echo "wrong number in fpkm"
      exit 1
  fi

  if [ ! -f ${T_DIR}/results/fpkm/cond1_peaks.narrowPeak.gff_summary.tab ] || \
   [ ! -f ${T_DIR}/results/fpkm/cond2_peaks.narrowPeak.gff_summary.tab ] || \
   [ ! -f ${T_DIR}/results/fpkm/deseq_total_results.csv ] || \
   [ ! -f ${T_DIR}/results/fpkm/master.gff_summary.tab ] \
   ; then
      echo "wrong fpkm files"
      exit 1
  fi


  if [ $(md5sum ${T_DIR}/results/fpkm/deseq_total_results.csv  | \
    awk '{print $1}') != "406ca68efd516d7c5209e1fd724ca14a" ]; then
    echo "wrong md5sum deseq_total_results.csv"
    exit 1
  fi





################################################################
echo "gff"

  if [ ! -d ${T_DIR}/results/gff ]; then
      echo "no gff"
      exit 1
  fi


  if [ ! $(ls -1q ${T_DIR}/results/gff | wc -l) -eq 4 ] ; then
      echo "wrong number in gff"
      exit 1
  fi


  if [ ! -f ${T_DIR}/results/gff/cond1_peaks.narrowPeak.gff ] || \
   [ ! -f ${T_DIR}/results/gff/cond2_peaks.narrowPeak.gff ] || \
   [ ! -f ${T_DIR}/results/gff/master.gff ] || \
   [ ! -f ${T_DIR}/results/gff/master_anno.csv ] \
   ; then
      echo "wrong gff files"
      exit 1
  fi


  if [ $(md5sum ${T_DIR}/results/gff/master_anno.csv  | \
    awk '{print $1}') != "88df953ebc011cf577a76f718a342e1b" ]; then
    echo "wrong md5sum master_anno.csv"
    exit 1
  fi

################################################################
echo "macs2"

  if [ ! -d ${T_DIR}/results/macs2 ]; then
      echo "no macs2"
      exit 1
  fi


  if [ ! $(ls -1q ${T_DIR}/results/macs2 | wc -l) -eq 8 ] ; then
      echo "wrong number in macs2"
      exit 1
  fi

  if [ ! -f ${T_DIR}/results/macs2/cond1_peaks.narrowPeak ] || \
   [ ! -f ${T_DIR}/results/macs2/cond2_peaks.narrowPeak ] || \
   [ ! -f ${T_DIR}/results/macs2/peakOV.fig1.pdf ] || \
   [ ! -f ${T_DIR}/results/macs2/peakOV.fig2.pdf ] || \
   [ ! -f ${T_DIR}/results/macs2/peakOV.fig3.pdf ] || \
   [ ! -f ${T_DIR}/results/macs2/peakOV.fig2.png ] || \
   [ ! -f ${T_DIR}/results/macs2/peakOV.fig1.png ] || \
   [ ! -f ${T_DIR}/results/macs2/peakOV.fig3.png ] \
   ; then
      echo "wrong macs2 files"
      exit 1
  fi


  if [ $(md5sum ${T_DIR}/results/macs2/cond2_peaks.narrowPeak  | \
    awk '{print $1}') != "8f252870d6456192f389a94de0d26202" ]; then
    echo "wrong md5sum cond2_peaks.narrowPeak"
    exit 1
  fi
