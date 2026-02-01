#!/bin/bash
# SMR run for all chromosomes + combine results

# Paths
SMR_BIN=~/Desktop/SMR_RERUN/smr_Linux
GWAS_SUM=/home/laraib/Desktop/hannon/ocd_smr_ready.txt
MQTL_DIR=/home/laraib/Desktop/LBC/LBC_BSGS_meta_lite
LDREF_DIR=/home/laraib/Desktop/hannon/LDREF
OUT_DIR=/home/laraib/Desktop/LBC/results_GWAS_mQTL_SMR  # <- updated

# Create output directory if not exists
mkdir -p $OUT_DIR

# Loop over chromosomes 1-22
for chr in {1..22}
do
    echo "Running SMR for chromosome $chr..."
    
    BFILE=${LDREF_DIR}/ldref_chr$chr
    BEQTL_SUM=${MQTL_DIR}/bl_mqtl_lite_chr$chr
    
    # Check if files exist
    if [ ! -f ${BFILE}.fam ] || [ ! -f ${BEQTL_SUM}.esi ]; then
        echo "Files missing for chromosome $chr. Skipping..."
        continue
    fi

    $SMR_BIN \
    --bfile $BFILE \
    --gwas-summary $GWAS_SUM \
    --beqtl-summary $BEQTL_SUM \
    --chr $chr \
    --out $OUT_DIR/ocd_LBC_mQTL_chr$chr

    echo "Finished chromosome $chr"
done

echo "All chromosomes completed!"

# -------------------------------
# Combine all SMR results into one
# -------------------------------
COMBINED_FILE=$OUT_DIR/ocd_LBC_mQTL_allchr.smr

# Take header from first chromosome
head -n 1 $OUT_DIR/ocd_LBC_mQTL_chr1.smr > $COMBINED_FILE

# Append all chromosome results without headers
for chr in {1..22}; do
    tail -n +2 $OUT_DIR/ocd_LBC_mQTL_chr$chr.smr >> $COMBINED_FILE
done

echo "All chromosome results combined into $COMBINED_FILE"
