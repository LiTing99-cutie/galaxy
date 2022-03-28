#!/bin/sh

module load singularity/3.6.4    # Required only singularity/3.6.4 is a dynamic environment module. 
singularity pull 6mASCOPE.sif library://fanglabcode/default/6mascope:latest    # Download the image from cloud.sylabs.io; Make sure you have the network connection
singularity build --sandbox 6mASCOPE 6mASCOPE.sif     # Create a writable container named 6mASCOPE
singularity run --no-home -w 6mASCOPE    # Start an interactive shell to use 6mASCOPE, type `exit` to leave
init_6mASCOPE    #Inside the container; Only required once when start using 6mASCOPE
source run_6mASCOPE    #Inside the container; Required every time when running 6mASCOPE


# Usage: 6mASCOPE <subtasks> [parameters]
#     subtasks:
#       - deplex: De-multiplex subreads into individal files.
#       - ccs: Generate CCS .bam and .fasta files from short insert library sequencing data.
#       - ipd: Summarize the IPD and QV information for each molecule by reference-free method.
#       - contam: Estimate the contamination in the current sample.
#       - quant: Quantify deconvolution of the sample with defined groups.

6mASCOPE get_test_data

# GnuTLS: The TLS connection was non-properly terminated.
# Unable to establish SSL connection.

6mASCOPE contam -c test.ccs.fasta -r test.ref.fasta -o test.contam.estimate.txt

6mASCOPE quant -c test.ccs.fasta -i test.IPD.out.A -o test -r test.ref.fasta -s subgroup.txt

