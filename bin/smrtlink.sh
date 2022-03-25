#!/bin/sh

set -eou pipefail
# conda create -n pb-assembly -c bioconda pb-assembly
# conda create -n pbalign -c bioconda pbalign

. "/home/lit/rd1/anaconda3/etc/profile.d/conda.sh"
conda activate pbalign

subreadBam=$1
basename=`basename $subreadBam`
subreadBamName=${basename%%.*}
ref=$2
output_dir=$3/${subreadBamName}
log_dir=$4

[ -d ${output_dir} ] || mkdir ${output_dir}
[ -d ${log_dir} ] || mkdir ${log_dir}

# ccs 6.2.0
# ccs [options] <IN.subreads.bam|xml> <OUT.ccs.bam|fastq.gz|xml>
# time ( ccs --min-rq 0.99 --min-passes 20 -j 30 \
# $subreadBam \
# ${output_dir}/${subreadBamName}.ccs.fastq.gz ) \
# > ${log_dir}/ccs.${subreadBamName}.log 2>&1 

# minimap2 2.15-r905
# minimap2 [options] <target.fa>|<target.idx> [query.fa] [...]

# time ( minimap2 -t 30 -x sr \
# ${output_dir}/${subreadBamName}.ccs.fastq.gz \
# ${ref} \
# > ${output_dir}/${subreadBamName}.minimap2.bam ) \
# > ${log_dir}/minimap2.${subreadBamName}.log 2>&1 &

# build index first
# pbindex $subreadBam 

bam2fasta -o ${output_dir}/${subreadBamName}.subreads $subreadBam 

# pbalign 0.4.1
# positional arguments:
#   inputFileName         SubreadSet or unaligned .bam
#   referencePath         Reference DataSet or FASTA file
#   outputFileName        Alignment results dataset

time ( pbalign --nproc 30 \
${output_dir}/${subreadBamName}.subreads.fasta.gz \
${output_dir}/${subreadBamName}.ccs.fastq.gz \
${output_dir}/${subreadBamName}.pbalign.bam ) \
> ${log_dir}/pbalign.${subreadBamName}.log 2>&1 

# ipdSummary 3.0
# ipdSummary aligned.bam --reference ref.fasta m6A,m4C --gff basemods.gff \
# --csv_h5 kinetics.h5

time ( ipdSummary --numWorkers 30 \
${output_dir}/${subreadBamName}.pbalign.bam \
--reference ${ref} \
--identify m6A \
--gff ${output_dir}/${subreadBamName}.gff \
--csv ${output_dir}/${subreadBamName}.csv )
> ${log_dir}/ipdSummary.${subreadBamName}.log 2>&1 
 

wait