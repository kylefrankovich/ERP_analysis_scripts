# statistical analysis for behavioral data of ERP experiment

library(dplyr)
library(ggplot2)

# error bars weren't working due to a conflict w/ dplyr and plyr:
# http://www.mm1886.com/0429/dplyr-error-in-n-function-should-not-be-called-directly/

# stat_summary also had an error: Warning message:
# Computation failed in `stat_summary()`:
#   Hmisc package required for this function 
# had to re-install Hmisc0

setwd("~/Desktop/ERP_analysis_scripts/ERP_measurements_analysis")

# Load Data
df <- read.table('LOTP_4AFC_ERP2_behavioral_data.txt', stringsAsFactor = FALSE, header = TRUE)

plot_path = ("~/Box Sync/ERP_experiment_data/LOTP_4AFC_plots/")

head(df)

# subject number

length(unique(df$SubID))


unique(df$SOA)


# load separate dataframe with all blocked data:

# need to add [1,5,6,7,8]

df_blocked_only = read.table('LOTP_4AFC_ERP2_behavioral_data_blocked_only_subs.txt', 
                             stringsAsFactor = FALSE, header = TRUE)



length(unique(df_blocked_only$SubID))

head(df_blocked_only)

# append blocked only onto df


df = bind_rows(df,df_blocked_only)


# # find subject means
# sub.mn <- df %>%
#   group_by(TOA, Blocked, SubID) %>%
#   summarise(
#     mrt = mean(RT),
#     acc = mean(Correct))

# find subject means
sub.mn <- df %>%
  mutate(
    cor = Correct == 1 & !is.na(Correct), selRT = RT < .7 & RT > .2 & cor == 1) %>%
  group_by(TOA, Blocked, SubID) %>%
  summarise(
    mrt = mean(RT[cor == 1]),
    rt2 = mean(RT[selRT == 1]),
    acc = mean(cor),
    acc2 = mean(selRT), # correct acc to use, appropriate RT values
    tnum = n(),
    chk = sum(Correct == 1 & !is.na(Correct)) / 128)

# Normalize ACC/RT
sub.mn <- sub.mn %>%
  group_by(SubID, Blocked) %>%
  mutate(
    submean = mean(acc2), subRTmean = mean(rt2)) %>%
  ungroup() %>%
  mutate(
    grandmn = mean(acc2), grandRTmn = mean(rt2)) %>%
  group_by(TOA, Blocked, SubID) %>%
  mutate(
    acc.nor = ((acc2 - submean) + grandmn), RT.nor = ((rt2 - subRTmean) + grandRTmn))

# # group means
# grp.mn <- summarise(sub.mn,
#                     grt = mean(mrt),
#                     gac = mean(acc))


# # Normalize ACC
# sub.mn <- sub.mn %>%
#   group_by(SubID) %>%
#   mutate(
#     submean = mean(acc)) %>%
#   ungroup() %>%
#   mutate(
#     grandmn = mean(acc)) %>%
#   group_by(TOA, Blocked, SubID) %>%
#   mutate(
#     acc.nor = (acc - submean) + grandmn)

# group means
grp.mn <- sub.mn %>%
  group_by(TOA, Blocked) %>%
  summarise(grt = mean(mrt),
            grt2 = mean(rt2),
            gac = mean(acc),
            gac2 = mean(acc2),
            chk = mean(chk))


# sequential analysis for non-blocked

lagpad <- function(x, k) {
  c(rep(NA, k), x)[1 : length(x)] 
}

# sequential subject means

seq.sub.mn <- filter(df, Blocked == 0) %>%
  mutate(
    seqTOA = lagpad(TOA,1), cor = Correct == 1 & !is.na(Correct), 
    selRT = RT < .7 & RT > .2 & cor == 1, cor.seq = lagpad(cor,1))  %>%
  group_by(seqTOA, SubID) %>%
  summarise(
    seqmrt = mean(RT[cor == 1]),
    seqrt2 = mean(RT[selRT == 1]),
    seqacc = mean(cor),
    seqacc2 = mean(selRT),
    # seqtnum = n(),
    seqchk = sum(Correct == 1 & !is.na(Correct)) / 128)


# Normalize ACC
seq.sub.mn <- filter(seq.sub.mn, seqTOA > 1) %>%
  group_by(SubID) %>%
  mutate(
    submean = mean(seqacc2), subRTmean = mean(seqrt2)) %>%
  ungroup() %>%
  mutate(
    grandmn = mean(seqacc2), grandRTmn = mean(seqrt2)) %>%
  group_by(seqTOA, SubID) %>%
  mutate(
    acc.nor = ((seqacc2 - submean) + grandmn), RT.nor = ((seqrt2 - subRTmean) + grandRTmn))



# sequential subject means (previous trial correct/incorrect)

seq.sub.mn.Corr.Analysis <- df %>%
  mutate(
    seqTOA = lagpad(TOA,1), cor = Correct == 1 & !is.na(Correct), 
    selRT = RT < .7 & RT > .2 & cor == 1, cor.seq = lagpad(selRT,1))  %>%
  group_by(TOA, Blocked, SubID) %>%
  summarise(
    seqmrt = mean(RT[cor == 1]),
    seqrt2 = mean(RT[selRT == 1]),
    seqacc = mean(cor),
    seqacc2 = mean(selRT[cor.seq == 0]), # accuracy when previous trial is incorrect
    seqacc3 = mean(selRT[cor.seq == 1]), # accuracy when previous trial is correct
    # seqtnum = n(),
    seqchk = sum(Correct == 1 & !is.na(Correct)) / 128)



# sequential group means

seq.grp.mn <- seq.sub.mn %>%
  group_by(seqTOA) %>%
  summarise(seqgrt = mean(seqmrt),
            seqgrt2 = mean(seqrt2),
            seqgac = mean(seqacc),
            seqgac2 = mean(seqacc2),
            seqchk = mean(seqchk))




##############################
##### plot group means #######
##############################


### acc

# blocked: 

ggplot(filter(sub.mn, Blocked == 1),
       aes(factor(TOA), acc.nor, fill = factor(TOA)))+ 
  stat_summary(fun.y = mean, geom = 'bar') + stat_summary(fun.data = mean_sdl, geom = 'linerange', 
                                                          color = 'red')+
  labs(x = 'TOA', y = 'Accuracy', title = '', fill = "TOA")+ 
  theme_bw(base_size = 20)

ggsave(file = "dissertation_figure_4_1_blocked_perf.pdf", path = plot_path, width = 6, height = 7)


# mixed: 

ggplot(filter(seq.sub.mn, seqTOA > 1),
       aes(factor(seqTOA), acc.nor, fill = factor(seqTOA)))+ 
  stat_summary(fun.y = mean, geom = 'bar')+ 
  stat_summary(fun.data = mean_sdl, geom = 'linerange', color = 'red')+
  labs(x = 'TOA', y = 'Accuracy', title = '', fill = "TOA")+ 
  theme_bw(base_size = 20)

ggsave(file = "dissertation_figure_4_3_mixed_perf.pdf", path = plot_path, width = 6, height = 7)

## acc sequential

# previous trial incorrect
ggplot(filter(seq.sub.mn.Corr.Analysis, Blocked == 1),
       aes(factor(TOA), seqacc2, fill = factor(TOA))) + stat_summary(fun.y = mean, geom = 'bar')+ 
  stat_summary(fun.data = mean_sdl, geom = 'linerange', color = 'red')+
  labs(x = 'TOA', y = 'Accuracy', title = 'Performance (Blocked), 
       previous trial incorrect', fill = "TOA")+ 
  theme_bw(base_size = 20)

# previous trial correct
ggplot(filter(seq.sub.mn.Corr.Analysis, Blocked == 1),
       aes(factor(TOA), seqacc3, fill = factor(TOA)))+ 
  stat_summary(fun.y = mean, geom = 'bar') + stat_summary(fun.data = mean_sdl, 
                                                          geom = 'linerange', color = 'red')+
  labs(x = 'TOA', y = 'Accuracy', title = 'Performance (Blocked), 
       previous trial correct', fill = "TOA")+ 
  theme_bw(base_size = 20)



### RT

# blocked: 

ggplot(filter(sub.mn, Blocked == 1),
       aes(factor(TOA), RT.nor, fill = factor(TOA)))+ 
  stat_summary(fun.y = mean, geom = 'bar') + stat_summary(fun.data = mean_sdl, 
                                                          geom = 'linerange', color = 'red')+
  labs(x = 'TOA', y = 'RT (ms)', title = "", fill = "TOA")+     
  theme_bw(base_size = 20)

ggsave(file = "dissertation_figure_4_2_blocked_rt.pdf", path = plot_path, width = 6, height = 7)

# mixed:

ggplot(filter(seq.sub.mn, seqTOA > 1),
       aes(factor(seqTOA), RT.nor, fill = factor(seqTOA)))+
  stat_summary(fun.y = mean, geom = 'bar') + stat_summary(fun.data = mean_sdl, 
                                                          geom = 'linerange', color = 'red')+
  labs(x = 'TOA', y = 'RT (ms)', title = "RT (Mixed)", fill = "TOA")+     
  theme_bw(base_size = 20)

ggsave(file = "dissertation_figure_4_4_mixed_rt.pdf", path = plot_path, width = 6, height = 7)



#################

##### stats #####

#################

library(ez)

stat.df <- df %>%
  mutate(
    cor = Correct == 1 & !is.na(Correct), selRT = RT < .7 & RT > .2 & cor == 1) 

# factorize!

stat.df$SubID = factor(stat.df$SubID)

stat.df$TOA = factor(stat.df$TOA)


# convert logical to numeric

stat.df$selRT = stat.df$selRT + 0 

class(stat.df$SubID)
class(stat.df$TOA)
class(stat.df$Correct)
class(stat.df$selRT)



nsubs = length(unique(df$SubID))

subSOA = mean(df$SOA)
rangeSOA = range(df$SOA)


# ANOVA time!

### PERFORMANCE ###

# anova comparing BLOCKED condition, 900 vs. 2000, only correct if RT b/w 200 and 700 ms

lotp_4AFC_blocked_anova = ezANOVA(
  data = filter(stat.df, Blocked == 1)
  , dv = .(selRT)
  , wid = .(SubID)
  , within = .(TOA)
  , detailed = FALSE
)

print(lotp_4AFC_blocked_anova)

lotp_4AFC_blocked_anova_data_output = ezStats(
  data = filter(stat.df, Blocked == 1)
  , dv = .(selRT)
  , wid = .(SubID)
  , within = .(TOA)
)


# anova comparing MIXED condition, 900 vs. 2000, only correct if RT b/w 200 and 700 ms

seq.stat.df <- filter(df, Blocked == 0) %>%
  mutate(
    seqTOA = lagpad(TOA,1), cor = Correct == 1 & !is.na(Correct), 
    selRT = RT < .7 & RT > .2 & cor == 1) 

seq.stat.df = filter(seq.stat.df, seqTOA >0)


# factorize!

seq.stat.df$SubID = factor(seq.stat.df$SubID)

seq.stat.df$seqTOA = factor(seq.stat.df$seqTOA)

class(seq.stat.df$seqTOA)

# convert logical to numeric

seq.stat.df$selRT = seq.stat.df$selRT + 0 

lotp_4AFC_mixed_anova = ezANOVA(
  data = seq.stat.df
  , dv = .(selRT)
  , wid = .(SubID)
  , within = .(seqTOA)
  , detailed = FALSE
)

print(lotp_4AFC_mixed_anova)

lotp_4AFC_mixed_anova_data_output = ezStats(
  data = seq.stat.df
  , dv = .(selRT)
  , wid = .(SubID)
  , within = .(seqTOA)
)



### RT ###


# BLOCKED

lotp_4AFC_blocked_anova_RT = ezANOVA(
  data = filter(stat.df, Blocked == 1, selRT == 1)
  , dv = .(RT)
  , wid = .(SubID)
  , within = .(TOA)
  , detailed = FALSE
)

print(lotp_4AFC_blocked_anova_RT)

lotp_4AFC_blocked_anova_RT_data_output = ezStats(
  data = filter(stat.df, Blocked == 1, selRT == 1)
  , dv = .(RT)
  , wid = .(SubID)
  , within = .(TOA)
)


# MIXED


lotp_4AFC_mixed_anova_RT = ezANOVA(
  data = filter(seq.stat.df, Blocked == 0, selRT == 1)
  , dv = .(RT)
  , wid = .(SubID)
  , within = .(seqTOA)
  , detailed = FALSE
)

print(lotp_4AFC_mixed_anova_RT)

lotp_4AFC_mixed_anova_RT_data_output = ezStats(
  data = filter(seq.stat.df, Blocked == 0, selRT == 1)
  , dv = .(RT)
  , wid = .(SubID)
  , within = .(seqTOA)
)



# 2x2 mixed/blocked anova:


# need to combine seq.stat.df and normal blocked stat.df


test.df = filter(stat.df, Blocked == 1)

seqStat_statDf.df = bind_rows(test.df,seq.stat.df)

stat.df$Blocked = factor(stat.df$Blocked)
class(stat.df$Blocked)

lotp_4AFC_blocked_mixed_anova_2x2 = ezANOVA(
  data = stat.df
  , dv = .(selRT)
  , wid = .(SubID)
  , within = .(TOA, Blocked)
  , detailed = FALSE
)

print(lotp_4AFC_blocked_mixed_anova_2x2)

lotp_4AFC_blocked_mixed_anova_2x2_data_output = ezStats(
  data = stat.df
  , dv = .(selRT)
  , wid = .(SubID)
  , within = .(TOA, Blocked)
)




