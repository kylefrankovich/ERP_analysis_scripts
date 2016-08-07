# statistical analysis for behavioral data of ERP experiment

library(dplyr)
library(ggplot2)

# error bars weren't working due to a conflict w/ dplyr and plyr:
# http://www.mm1886.com/0429/dplyr-error-in-n-function-should-not-be-called-directly/

# stat_summary also had an error: Warning message:
# Computation failed in `stat_summary()`:
#   Hmisc package required for this function 
# had to re-install Hmisc0

# Load Data
df <- read.table('LOTP_4AFC_ERP2_behavioral_data.txt', stringsAsFactor = FALSE, header = TRUE)

plot_path = ("~/Box Sync/ERP_experiment_data/LOTP_4AFC_plots/")

head(df)

# subject number

length(unique(df$SubID))

# find subject means
sub.mn <- df %>%
  group_by(TOA, Blocked, SubID) %>%
  summarise(
    mrt = mean(RT),
    acc = mean(Correct))

# group means
grp.mn <- summarise(sub.mn,
                    grt = mean(mrt),
                    gac = mean(acc))


# Normalize ACC
sub.mn <- sub.mn %>%
  group_by(SubID) %>%
  mutate(
    submean = mean(acc)) %>%
  ungroup() %>%
  mutate(
    grandmn = mean(acc)) %>%
  group_by(TOA, Blocked, SubID) %>%
  mutate(
    acc.nor = (acc - submean) + grandmn)


# plot normalized ACC
ggplot(sub.mn, aes(Blocked, acc.nor, color = factor(TOA)))+
  labs(x = 'Blocked v. Mixed', y = 'Accuracy (%)', color = 'TOA (ms)')+
  scale_x_continuous(breaks = 1:2)+
  scale_y_continuous(labels = function(x) x * 100)+
  stat_summary(fun.data = mean_cl_normal, geom = 'pointrange', size = 1.5) +
  stat_summary(fun.y = mean, geom = 'line', size = 1.5) +
  theme_bw(base_size = 20)


ggsave(file = "LOTP_mk4_behavioral_perf_rstudio.pdf", path = plot_path, width = 8, height = 6)



# error bars not working, look at this example:


tg <- ToothGrowth

tgc <- summarySE(tg, measurevar="len", groupvars=c("supp","dose"))

# Use dose as a factor rather than numeric
tgc2 <- tgc
tgc2$dose <- factor(tgc2$dose)

# Error bars represent standard error of the mean
ggplot(tgc2, aes(x=dose, y=len, fill=supp)) + 
  geom_bar(position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymin=len-se, ymax=len+se),
                width=.2,                    # Width of the error bars
                position=position_dodge(.9))


df2 <- summarySE(df, measurevar="Correct", groupvars=c("TOA","Blocked"))
df2 <- df

df2$TOA = factor(df2$TOA)
class(df2$TOA)
df2$Blocked = factor(df2$Blocked)
class(df2$Blocked)




## Summarizes data.
## Gives count, mean, standard deviation, standard error of the mean, and confidence interval (default 95%).
##   data: a data frame.
##   measurevar: the name of a column that contains the variable to be summariezed
##   groupvars: a vector containing names of columns that contain grouping variables
##   na.rm: a boolean that indicates whether to ignore NA's
##   conf.interval: the percent range of the confidence interval (default is 95%)
summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                      conf.interval=.95, .drop=TRUE) {
  library(plyr)
  
  # New version of length which can handle NA's: if na.rm==T, don't count them
  length2 <- function (x, na.rm=FALSE) {
    if (na.rm) sum(!is.na(x))
    else       length(x)
  }
  
  # This does the summary. For each group's data frame, return a vector with
  # N, mean, and sd
  datac <- ddply(data, groupvars, .drop=.drop,
                 .fun = function(xx, col) {
                   c(N    = length2(xx[[col]], na.rm=na.rm),
                     mean = mean   (xx[[col]], na.rm=na.rm),
                     sd   = sd     (xx[[col]], na.rm=na.rm)
                   )
                 },
                 measurevar
  )
  
  # Rename the "mean" column    
  datac <- rename(datac, c("mean" = measurevar))
  
  datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean
  
  # Confidence interval multiplier for standard error
  # Calculate t-statistic for confidence interval: 
  # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
  ciMult <- qt(conf.interval/2 + .5, datac$N-1)
  datac$ci <- datac$se * ciMult
  
  return(datac)
}

