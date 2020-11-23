#!/bin/bash
set -o errexit
set -o pipefail

################################################################
##
################################################################

cd ..
T_DIR="t/test_01"

nextflow run main.nf -profile slurm \
  --bams "t/test_files/aligned/large/*.bam" \
  --output ${T_DIR}/results \
  --design "t/test_files/exps/exp1.tab" \
  -w ${T_DIR}/work -resume
