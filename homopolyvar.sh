#!/bin/bash

input="test.vcf" # input VCF file in any format accepted by bcftools

ref="/srv/ngs/analysis/nando/references/Homo_sapiens/GATK/GRCh37/Sequence/WholeGenomeFasta/human_g1k_v37_decoy.fasta" # reference genome in fasta format 

bcftools view -HG $input | cut -f1-5 | awk '$4!~"^[ACGT]($|,)" || $5!~"^[ACGT]($|,)"' |
  awk '{print $1"\t"$2+length($4)-1"\t"$2+length($4)+5"\t"$3}' |
  bedtools getfasta -name -fi $ref -bed /dev/stdin -fo /dev/stdout |
  awk 'NR%2==1 {printf substr($0,2)"\t"} NR%2==0' |
  grep "AAAAA$\|CCCCC$\|GGGGG$\|TTTTT$" | cut -f1 | sort > variants.in.homopolymers.txt
