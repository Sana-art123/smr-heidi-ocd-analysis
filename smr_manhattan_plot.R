library(ggplot2)
library(dplyr)

smr_file <- "/home/laraib/Desktop/SMR_EUR/smr_chr1.smr"
smr_data <- read.table(smr_file, header = TRUE, sep = "\t", stringsAsFactors = FALSE)

colnames(smr_data)

filtered_smr <- smr_data %>%
  filter(p_SMR < 5e-8 & p_HEIDI > 0.05)

ggplot(filtered_smr, aes(x = bp, y = -log10(p_SMR))) +
  geom_point(aes(color = as.factor(Chr)), alpha = 0.6) +
  scale_color_manual(values = rep(c("blue", "red"), 22)) +
  labs(title = "SMR Manhattan Plot (Chr1)",
       x = "Chromosome 1 Position (bp)",
       y = "-log10(p_SMR)",
       color = "Chromosome") +
  theme_minimal() +
  theme(legend.position = "none")

