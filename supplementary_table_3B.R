
library(tidyverse)
library(data.table)
library(dplyr)
library(ggplot2)
library(ggpubr)
library(arsenal)
library(hrbrthemes)
library(viridis)
library(patchwork)

load("D:/Habituation_manuscript/input_arrays/All_habituation.RData")


ERP_paired_analysis <- All_habituation

# Check if Subject matches row position in every subgroup the script builds, 
# if yes, the outlier indexing is correct throughout.

ERP_paired_analysis %>%
  group_by(Age, Group, ERP_feature, Stimulus) %>%
  summarise(ok = all(Subject == seq_len(n())), .groups = "drop") %>%
  filter(!ok)

# Result: 0 rows. Subject numbering matches row position in every subgroup,
# so the row indices stored during outlier detection correctly identify the
# participants removed in the subsequent %in% Subject step.

## P1 latency

# Adult TD
rm(list=setdiff(ls(), "ERP_paired_analysis"))
Adult_ERP <- ERP_paired_analysis[ERP_paired_analysis$Age == "Adult" , ]
Adult_TD_ERP <- Adult_ERP[Adult_ERP$Group == "TD" , ]
P1_time_TD <- Adult_TD_ERP[Adult_TD_ERP$ERP_feature=="P1_time", ]

## See if any sample needs to be excluded (three times stdev or mean)

# Get mean / stdev etc.. Standard 1

mean_S1 = mean ((P1_time_TD[P1_time_TD$Stimulus == "Standard 1" , ])$Value)
stdev_S1 = sd ((P1_time_TD[P1_time_TD$Stimulus == "Standard 1" , ])$Value)
three_times_stdev_S1 = 3*stdev_S1
lower_edge_S1 = mean_S1 - three_times_stdev_S1
higher_edge_S1 = mean_S1 + three_times_stdev_S1

# Find outliers and save them for future use Standard 1

Standard_1 <- P1_time_TD[P1_time_TD$Stimulus == "Standard 1" , ]

index_S1 <- c()
counter_S1 <- 0
for(i in 1:length(Standard_1$Value)){
  if (Standard_1$Value[i]<lower_edge_S1 || Standard_1$Value[i]>higher_edge_S1) {
    counter_S1 <- counter_S1 +1
    index_S1[counter_S1] = i;
  }
}


# Get mean / stdev etc.. Standard 2

mean_S2 = mean ((P1_time_TD[P1_time_TD$Stimulus == "Standard 2" , ])$Value)
stdev_S2 = sd ((P1_time_TD[P1_time_TD$Stimulus == "Standard 2" , ])$Value)
three_times_stdev_S2 = 3*stdev_S2
lower_edge_S2 = mean_S2 - three_times_stdev_S2
higher_edge_S2 = mean_S2 + three_times_stdev_S2

# Find outliers and save them for future use Standard 2

Standard_2 <- P1_time_TD[P1_time_TD$Stimulus == "Standard 2" , ]

index_S2 <- c()
counter_S2 <- 0
for(i in 1:length(Standard_2$Value)){
  if (Standard_2$Value[i]<lower_edge_S2 || Standard_2$Value[i]>higher_edge_S2) {
    counter_S2 <- counter_S2 +1
    index_S2[counter_S2] = i;
  }
}

# Combine index from S1 and S2 and if there is an outlier exclude remove from the data
drops <- c(index_S1,index_S2)
drops <- unique(drops)
P1_time_TD_2 <- P1_time_TD[ !(P1_time_TD$Subject %in% c(drops)), ]


## Winsorize outliers - replace with upper limit / lower limit

P1_time_wins_TD <- P1_time_TD_2 %>%
  group_by (Stimulus) %>%
  mutate (Value_wins = ifelse(Value>quantile(Value,0.75, na.rm =T) + 1.5 * IQR (Value, na.rm = T), 
                                 quantile(Value,0.75, na.rm =T) + 1.5 * IQR (Value, na.rm = T),
                                 ifelse(Value < quantile (Value, 0.25, na.rm = T) - 1.5 *IQR (Value, na.rm = T), 
                                        quantile (Value, 0.25, na.rm = T) - 1.5 *IQR (Value, na.rm = T), Value)))

## Keep some objects in the work space

objects_to_keep <- c("ERP_paired_analysis", "Adult_ERP", "P1_time_wins_TD","objects_to_keep") # List of objects you want to keep

# Remove all other objects

for (obj in ls()) {
  if (!(obj %in% objects_to_keep)) {
    rm(list = obj)
  }
}

rm(obj)


# Adult ASD

Adult_ASD_ERP <- Adult_ERP[Adult_ERP$Group == "ASD" , ]
P1_time_ASD <- Adult_ASD_ERP[Adult_ASD_ERP$ERP_feature=="P1_time", ]

## See if any sample needs to be excluded (three times stdev or mean)

# Get mean / stdev etc.. Standard 1

mean_S1 = mean ((P1_time_ASD[P1_time_ASD$Stimulus == "Standard 1" , ])$Value)
stdev_S1 = sd ((P1_time_ASD[P1_time_ASD$Stimulus == "Standard 1" , ])$Value)
three_times_stdev_S1 = 3*stdev_S1
lower_edge_S1 = mean_S1 - three_times_stdev_S1
higher_edge_S1 = mean_S1 + three_times_stdev_S1

# Find outliers and save them for future use Standard 1

Standard_1 <- P1_time_ASD[P1_time_ASD$Stimulus == "Standard 1" , ]

index_S1 <- c()
counter_S1 <- 0
for(i in 1:length(Standard_1$Value)){
  if (Standard_1$Value[i]<lower_edge_S1 || Standard_1$Value[i]>higher_edge_S1) {
    counter_S1 <- counter_S1 +1
    index_S1[counter_S1] = i;
  }
}


# Get mean / stdev etc.. Standard 2

mean_S2 = mean ((P1_time_ASD[P1_time_ASD$Stimulus == "Standard 2" , ])$Value)
stdev_S2 = sd ((P1_time_ASD[P1_time_ASD$Stimulus == "Standard 2" , ])$Value)
three_times_stdev_S2 = 3*stdev_S2
lower_edge_S2 = mean_S2 - three_times_stdev_S2
higher_edge_S2 = mean_S2 + three_times_stdev_S2

# Find outliers and save them for future use Standard 2

Standard_2 <- P1_time_ASD[P1_time_ASD$Stimulus == "Standard 2" , ]

index_S2 <- c()
counter_S2 <- 0
for(i in 1:length(Standard_2$Value)){
  if (Standard_2$Value[i]<lower_edge_S2 || Standard_2$Value[i]>higher_edge_S2) {
    counter_S2 <- counter_S2 +1
    index_S2[counter_S2] = i;
  }
}

# Combine index from S1 and S2 and if there is an outlier exclude remove from the data
drops <- c(index_S1,index_S2)
drops <- unique(drops)
P1_time_ASD_2 <- P1_time_ASD[ !(P1_time_ASD$Subject %in% c(drops)), ]


## Winsorize outliers - replace with upper limit / lower limit

P1_time_wins_ASD <- P1_time_ASD_2 %>%
  group_by (Stimulus) %>%
  mutate (Value_wins = ifelse(Value>quantile(Value,0.75, na.rm =T) + 1.5 * IQR (Value, na.rm = T), 
                              quantile(Value,0.75, na.rm =T) + 1.5 * IQR (Value, na.rm = T),
                              ifelse(Value < quantile (Value, 0.25, na.rm = T) - 1.5 *IQR (Value, na.rm = T), 
                                     quantile (Value, 0.25, na.rm = T) - 1.5 *IQR (Value, na.rm = T), Value)))

P1_time_wins <- rbind (P1_time_wins_TD, P1_time_wins_ASD)

P1_time_wins$Stimulus = as.factor(P1_time_wins$Stimulus)
P1_time_wins$Group = as.factor(P1_time_wins$Group)


## Keep some objects in the work space

objects_to_keep <- c("ERP_paired_analysis", "Adult_ERP", "p1", "P1_time_wins",
                     "P1_time_wins_ASD","P1_time_wins_TD","objects_to_keep") # List of objects you want to keep

# Remove all other objects

for (obj in ls()) {
  if (!(obj %in% objects_to_keep)) {
    rm(list = obj)
  }
}

rm(obj)

## ANOVA 

std1_TD_P1 <- P1_time_wins_TD[P1_time_wins_TD$Stimulus=='Standard 1', ]
std2_TD_P1 <- P1_time_wins_TD[P1_time_wins_TD$Stimulus=='Standard 2', ]

std1_ASD_P1 <- P1_time_wins_ASD[P1_time_wins_ASD$Stimulus=='Standard 1', ]
std2_ASD_P1 <- P1_time_wins_ASD[P1_time_wins_ASD$Stimulus=='Standard 2', ]


mean_std1_TD_P1 <- format(round(mean(std1_TD_P1$Value_wins), 3))
mean_std1_ASD_P1 <- format(round(mean(std1_ASD_P1$Value_wins), 3))
stdev_std1_TD_P1 = format(round(sd (std1_TD_P1$Value_wins), 3))
stdev_std1_ASD_P1 = format(round(sd (std1_ASD_P1$Value_wins), 3))

mean_std2_TD_P1 <- format(round(mean(std2_TD_P1$Value_wins), 3))
mean_std2_ASD_P1 <- format(round(mean(std2_ASD_P1$Value_wins), 3))
stdev_std2_TD_P1 = format(round(sd (std2_TD_P1$Value_wins), 3))
stdev_std2_ASD_P1 = format(round(sd (std2_ASD_P1$Value_wins), 3))


P1_time <- P1_time_wins
attach(P1_time)
mod1 <- lm(P1_time$Value_wins ~ P1_time$Group + P1_time$Stimulus + P1_time$Group:P1_time$Stimulus)
ANOVA <- summary(aov(mod1))
ANOVA


#################################

## N1 latency

# Adult TD
rm(list=setdiff(ls(), "ERP_paired_analysis"))
Adult_ERP <- ERP_paired_analysis[ERP_paired_analysis$Age == "Adult" , ]
Adult_TD_ERP <- Adult_ERP[Adult_ERP$Group == "TD" , ]
N1_time_TD <- Adult_TD_ERP[Adult_TD_ERP$ERP_feature=="N1_time", ]

## See if any sample needs to be excluded (three times stdev or mean)

# Get mean / stdev etc.. Standard 1

mean_S1 = mean ((N1_time_TD[N1_time_TD$Stimulus == "Standard 1" , ])$Value)
stdev_S1 = sd ((N1_time_TD[N1_time_TD$Stimulus == "Standard 1" , ])$Value)
three_times_stdev_S1 = 3*stdev_S1
lower_edge_S1 = mean_S1 - three_times_stdev_S1
higher_edge_S1 = mean_S1 + three_times_stdev_S1

# Find outliers and save them for future use Standard 1

Standard_1 <- N1_time_TD[N1_time_TD$Stimulus == "Standard 1" , ]

index_S1 <- c()
counter_S1 <- 0
for(i in 1:length(Standard_1$Value)){
  if (Standard_1$Value[i]<lower_edge_S1 || Standard_1$Value[i]>higher_edge_S1) {
    counter_S1 <- counter_S1 +1
    index_S1[counter_S1] = i;
  }
}


# Get mean / stdev etc.. Standard 2

mean_S2 = mean ((N1_time_TD[N1_time_TD$Stimulus == "Standard 2" , ])$Value)
stdev_S2 = sd ((N1_time_TD[N1_time_TD$Stimulus == "Standard 2" , ])$Value)
three_times_stdev_S2 = 3*stdev_S2
lower_edge_S2 = mean_S2 - three_times_stdev_S2
higher_edge_S2 = mean_S2 + three_times_stdev_S2

# Find outliers and save them for future use Standard 2

Standard_2 <- N1_time_TD[N1_time_TD$Stimulus == "Standard 2" , ]

index_S2 <- c()
counter_S2 <- 0
for(i in 1:length(Standard_2$Value)){
  if (Standard_2$Value[i]<lower_edge_S2 || Standard_2$Value[i]>higher_edge_S2) {
    counter_S2 <- counter_S2 +1
    index_S2[counter_S2] = i;
  }
}

# Combine index from S1 and S2 and if there is an outlier exclude remove from the data
drops <- c(index_S1,index_S2)
drops <- unique(drops)
N1_time_TD_2 <- N1_time_TD[ !(N1_time_TD$Subject %in% c(drops)), ]


## Winsorize outliers - replace with upper limit / lower limit

N1_time_wins_TD <- N1_time_TD_2 %>%
  group_by (Stimulus) %>%
  mutate (Value_wins = ifelse(Value>quantile(Value,0.75, na.rm =T) + 1.5 * IQR (Value, na.rm = T), 
                              quantile(Value,0.75, na.rm =T) + 1.5 * IQR (Value, na.rm = T),
                              ifelse(Value < quantile (Value, 0.25, na.rm = T) - 1.5 *IQR (Value, na.rm = T), 
                                     quantile (Value, 0.25, na.rm = T) - 1.5 *IQR (Value, na.rm = T), Value)))

## Keep some objects in the work space

objects_to_keep <- c("ERP_paired_analysis", "Adult_ERP", "N1_time_wins_TD","objects_to_keep") # List of objects you want to keep

# Remove all other objects

for (obj in ls()) {
  if (!(obj %in% objects_to_keep)) {
    rm(list = obj)
  }
}

rm(obj)


# Adult ASD

Adult_ASD_ERP <- Adult_ERP[Adult_ERP$Group == "ASD" , ]
N1_time_ASD <- Adult_ASD_ERP[Adult_ASD_ERP$ERP_feature=="N1_time", ]

## See if any sample needs to be excluded (three times stdev or mean)

# Get mean / stdev etc.. Standard 1

mean_S1 = mean ((N1_time_ASD[N1_time_ASD$Stimulus == "Standard 1" , ])$Value)
stdev_S1 = sd ((N1_time_ASD[N1_time_ASD$Stimulus == "Standard 1" , ])$Value)
three_times_stdev_S1 = 3*stdev_S1
lower_edge_S1 = mean_S1 - three_times_stdev_S1
higher_edge_S1 = mean_S1 + three_times_stdev_S1

# Find outliers and save them for future use Standard 1

Standard_1 <- N1_time_ASD[N1_time_ASD$Stimulus == "Standard 1" , ]

index_S1 <- c()
counter_S1 <- 0
for(i in 1:length(Standard_1$Value)){
  if (Standard_1$Value[i]<lower_edge_S1 || Standard_1$Value[i]>higher_edge_S1) {
    counter_S1 <- counter_S1 +1
    index_S1[counter_S1] = i;
  }
}


# Get mean / stdev etc.. Standard 2

mean_S2 = mean ((N1_time_ASD[N1_time_ASD$Stimulus == "Standard 2" , ])$Value)
stdev_S2 = sd ((N1_time_ASD[N1_time_ASD$Stimulus == "Standard 2" , ])$Value)
three_times_stdev_S2 = 3*stdev_S2
lower_edge_S2 = mean_S2 - three_times_stdev_S2
higher_edge_S2 = mean_S2 + three_times_stdev_S2

# Find outliers and save them for future use Standard 2

Standard_2 <- N1_time_ASD[N1_time_ASD$Stimulus == "Standard 2" , ]

index_S2 <- c()
counter_S2 <- 0
for(i in 1:length(Standard_2$Value)){
  if (Standard_2$Value[i]<lower_edge_S2 || Standard_2$Value[i]>higher_edge_S2) {
    counter_S2 <- counter_S2 +1
    index_S2[counter_S2] = i;
  }
}

# Combine index from S1 and S2 and if there is an outlier exclude remove from the data
drops <- c(index_S1,index_S2)
drops <- unique(drops)
N1_time_ASD_2 <- N1_time_ASD[ !(N1_time_ASD$Subject %in% c(drops)), ]


## Winsorize outliers - replace with upper limit / lower limit

N1_time_wins_ASD <- N1_time_ASD_2 %>%
  group_by (Stimulus) %>%
  mutate (Value_wins = ifelse(Value>quantile(Value,0.75, na.rm =T) + 1.5 * IQR (Value, na.rm = T), 
                              quantile(Value,0.75, na.rm =T) + 1.5 * IQR (Value, na.rm = T),
                              ifelse(Value < quantile (Value, 0.25, na.rm = T) - 1.5 *IQR (Value, na.rm = T), 
                                     quantile (Value, 0.25, na.rm = T) - 1.5 *IQR (Value, na.rm = T), Value)))

N1_time_wins <- rbind (N1_time_wins_TD, N1_time_wins_ASD)

N1_time_wins$Stimulus = as.factor(N1_time_wins$Stimulus)
N1_time_wins$Group = as.factor(N1_time_wins$Group)

class(N1_time_wins$Stimulus)
class(N1_time_wins$Group)


## Keep some objects in the work space

objects_to_keep <- c("ERP_paired_analysis", "Adult_ERP", "p1", "N1_time_wins",
                     "N1_time_wins_ASD","N1_time_wins_TD","objects_to_keep") # List of objects you want to keep

# Remove all other objects

for (obj in ls()) {
  if (!(obj %in% objects_to_keep)) {
    rm(list = obj)
  }
}

rm(obj)

## ANOVA 

std1_TD_N1 <- N1_time_wins_TD[N1_time_wins_TD$Stimulus=='Standard 1', ]
std2_TD_N1 <- N1_time_wins_TD[N1_time_wins_TD$Stimulus=='Standard 2', ]

std1_ASD_N1 <- N1_time_wins_ASD[N1_time_wins_ASD$Stimulus=='Standard 1', ]
std2_ASD_N1 <- N1_time_wins_ASD[N1_time_wins_ASD$Stimulus=='Standard 2', ]


mean_std1_TD_N1 <- format(round(mean(std1_TD_N1$Value_wins), 3))
mean_std1_ASD_N1 <- format(round(mean(std1_ASD_N1$Value_wins), 3))
stdev_std1_TD_N1 = format(round(sd (std1_TD_N1$Value_wins), 3))
stdev_std1_ASD_N1 = format(round(sd (std1_ASD_N1$Value_wins), 3))

mean_std2_TD_N1 <- format(round(mean(std2_TD_N1$Value_wins), 3))
mean_std2_ASD_N1 <- format(round(mean(std2_ASD_N1$Value_wins), 3))
stdev_std2_TD_N1 = format(round(sd (std2_TD_N1$Value_wins), 3))
stdev_std2_ASD_N1 = format(round(sd (std2_ASD_N1$Value_wins), 3))


N1_time <- N1_time_wins
attach(N1_time)
mod1 <- lm(N1_time$Value_wins ~ N1_time$Group + N1_time$Stimulus + N1_time$Group:N1_time$Stimulus)
ANOVA <- summary(aov(mod1))
ANOVA


#################################


## P2 latency

# Adult TD
rm(list=setdiff(ls(), "ERP_paired_analysis"))
Adult_ERP <- ERP_paired_analysis[ERP_paired_analysis$Age == "Adult" , ]
Adult_TD_ERP <- Adult_ERP[Adult_ERP$Group == "TD" , ]
P2_time_TD <- Adult_TD_ERP[Adult_TD_ERP$ERP_feature=="P2_time", ]

## See if any sample needs to be excluded (three times stdev or mean)

# Get mean / stdev etc.. Standard 1

mean_S1 = mean ((P2_time_TD[P2_time_TD$Stimulus == "Standard 1" , ])$Value)
stdev_S1 = sd ((P2_time_TD[P2_time_TD$Stimulus == "Standard 1" , ])$Value)
three_times_stdev_S1 = 3*stdev_S1
lower_edge_S1 = mean_S1 - three_times_stdev_S1
higher_edge_S1 = mean_S1 + three_times_stdev_S1

# Find outliers and save them for future use Standard 1

Standard_1 <- P2_time_TD[P2_time_TD$Stimulus == "Standard 1" , ]

index_S1 <- c()
counter_S1 <- 0
for(i in 1:length(Standard_1$Value)){
  if (Standard_1$Value[i]<lower_edge_S1 || Standard_1$Value[i]>higher_edge_S1) {
    counter_S1 <- counter_S1 +1
    index_S1[counter_S1] = i;
  }
}


# Get mean / stdev etc.. Standard 2

mean_S2 = mean ((P2_time_TD[P2_time_TD$Stimulus == "Standard 2" , ])$Value)
stdev_S2 = sd ((P2_time_TD[P2_time_TD$Stimulus == "Standard 2" , ])$Value)
three_times_stdev_S2 = 3*stdev_S2
lower_edge_S2 = mean_S2 - three_times_stdev_S2
higher_edge_S2 = mean_S2 + three_times_stdev_S2

# Find outliers and save them for future use Standard 2

Standard_2 <- P2_time_TD[P2_time_TD$Stimulus == "Standard 2" , ]

index_S2 <- c()
counter_S2 <- 0
for(i in 1:length(Standard_2$Value)){
  if (Standard_2$Value[i]<lower_edge_S2 || Standard_2$Value[i]>higher_edge_S2) {
    counter_S2 <- counter_S2 +1
    index_S2[counter_S2] = i;
  }
}

# Combine index from S1 and S2 and if there is an outlier exclude remove from the data
drops <- c(index_S1,index_S2)
drops <- unique(drops)
P2_time_TD_2 <- P2_time_TD[ !(P2_time_TD$Subject %in% c(drops)), ]


## Winsorize outliers - replace with upper limit / lower limit

P2_time_wins_TD <- P2_time_TD_2 %>%
  group_by (Stimulus) %>%
  mutate (Value_wins = ifelse(Value>quantile(Value,0.75, na.rm =T) + 1.5 * IQR (Value, na.rm = T), 
                              quantile(Value,0.75, na.rm =T) + 1.5 * IQR (Value, na.rm = T),
                              ifelse(Value < quantile (Value, 0.25, na.rm = T) - 1.5 *IQR (Value, na.rm = T), 
                                     quantile (Value, 0.25, na.rm = T) - 1.5 *IQR (Value, na.rm = T), Value)))

## Keep some objects in the work space

objects_to_keep <- c("ERP_paired_analysis", "Adult_ERP", "P2_time_wins_TD","objects_to_keep") # List of objects you want to keep

# Remove all other objects

for (obj in ls()) {
  if (!(obj %in% objects_to_keep)) {
    rm(list = obj)
  }
}

rm(obj)


# Adult ASD

Adult_ASD_ERP <- Adult_ERP[Adult_ERP$Group == "ASD" , ]
P2_time_ASD <- Adult_ASD_ERP[Adult_ASD_ERP$ERP_feature=="P2_time", ]

## See if any sample needs to be excluded (three times stdev or mean)

# Get mean / stdev etc.. Standard 1

mean_S1 = mean ((P2_time_ASD[P2_time_ASD$Stimulus == "Standard 1" , ])$Value)
stdev_S1 = sd ((P2_time_ASD[P2_time_ASD$Stimulus == "Standard 1" , ])$Value)
three_times_stdev_S1 = 3*stdev_S1
lower_edge_S1 = mean_S1 - three_times_stdev_S1
higher_edge_S1 = mean_S1 + three_times_stdev_S1

# Find outliers and save them for future use Standard 1

Standard_1 <- P2_time_ASD[P2_time_ASD$Stimulus == "Standard 1" , ]

index_S1 <- c()
counter_S1 <- 0
for(i in 1:length(Standard_1$Value)){
  if (Standard_1$Value[i]<lower_edge_S1 || Standard_1$Value[i]>higher_edge_S1) {
    counter_S1 <- counter_S1 +1
    index_S1[counter_S1] = i;
  }
}

# Get mean / stdev etc.. Standard 2

mean_S2 = mean ((P2_time_ASD[P2_time_ASD$Stimulus == "Standard 2" , ])$Value)
stdev_S2 = sd ((P2_time_ASD[P2_time_ASD$Stimulus == "Standard 2" , ])$Value)
three_times_stdev_S2 = 3*stdev_S2
lower_edge_S2 = mean_S2 - three_times_stdev_S2
higher_edge_S2 = mean_S2 + three_times_stdev_S2

# Find outliers and save them for future use Standard 2

Standard_2 <- P2_time_ASD[P2_time_ASD$Stimulus == "Standard 2" , ]

index_S2 <- c()
counter_S2 <- 0
for(i in 1:length(Standard_2$Value)){
  if (Standard_2$Value[i]<lower_edge_S2 || Standard_2$Value[i]>higher_edge_S2) {
    counter_S2 <- counter_S2 +1
    index_S2[counter_S2] = i;
  }
}

# Combine index from S1 and S2 and if there is an outlier exclude remove from the data
drops <- c(index_S1,index_S2)
drops <- unique(drops)
P2_time_ASD_2 <- P2_time_ASD[ !(P2_time_ASD$Subject %in% c(drops)), ]


## Winsorize outliers - replace with upper limit / lower limit

P2_time_wins_ASD <- P2_time_ASD_2 %>%
  group_by (Stimulus) %>%
  mutate (Value_wins = ifelse(Value>quantile(Value,0.75, na.rm =T) + 1.5 * IQR (Value, na.rm = T), 
                              quantile(Value,0.75, na.rm =T) + 1.5 * IQR (Value, na.rm = T),
                              ifelse(Value < quantile (Value, 0.25, na.rm = T) - 1.5 *IQR (Value, na.rm = T), 
                                     quantile (Value, 0.25, na.rm = T) - 1.5 *IQR (Value, na.rm = T), Value)))

P2_time_wins <- rbind (P2_time_wins_TD, P2_time_wins_ASD)

P2_time_wins$Stimulus = as.factor(P2_time_wins$Stimulus)
P2_time_wins$Group = as.factor(P2_time_wins$Group)

class(P2_time_wins$Stimulus)
class(P2_time_wins$Group)


## Keep some objects in the work space

objects_to_keep <- c("ERP_paired_analysis", "Adult_ERP", "P1", "P2_time_wins",
                     "P2_time_wins_ASD","P2_time_wins_TD","objects_to_keep") # List of objects you want to keep

# Remove all other objects

for (obj in ls()) {
  if (!(obj %in% objects_to_keep)) {
    rm(list = obj)
  }
}

rm(obj)

## ANOVA 

std1_TD_P2 <- P2_time_wins_TD[P2_time_wins_TD$Stimulus=='Standard 1', ]
std2_TD_P2 <- P2_time_wins_TD[P2_time_wins_TD$Stimulus=='Standard 2', ]

std1_ASD_P2 <- P2_time_wins_ASD[P2_time_wins_ASD$Stimulus=='Standard 1', ]
std2_ASD_P2 <- P2_time_wins_ASD[P2_time_wins_ASD$Stimulus=='Standard 2', ]


mean_std1_TD_P2 <- format(round(mean(std1_TD_P2$Value_wins), 3))
mean_std1_ASD_P2 <- format(round(mean(std1_ASD_P2$Value_wins), 3))
stdev_std1_TD_P2 = format(round(sd (std1_TD_P2$Value_wins), 3))
stdev_std1_ASD_P2 = format(round(sd (std1_ASD_P2$Value_wins), 3))

mean_std2_TD_P2 <- format(round(mean(std2_TD_P2$Value_wins), 3))
mean_std2_ASD_P2 <- format(round(mean(std2_ASD_P2$Value_wins), 3))
stdev_std2_TD_P2 = format(round(sd (std2_TD_P2$Value_wins), 3))
stdev_std2_ASD_P2 = format(round(sd (std2_ASD_P2$Value_wins), 3))

P2_time <- P2_time_wins
attach(P2_time)
mod1 <- lm(P2_time$Value_wins ~ P2_time$Group + P2_time$Stimulus + P2_time$Group:P2_time$Stimulus)
ANOVA <- summary(aov(mod1))
ANOVA

## END
