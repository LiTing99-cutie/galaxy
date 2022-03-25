#!/bin/sh

set -eou pipefail

script=/home/lit/bin/smrtlink.sh

bash ${script} \
/home/lit/rd1/project/6mA/data/Pacbio/bam/Tetrahymena.subreads.bam \
/home/lit/rd1/public_data/genome/Tetrahymena/T_thermophila_June2014_assembly.fasta \
/home/lit/rd1/project/6mA/output/Pacbio \
log

# nohup bash bin/run.smrtlink.sh &