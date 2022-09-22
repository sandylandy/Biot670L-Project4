#!/bin/bash


for f1 in *_R1.fastq.gz; do
    base=${f1%_R1.fastq.gz}  # Strip _R1.fastq.gz, leaving File1, File2, etc
    f2=${f1%_R1.fastq.gz}_R2.fastq.gz  # add _R2.fastq.gz to get File1_R2.fastq.gz, etc
    ...
done
wget https://ftp.ncbi.nlm.nih.gov/genomes/genbank/bacteria/Bacillus_thuringiensis/all_assembly_versions/GCA_021651035.1_ASM2165103v1/GCA_021651035.1_ASM2165103v1_genomic.fna.gz
find . -name '*.fna' -exec rename 's/\.fna$/.fasta/' \{} \;
REF = *.fasta

#fastqinfor-2.0.sh must be downloaded into the file
#REF file to be downloaded into the folder 

#Kiu R, fastq-info: compute estimated sequencing depth (coverage) of prokaryotic genomes, GitHub https://github.com/raymondkiu/fastq-info

$ sh ./fastqinfo-2.sh -r 125 $f1 $f2 $REF;

