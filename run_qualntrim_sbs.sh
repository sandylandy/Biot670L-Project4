#!/usr/bin/bash

#This script will
#1) Quality check a set of short-reads with FastQC
#2) Trim the reads with Trimmomatic

#Dependencies
#You should already have pulled the docker images for FastQC and Trimmomatic from:
#https://hub.docker.com/r/pegi3s/fastqc/
#https://hub.docker.com/r/staphb/trimmomatic/
#Make sure Docker Desktop is running


#HELP function
function HELP {
echo ""
echo "Usage:" $0
echo "			-i path/to/dir/			directory holding reads"
echo ""
echo "Example: $0 -i /path/to/dir"
echo ""
exit 0
}

#Take arguments
#Run HELP if -h -? or invalid input
#Set READS to -i
while getopts ":hi:" option; do
	case ${option} in
		h)
		HELP
		;;
		i)
		export READS=${OPTARG}
		;;
		\?)
		echo "Invalid option: ${OPTARG}" 1>&2
		HELP
		;;
	esac
done

#Check if all parameters are filled
if [[ -z "${READS}" ]]; then
	echo ""
	echo "All flags required."
	HELP
fi

#Check if directory exists
if [[ -d ${READS} ]]; then
	echo ""
	echo "Path to reads set to: " $READS
	echo ""
else
	echo ""
	echo "Could not validate directory. Please check and try again."
	HELP
fi


yesnextstep () { echo "The program will start"; }

noredo () { echo "Start docker desktop"; }



echo "Is docker desktop running? (yes or no)"

read yesorno 

#check user's answer if yes countine running program
if [ "$yesorno" = yes ]; then  
		yesnextstep
else
	echo "You entered no start Docker Desktop and re run-script"
	exit 0
fi



#Quality check reads with FastQC
echo Runninig FastQC 
docker run -t --rm -u $(id -u):$(id -g) -v $(pwd):/data:rw -w /data pegi3s/fastqc -t 6 --extract ${READS}/*.fastq*

#Clean up FastQC files
mkdir -pv ${READS}/fastqc/
rm -r ${READS}/*.zip
mv ${READS}/*_fastqc* ${READS}/fastqc
echo "FastQC Files in fastqc"

#Get input reads file paths for trimmomatic
read1=$(ls ${READS} | sed -n '/_1/p')
read2=$(ls ${READS} | sed -n '/_2/p')

#Trim reads using trimmomatic
echo Running trimmomatic this will take some time, grab a drink, stretch, or daydream. 
docker run -t --rm -u $(id -u):$(id -g) -v $(pwd):/data:rw staphb/trimmomatic trimmomatic PE ${READS}/${read1} ${READS}/${read2} output_forward_paired.fq.gz output_forward_unpaired.fq.gz output_reverse_paired.fq.gz output_reverse_unpaired.fq.gz ILLUMINACLIP:/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10:2:True LEADING:3 TRAILING:3 MINLEN:36

#Clean up trimmomatic output
mkdir -pv ${READS}/trimmomatic0.39/
mv output* ${READS}/trimmomatic0.39/
echo "Trimmed file in trimmomatic0.39"


