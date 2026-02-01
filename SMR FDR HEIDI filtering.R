# ================================
# SMR FDR + HEIDI filtering (LBC mQTL)
# ================================

# Set working directory
setwd("/home/laraib/Desktop/LBC/results")

# Read combined SMR results
smr <- read.table(
  "ocd_LBC_mQTL_allchr.smr",
  header = TRUE,
  stringsAsFactors = FALSE
)

# Check column names (optional but safe)
# print(colnames(smr))

# Apply FDR correction on SMR p-values
smr$FDR_SMR <- p.adjust(smr$p_SMR, method = "fdr")

# Define HEIDI pass/fail (HEIDI p > 0.01)
smr$HEIDI_pass <- smr$p_HEIDI > 0.01

# Save full results with FDR and HEIDI columns
write.table(
  smr,
  "ocd_LBC_mQTL_allchr_FDR_HEIDI.txt",
  row.names = FALSE,
  quote = FALSE,
  sep = "\t"
)

# Filter significant probes (FDR < 0.1 & HEIDI pass)
smr_sig <- subset(smr, FDR_SMR < 0.1 & HEIDI_pass)

# Save significant results only
write.table(
  smr_sig,
  "ocd_LBC_mQTL_allchr_FDR0.1_HEIDIpass.txt",
  row.names = FALSE,
  quote = FALSE,
  sep = "\t"
)

# Print number of significant probes
cat("Number of significant probes:", nrow(smr_sig), "\n")
