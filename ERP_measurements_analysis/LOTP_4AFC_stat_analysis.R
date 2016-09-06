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

# blocked_all_resp_N2pc_12_sub.txt
# blocked_all_resp_SPCN_12_sub.txt

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

df_blocked_all_resp_N2pc_12_sub <- read.table('blocked_all_resp_N2pc_12_sub.txt', 
                                       sep="\t", header = TRUE)

df_blocked_all_resp_SPCN_12_sub <- read.table('blocked_all_resp_SPCN_12_sub.txt', 
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

# for overall anova (steve's notes):

df_blocked_all_resp_N2pc_12_sub$bini = factor(df_blocked_all_resp_N2pc_12_sub$bini)
df_blocked_all_resp_N2pc_12_sub_occip = filter(df_blocked_all_resp_N2pc_12_sub, chindex == 12)


df_blocked_all_resp_SPCN_12_sub$bini = factor(df_blocked_all_resp_SPCN_12_sub$bini)
df_blocked_all_resp_SPCN_12_sub_occip = filter(df_blocked_all_resp_SPCN_12_sub, chindex == 12)



df_mixed_all_resp_N2pc$bini = factor(df_mixed_all_resp_N2pc$bini)
df_mixed_all_resp_N2pc_occip = filter(df_mixed_all_resp_N2pc, chindex == 12)
df_mixed_all_resp_N2pc_PO7_PO8 = filter(df_mixed_all_resp_N2pc, chindex == 9)

df_mixed_all_resp_SPCN$bini = factor(df_mixed_all_resp_SPCN$bini)
df_mixed_all_resp_SPCN_occip = filter(df_mixed_all_resp_SPCN, chindex == 12)
df_mixed_all_resp_SPCN_PO7_PO8 = filter(df_mixed_all_resp_SPCN, chindex == 9)

# Steve's analysis notes:

# Hi Kyle.  I think you should go with all responses (now that it is working right).  
# Also, I think you should put blocked and mixed into a single ANOVA and add a 
# blocked/mixed factor.  You can then do separate analyses if there are any 
# significant differences between blocked and mixed (which I don’t think you’ll find).  
# This should increase our power.
# Which electrode sites are in the occipital average?  
# Is it all the P, PO, and O sites?

class(df_blocked_all_resp_N2pc_12_sub_occip$bini)
class(df_blocked_all_resp_SPCN_12_sub_occip$bini)

df_blocked_all_resp_N2pc_12_sub_occip$blocked = 1

df_blocked_all_resp_SPCN_12_sub_occip$blocked = 1

df_mixed_all_resp_N2pc_occip$blocked = 0

df_mixed_all_resp_SPCN_occip$blocked = 0

df_blocked_all_resp_N2pc_12_sub_occip$blocked = factor(df_blocked_all_resp_N2pc_12_sub_occip$blocked)
df_mixed_all_resp_N2pc_occip$blocked = factor(df_mixed_all_resp_N2pc_occip$blocked)

df_blocked_all_resp_SPCN_12_sub_occip$blocked = factor(df_blocked_all_resp_SPCN_12_sub_occip$blocked)
df_mixed_all_resp_SPCN_occip$blocked = factor(df_mixed_all_resp_SPCN_occip$blocked)



# combine blocked and mixed together:

# df_blocked_all_resp_N2pc_12_sub_occip 26 obs
# df_mixed_all_resp_N2pc_occip 

class(df_blocked_all_resp_N2pc_12_sub_occip$bini)
class(df_blocked_all_resp_N2pc_12_sub_occip$blocked)
class(df_blocked_all_resp_N2pc_12_sub_occip$value)

class(df_mixed_all_resp_N2pc_occip$bini)
class(df_mixed_all_resp_N2pc_occip$blocked)
class(df_mixed_all_resp_N2pc_occip$value)


class(df_blocked_all_resp_SPCN_occip$bini)
class(df_blocked_all_resp_SPCN_occip$value)



df_N2pc_blocked_mixed = bind_rows(df_blocked_all_resp_N2pc_12_sub_occip,
                                  df_mixed_all_resp_N2pc_occip)


df_N2pc_blocked_mixed$bini = factor(df_N2pc_blocked_mixed$bini)
df_N2pc_blocked_mixed$blocked = factor(df_N2pc_blocked_mixed$blocked)

class(df_N2pc_blocked_mixed$bini)
class(df_N2pc_blocked_mixed$blocked)
class(df_N2pc_blocked_mixed$value)

class(df_N2pc_blocked_mixed$ERPset)
length(unique(df_N2pc_blocked_mixed$ERPset))


test = select(df_N2pc_blocked_mixed, value, bini, ERPset, blocked)

class(test$value)
class(test$bini)
class(test$ERPset)
class(test$blocked)




# bini:
# 1 = blocked fast
# 2 = blocked slow
# 3 = mixed fast
# 4 = mixed slow

# sites recorded: (FP1/2, F3/4, F7/8, C3/4, P3/4, P5/6, P7/8, P9/10, P03/04, 
# P07/08, O1/2, Fz, Cz, Pz, POz, Oz, mastoid R/L, HEOG R/L, VEOG) 


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

View(eval(parse(text = data_frame)))

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








data(ANT2)
ANT2 = ANT2[!is.na(ANT2$rt),]

ezDesign(
  data = ANT2
  , x = trial
  , y = subnum
  , row = block
  , col = group
)


ezDesign(
  data = df_N2pc_blocked_mixed
  , x = bini
  , y = ERPset
  , row = block
  , col = blocked
)


current_anova = ezANOVA(
  data = test
  , dv = .(value)
  , wid = .(ERPset)
  , within = .(bini,blocked)
)

print(current_anova)

current_anova_data_output = ezStats(
  data = df_N2pc_blocked_mixed
  , dv = .(value)
  , wid = .(ERPset)
  , within = .(blocked)
)

print(current_anova_data_output)

ezPlot(
  data = df_N2pc_blocked_mixed
  , dv = .(value)
  , wid = .(ERPset)
  , within = .(bini,blocked)
  , x = bini
)


