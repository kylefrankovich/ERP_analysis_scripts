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


# filtered data frames/factorization:

# correct responses:
df_blocked_correct_N2pc$bini = factor(df_blocked_correct_N2pc$bini)
df_blocked_correct_N2pc_occip = filter(df_blocked_correct_N2pc, chindex == 12)
df_blocked_correct_N2pc_PO7_PO8 = filter(df_blocked_correct_N2pc, chindex == 9)

df_blocked_correct_SPCN$bini = factor(df_blocked_correct_SPCN$bini)
df_blocked_correct_SPCN_occip = filter(df_blocked_correct_SPCN, chindex == 12)
df_blocked_correct_SPCN_PO7_PO8 = filter(df_blocked_correct_SPCN, chindex == 9)

df_mixed_correct_N2pc$bini = factor(df_mixed_correct_N2pc$bini)
df_mixed_correct_N2pc_occip = filter(df_mixed_correct_N2pc, chindex == 12)
df_mixed_correct_N2pc_PO7_PO8 = filter(df_mixed_correct_N2pc, chindex == 9)

df_mixed_correct_SPCN$bini = factor(df_mixed_correct_SPCN$bini)
df_mixed_correct_SPCN_occip = filter(df_mixed_correct_SPCN, chindex == 12)
df_mixed_correct_SPCN_PO7_PO8 = filter(df_mixed_correct_SPCN, chindex == 9)

# all responses
df_blocked_all_resp_N2pc$bini = factor(df_blocked_all_resp_N2pc$bini)
df_blocked_all_resp_N2pc_occip = filter(df_blocked_all_resp_N2pc, chindex == 12)
df_blocked_all_resp_N2pc_PO7_PO8 = filter(df_blocked_all_resp_N2pc, chindex == 9)

df_blocked_all_resp_SPCN$bini = factor(df_blocked_all_resp_SPCN$bini)
df_blocked_all_resp_SPCN_occip = filter(df_blocked_all_resp_SPCN, chindex == 12)
df_blocked_all_resp_SPCN_PO7_PO8 = filter(df_blocked_all_resp_SPCN, chindex == 9)

df_mixed_all_resp_N2pc$bini = factor(df_mixed_all_resp_N2pc$bini)
df_mixed_all_resp_N2pc_occip = filter(df_mixed_all_resp_N2pc, chindex == 12)
df_mixed_all_resp_N2pc_PO7_PO8 = filter(df_mixed_all_resp_N2pc, chindex == 9)

df_mixed_all_resp_SPCN$bini = factor(df_mixed_all_resp_SPCN$bini)
df_mixed_all_resp_SPCN_occip = filter(df_mixed_all_resp_SPCN, chindex == 12)
df_mixed_all_resp_SPCN_PO7_PO8 = filter(df_mixed_all_resp_SPCN, chindex == 9)


electrode_site = 'occip' # 'occip' or 'PO7_PO8'
# electrode_site = 'PO7_PO8'
condition = 'mixed'
# condition = 'blocked'
# response = 'correct'
response = 'all_resp'
time_window = 'SPCN'
# time_window = 'N2pc'

data_frame = paste('df',condition,response,time_window,electrode_site, sep = "_")
data_frame

current_anova = ezANOVA(
  data = eval(parse(text = data_frame))
  , dv = .(value)
  , wid = .(ERPset)
  , within = .(bini)
)

print(current_anova)

current_anova_data_output = ezStats(
  data = eval(parse(text = data_frame))
  , dv = .(value)
  , wid = .(ERPset)
  , within = .(bini)
)

print(current_anova_data_output)

ezPlot(
  data = eval(parse(text = data_frame))
  , dv = .(value)
  , wid = .(ERPset)
  , within = .(bini)
  , x = bini
)


