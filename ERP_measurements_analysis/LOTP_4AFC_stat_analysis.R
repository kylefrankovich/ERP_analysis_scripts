# statistical analysis for LOTP_4AFC_ERP

library(ez)
library(dplyr)
library(ggplot2)

setwd("~/Desktop/ERP_analysis_scripts/ERP_measurements_analysis")

## load data:

# files:
# blocked_correct_resp_N2pc.txt
# blocked_correct_resp_SPCN.txt
# mixed_correct_resp_N2pc.txt
# mixed_correct_resp_SPCN.txt

# blocked_all_resp_N2pc.txt
# blocked_all_resp_SPCN.txt
# mixed_all_resp_N2pc.txt
# mixed_all_resp_SPCN.txt

# only correct responses:

df_blocked_correct_N2pc <- read.table('blocked_correct_resp_N2pc.txt', 
                                    sep="\t", header = TRUE)

head(df_blocked_correct_N2pc)


df_blocked_correct_SPCN <- read.table('blocked_correct_resp_SPCN.txt', 
                                      sep="\t", header = TRUE)

df_mixed_correct_N2pc <- read.table('mixed_correct_resp_N2pc.txt', 
                                      sep="\t", header = TRUE)

df_mixed_correct_SPCN <- read.table('mixed_correct_resp_SPCN.txt', 
                                    sep="\t", header = TRUE)

# all responses:

df_blocked_all_resp_N2pc <- read.table('blocked_all_resp_N2pc.txt', 
                                      sep="\t", header = TRUE)

df_blocked_all_resp_SPCN <- read.table('blocked_all_resp_SPCN.txt', 
                                      sep="\t", header = TRUE)

df_mixed_all_resp_N2pc <- read.table('mixed_all_resp_N2pc.txt', 
                                    sep="\t", header = TRUE)

df_mixed_all_resp_SPCN <- read.table('mixed_all_resp_SPCN.txt', 
                                    sep="\t", header = TRUE)


# stats:

## blocked, correct, N2pc: df_blocked_correct_N2pc
View(df_blocked_correct_N2pc)

df_blocked_correct_N2pc$bini = factor(df_blocked_correct_N2pc$bini)

class(df_blocked_correct_N2pc$bini)

# occipital stats:


df_blocked_correct_N2pc_occip = filter(df_blocked_correct_N2pc, chindex == 12)

View(df_blocked_correct_N2pc_occip)

blocked_correct_N2pc_occip_anova = ezANOVA(
  data = df_blocked_correct_N2pc_occip
  , dv = .(value)
  , wid = .(ERPset)
  , within = .(bini)
)

print(blocked_correct_N2pc_occip_anova)

blocked_correct_N2pc_occip_anova_data_output = ezStats(
  data = df
  , dv = .(Correct)
  , wid = .(SubID)
  , within = .(TOA,trainLength)
)

ezPlot(
  data = df
  , dv = .(Correct)
  , wid = .(SubID)
  , within = .(TOA, trainLength)
  , x = trainLength
)







