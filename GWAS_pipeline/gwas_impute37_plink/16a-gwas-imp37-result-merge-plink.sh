#!/bin/sh

# This script combines all the plink2 result files into a single cohort file.

# Requirements: 
# 0-4 - please refer to readme.md
# 5. Must have executed: 
# - 11a-gwas-s2-imp37-qc-filter.sh
# - 15a-gwas-plink37.sh

# How to Run:
# Run this shell script using: 
#   sh 16a-gwas-imp37-result-merge-plink.sh 
# on the command line on your own machine

# Inputs (for each chromosome):
# Note that you can adjust the output directory by setting the data_file_dir variable
# - /Data/ap_imp37_gwas/plink/ukb23158_AP_c1_v1.AP.glm.logistic.hybrid - plink2 results for chromosome 1 
# - /Data/ap_imp37_gwas/plink/ukb23158_AP_c2_v1.AP.glm.logistic.hybrid - plink2 results for chromosome 2 
# - /Data/ap_imp37_gwas/plink/ukb23158_AP_c3_v1.AP.glm.logistic.hybrid - plink2 results for chromosome 3 
# - /Data/ap_imp37_gwas/plink/ukb23158_AP_c4_v1.AP.glm.logistic.hybrid - plink2 results for chromosome 4 
# - etc.

# Output :
# - /data/ap_imp37_gwas/assoc.log.plink.merged.txt - merged results for all chromosomes in tab-delimited format

# Steps:
# 1. Use dxFUSE to mount project data dir
# 2. add the header back to the top of the merged file with echo command
# 3.  for loop  each .hybrid file
#       remove header with tail
#       transform to tab delimited with tr
#       save it into $out_file

data_file_dir="/data/ap_imp37_gwas"

merge_cmd='out_file="assoc.log.plink.merged.txt"

echo -e "CHROM\tPOS\tID\tREF\tALT\tA1\tFIRTH\tTEST\tOBS_CT\tOR\tLOG(OR)_SE\tZ_STAT\tP\tERRCODE" > $out_file

files="/mnt/project/data/ap_imp37_gwas/plink/*.hybrid"
for f in $files
do
   tail -n+2 $f | tr " " "\t" >> $out_file
done '



dx run swiss-army-knife -iin="/${data_file_dir}/ukb22828_AP_c2_v3.AP.glm.logistic.hybrid" \
   -icmd="${merge_cmd}" --tag="Step1" --instance-type "mem1_ssd1_v2_x16"\
   --destination="${project}:/data/ap_imp37_gwas/" --brief --yes 
