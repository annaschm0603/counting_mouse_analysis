#!/bin/bash
set -o errexit
set -o pipefail

################################################################
##
################################################################

cd ..
T_DIR="t/test_01"

nextflow run align.nf -profile slurm \
  --bams "t/test_files/bams/*.bam" \
  --output ${T_DIR}/results \
  -w ${T_DIR}/work -resume
