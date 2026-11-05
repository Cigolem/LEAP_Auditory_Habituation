
## Plot and and stats for N1 amplitude data 

# load All_habituation R data (location is: D:/Habituation_manuscript/input_arrays/All_habituation.R )

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

# Child TD
rm(list=setdiff(ls(), "ERP_paired_analysis"))
Child_ERP <- ERP_paired_analysis[ERP_paired_analysis$Age == "Child" , ]
Child_TD_ERP <- Child_ERP[Child_ERP$Group == "TD" , ]
N1_amp_TD <- Child_TD_ERP[Child_TD_ERP$ERP_feature=="N1_amp", ]

## See if any sample needs to be excluded (three times stdev or mean)

# Get mean / stdev etc.. Standard 1

mean_S1 = mean ((N1_amp_TD[N1_amp_TD$Stimulus == "Standard 1" , ])$Value)
stdev_S1 = sd ((N1_amp_TD[N1_amp_TD$Stimulus == "Standard 1" , ])$Value)
three_times_stdev_S1 = 3*stdev_S1
lower_edge_S1 = mean_S1 - three_times_stdev_S1
higher_edge_S1 = mean_S1 + three_times_stdev_S1

# Find outliers and save them for future use Standard 1

Standard_1 <- N1_amp_TD[N1_amp_TD$Stimulus == "Standard 1" , ]

index_S1 <- c()
counter_S1 <- 0
for(i in 1:length(Standard_1$Value)){
  if (Standard_1$Value[i]<lower_edge_S1 || Standard_1$Value[i]>higher_edge_S1) {
    counter_S1 <- counter_S1 +1
    index_S1[counter_S1] = i;
  }
}


# Get mean / stdev etc.. Standard 2

mean_S2 = mean ((N1_amp_TD[N1_amp_TD$Stimulus == "Standard 2" , ])$Value)
stdev_S2 = sd ((N1_amp_TD[N1_amp_TD$Stimulus == "Standard 2" , ])$Value)
three_times_stdev_S2 = 3*stdev_S2
lower_edge_S2 = mean_S2 - three_times_stdev_S2
higher_edge_S2 = mean_S2 + three_times_stdev_S2

# Find outliers and save them for future use Standard 2

Standard_2 <- N1_amp_TD[N1_amp_TD$Stimulus == "Standard 2" , ]

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
N1_amp_TD_2 <- N1_amp_TD[ !(N1_amp_TD$Subject %in% c(drops)), ]


## Winsorize outliers - replace with upper limit / lower limit

N1_amp_wins_TD <- N1_amp_TD_2 %>%
  group_by (Stimulus) %>%
  mutate (Value_wins = ifelse(Value>quantile(Value,0.75, na.rm =T) + 1.5 * IQR (Value, na.rm = T), 
                              quantile(Value,0.75, na.rm =T) + 1.5 * IQR (Value, na.rm = T),
                              ifelse(Value < quantile (Value, 0.25, na.rm = T) - 1.5 *IQR (Value, na.rm = T), 
                                     quantile (Value, 0.25, na.rm = T) - 1.5 *IQR (Value, na.rm = T), Value)))

## Keep some objects in the work space

objects_to_keep <- c("ERP_paired_analysis", "Child_ERP", "N1_amp_wins_TD","objects_to_keep") # List of objects you want to keep

# Remove all other objects

for (obj in ls()) {
  if (!(obj %in% objects_to_keep)) {
    rm(list = obj)
  }
}

rm(obj)


# Child ASD

Child_ASD_ERP <- Child_ERP[Child_ERP$Group == "ASD" , ]
N1_amp_ASD <- Child_ASD_ERP[Child_ASD_ERP$ERP_feature=="N1_amp", ]

## See if any sample needs to be excluded (three times stdev or mean)

# Get mean / stdev etc.. Standard 1

mean_S1 = mean ((N1_amp_ASD[N1_amp_ASD$Stimulus == "Standard 1" , ])$Value)
stdev_S1 = sd ((N1_amp_ASD[N1_amp_ASD$Stimulus == "Standard 1" , ])$Value)
three_times_stdev_S1 = 3*stdev_S1
lower_edge_S1 = mean_S1 - three_times_stdev_S1
higher_edge_S1 = mean_S1 + three_times_stdev_S1

# Find outliers and save them for future use Standard 1

Standard_1 <- N1_amp_ASD[N1_amp_ASD$Stimulus == "Standard 1" , ]

index_S1 <- c()
counter_S1 <- 0
for(i in 1:length(Standard_1$Value)){
  if (Standard_1$Value[i]<lower_edge_S1 || Standard_1$Value[i]>higher_edge_S1) {
    counter_S1 <- counter_S1 +1
    index_S1[counter_S1] = i;
  }
}


# Get mean / stdev etc.. Standard 2

mean_S2 = mean ((N1_amp_ASD[N1_amp_ASD$Stimulus == "Standard 2" , ])$Value)
stdev_S2 = sd ((N1_amp_ASD[N1_amp_ASD$Stimulus == "Standard 2" , ])$Value)
three_times_stdev_S2 = 3*stdev_S2
lower_edge_S2 = mean_S2 - three_times_stdev_S2
higher_edge_S2 = mean_S2 + three_times_stdev_S2

# Find outliers and save them for future use Standard 2

Standard_2 <- N1_amp_ASD[N1_amp_ASD$Stimulus == "Standard 2" , ]

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
N1_amp_ASD_2 <- N1_amp_ASD[ !(N1_amp_ASD$Subject %in% c(drops)), ]


## Winsorize outliers - replace with upper limit / lower limit

N1_amp_wins_ASD <- N1_amp_ASD_2 %>%
  group_by (Stimulus) %>%
  mutate (Value_wins = ifelse(Value>quantile(Value,0.75, na.rm =T) + 1.5 * IQR (Value, na.rm = T), 
                              quantile(Value,0.75, na.rm =T) + 1.5 * IQR (Value, na.rm = T),
                              ifelse(Value < quantile (Value, 0.25, na.rm = T) - 1.5 *IQR (Value, na.rm = T), 
                                     quantile (Value, 0.25, na.rm = T) - 1.5 *IQR (Value, na.rm = T), Value)))

N1_amp_wins <- rbind (N1_amp_wins_TD, N1_amp_wins_ASD)

N1_amp_wins$Stimulus = as.factor(N1_amp_wins$Stimulus)
N1_amp_wins$Group = as.factor(N1_amp_wins$Group)

class(N1_amp_wins$Stimulus)
class(N1_amp_wins$Group)

# plot winsorized N1 amp data in all age group

p1 <- ggplot(N1_amp_wins, aes(Stimulus, Value_wins))+
  facet_wrap(factor(N1_amp_wins$Group,levels=c("TD", "ASD")),strip.position = "bottom")+
  stat_boxplot(geom = "errorbar",width = 0.5)+
  geom_boxplot(outlier.shape = NA, aes(fill = Stimulus))+
  stat_summary(fun= "mean", geom= "point", shape=20, size=5, colour= "blue", position = position_dodge(width = 0.75))+
  
  scale_fill_manual(labels = c("Std 1", "Std 2"), values = c("grey", "red")) +
  guides(shape = "none")+
  geom_jitter(position = position_jitterdodge(),
              aes(shape = Group),size=2)+
  #ggtitle("N1 amplitude")+
  labs(y = NULL, fill = "Stimulus", shape = "Group")+
  #labs(y = "Mean Potential (uV)", fill = "Stimulus", 
       #shape = "Group")+
  theme_classic()+
  coord_cartesian(ylim = c(-4, 8))+
  scale_y_continuous(breaks = seq(-4, 8, by = 2))+
  theme(strip.background = element_blank(), 
        strip.placement = "outside",   
        axis.title.x  = element_blank(),
        plot.title=element_text(size=15,face="bold", hjust=0.5, margin=margin(b=-30)),
        axis.title.y  = element_text(size=15,face="bold", hjust=0.5),
       # axis.text=element_text(size=14, color="black", face="bold"),
        axis.line=element_line(size=1, colour = "black"),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size = 16, colour = "black", face = "bold"),
        axis.title=element_text(size=12, face="bold"),
        #strip.text=element_text(size=14, face="bold"),
        strip.text = element_blank(),
        legend.position="right",
        legend.title = element_text(size = 14, face = "bold"),
        legend.text = element_text(size = 12))

p1


## Keep some objects in the work space

objects_to_keep <- c("ERP_paired_analysis", "Child_ERP", "p1", "N1_amp_wins",
                     "N1_amp_wins_ASD","N1_amp_wins_TD","objects_to_keep") # List of objects you want to keep

# Remove all other objects

for (obj in ls()) {
  if (!(obj %in% objects_to_keep)) {
    rm(list = obj)
  }
}

rm(obj)

## ANOVA and Permutation

std1_TD_N1 <- N1_amp_wins_TD[N1_amp_wins_TD$Stimulus=='Standard 1', ]
std2_TD_N1 <- N1_amp_wins_TD[N1_amp_wins_TD$Stimulus=='Standard 2', ]

std1_ASD_N1 <- N1_amp_wins_ASD[N1_amp_wins_ASD$Stimulus=='Standard 1', ]
std2_ASD_N1 <- N1_amp_wins_ASD[N1_amp_wins_ASD$Stimulus=='Standard 2', ]


mean_std1_TD_N1 <- format(round(mean(std1_TD_N1$Value_wins), 3))
mean_std1_ASD_N1 <- format(round(mean(std1_ASD_N1$Value_wins), 3))
stdev_std1_TD_N1 = format(round(sd (std1_TD_N1$Value_wins), 3))
stdev_std1_ASD_N1 = format(round(sd (std1_ASD_N1$Value_wins), 3))

mean_std2_TD_N1 <- format(round(mean(std2_TD_N1$Value_wins), 3))
mean_std2_ASD_N1 <- format(round(mean(std2_ASD_N1$Value_wins), 3))
stdev_std2_TD_N1 = format(round(sd (std2_TD_N1$Value_wins), 3))
stdev_std2_ASD_N1 = format(round(sd (std2_ASD_N1$Value_wins), 3))


# permutation ANOVA

N1_amp <- N1_amp_wins
attach(N1_amp)
mod1 <- lm(N1_amp$Value_wins ~ N1_amp$Group + N1_amp$Stimulus + N1_amp$Group:N1_amp$Stimulus)
ANOVA <- summary(aov(mod1))
ANOVA
Fgroup <-  ANOVA[[1]]$"F value"[1]   # Saving F values for future use
Fcondition <-  ANOVA[[1]]$"F value"[2]
Finteract <-  ANOVA[[1]]$"F value"[3]

# Now start resampling
nreps <- 1000 
FG <- numeric(nreps)    #Set up space to store F values as calculated.
FC <- numeric(nreps)  
FGC <- numeric(nreps)
FG[1] <- Fgroup          # The first F of our 5000 
FC[1] <- Fcondition
FGC[1] <- Finteract


newN1 <- data.frame(Value =double(),
                    Group =double(),
                    condition =double())
len <- nrow(N1_amp)

for (i in 2:nreps) {
  Value <- sample(N1_amp$Value_wins, len)
  Group<-N1_amp$Group
  condition<-N1_amp$Stimulus
  newN1<-data.frame(Value,Group,condition)
  mod2 <- lm(newN1$Value ~ newN1$Group + newN1$condition + newN1$Group:newN1$condition)
  b <- summary(aov(mod2))
  FG[i] <- b[[1]]$"F value"[1]
  FC[i] <- b[[1]]$"F value"[2]
  FGC[i] <- b[[1]]$"F value"[3]
}

probG <- length(FG[FG >= Fgroup])/nreps
probC <- length(FC[FC >= Fcondition])/nreps       
probGC  <-  length(FGC[FGC >= Finteract ])/nreps


# interaction p as italic subtitle under title — matches manuscript style
p_int_label <- ifelse(probGC < 0.001,
                      "(p-interaction < 0.001)",
                      paste0("(p-interaction = ", format(round(probGC, 3), nsmall = 3), ")"))

p1 <- p1 + labs(subtitle = p_int_label) +
theme(plot.subtitle = element_text(size = 13, face = "bold.italic", hjust = 0.5,
                                   margin = margin(t = 45, b = 8)))


p1


export_folder <- "C:/Users/cigde/Dropbox/Habituation_paper/final_figures/"
ggsave(paste0(export_folder, "fig2_N1_children_box.pdf"), p1, width = 7, height = 4)
ggsave(paste0(export_folder, "fig2_N1_children_box.png"), p1, width = 7, height = 4)

## Keep only p1 and ERP_paired_analysis

objects_to_keep <- c("ERP_paired_analysis", "p1","objects_to_keep") # List of objects I want to keep
                     

# Remove all other objects

for (obj in ls()) {
  if (!(obj %in% objects_to_keep)) {
    rm(list = obj)
  }
}

rm(obj)

#####################################################################

# Adolescent TD

Adol_ERP <- ERP_paired_analysis[ERP_paired_analysis$Age == "Adolescent" , ]
Adol_TD_ERP <- Adol_ERP[Adol_ERP$Group == "TD" , ]
N1_amp_TD <- Adol_TD_ERP[Adol_TD_ERP$ERP_feature=="N1_amp", ]

## See if any sample needs to be excluded (three times stdev or mean)

# Get mean / stdev etc.. Standard 1

mean_S1 = mean ((N1_amp_TD[N1_amp_TD$Stimulus == "Standard 1" , ])$Value)
stdev_S1 = sd ((N1_amp_TD[N1_amp_TD$Stimulus == "Standard 1" , ])$Value)
three_times_stdev_S1 = 3*stdev_S1
lower_edge_S1 = mean_S1 - three_times_stdev_S1
higher_edge_S1 = mean_S1 + three_times_stdev_S1

# Find outliers and save them for future use Standard 1

Standard_1 <- N1_amp_TD[N1_amp_TD$Stimulus == "Standard 1" , ]

index_S1 <- c()
counter_S1 <- 0
for(i in 1:length(Standard_1$Value)){
  if (Standard_1$Value[i]<lower_edge_S1 || Standard_1$Value[i]>higher_edge_S1) {
    counter_S1 <- counter_S1 +1
    index_S1[counter_S1] = i;
  }
}


# Get mean / stdev etc.. Standard 2

mean_S2 = mean ((N1_amp_TD[N1_amp_TD$Stimulus == "Standard 2" , ])$Value)
stdev_S2 = sd ((N1_amp_TD[N1_amp_TD$Stimulus == "Standard 2" , ])$Value)
three_times_stdev_S2 = 3*stdev_S2
lower_edge_S2 = mean_S2 - three_times_stdev_S2
higher_edge_S2 = mean_S2 + three_times_stdev_S2

# Find outliers and save them for future use Standard 2

Standard_2 <- N1_amp_TD[N1_amp_TD$Stimulus == "Standard 2" , ]

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
N1_amp_TD_2 <- N1_amp_TD[ !(N1_amp_TD$Subject %in% c(drops)), ]


## Winsorize outliers - replace with upper limit / lower limit

N1_amp_wins_TD <- N1_amp_TD_2 %>%
  group_by (Stimulus) %>%
  mutate (Value_wins = ifelse(Value>quantile(Value,0.75, na.rm =T) + 1.5 * IQR (Value, na.rm = T), 
                              quantile(Value,0.75, na.rm =T) + 1.5 * IQR (Value, na.rm = T),
                              ifelse(Value < quantile (Value, 0.25, na.rm = T) - 1.5 *IQR (Value, na.rm = T), 
                                     quantile (Value, 0.25, na.rm = T) - 1.5 *IQR (Value, na.rm = T), Value)))

## Keep some objects in the work space

objects_to_keep <- c("ERP_paired_analysis", "p1","Adol_ERP", "N1_amp_wins_TD","objects_to_keep") # List of objects you want to keep

# Remove all other objects

for (obj in ls()) {
  if (!(obj %in% objects_to_keep)) {
    rm(list = obj)
  }
}

rm(obj)


# Adolescent ASD

Adol_ASD_ERP <- Adol_ERP[Adol_ERP$Group == "ASD" , ]
N1_amp_ASD <- Adol_ASD_ERP[Adol_ASD_ERP$ERP_feature=="N1_amp", ]

## See if any sample needs to be excluded (three times stdev or mean)

# Get mean / stdev etc.. Standard 1

mean_S1 = mean ((N1_amp_ASD[N1_amp_ASD$Stimulus == "Standard 1" , ])$Value)
stdev_S1 = sd ((N1_amp_ASD[N1_amp_ASD$Stimulus == "Standard 1" , ])$Value)
three_times_stdev_S1 = 3*stdev_S1
lower_edge_S1 = mean_S1 - three_times_stdev_S1
higher_edge_S1 = mean_S1 + three_times_stdev_S1

# Find outliers and save them for future use Standard 1

Standard_1 <- N1_amp_ASD[N1_amp_ASD$Stimulus == "Standard 1" , ]

index_S1 <- c()
counter_S1 <- 0
for(i in 1:length(Standard_1$Value)){
  if (Standard_1$Value[i]<lower_edge_S1 || Standard_1$Value[i]>higher_edge_S1) {
    counter_S1 <- counter_S1 +1
    index_S1[counter_S1] = i;
  }
}


# Get mean / stdev etc.. Standard 2

mean_S2 = mean ((N1_amp_ASD[N1_amp_ASD$Stimulus == "Standard 2" , ])$Value)
stdev_S2 = sd ((N1_amp_ASD[N1_amp_ASD$Stimulus == "Standard 2" , ])$Value)
three_times_stdev_S2 = 3*stdev_S2
lower_edge_S2 = mean_S2 - three_times_stdev_S2
higher_edge_S2 = mean_S2 + three_times_stdev_S2

# Find outliers and save them for future use Standard 2

Standard_2 <- N1_amp_ASD[N1_amp_ASD$Stimulus == "Standard 2" , ]

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
N1_amp_ASD_2 <- N1_amp_ASD[ !(N1_amp_ASD$Subject %in% c(drops)), ]


## Winsorize outliers - replace with upper limit / lower limit

N1_amp_wins_ASD <- N1_amp_ASD_2 %>%
  group_by (Stimulus) %>%
  mutate (Value_wins = ifelse(Value>quantile(Value,0.75, na.rm =T) + 1.5 * IQR (Value, na.rm = T), 
                              quantile(Value,0.75, na.rm =T) + 1.5 * IQR (Value, na.rm = T),
                              ifelse(Value < quantile (Value, 0.25, na.rm = T) - 1.5 *IQR (Value, na.rm = T), 
                                     quantile (Value, 0.25, na.rm = T) - 1.5 *IQR (Value, na.rm = T), Value)))

N1_amp_wins <- rbind (N1_amp_wins_TD, N1_amp_wins_ASD)

N1_amp_wins$Stimulus = as.factor(N1_amp_wins$Stimulus)
N1_amp_wins$Group = as.factor(N1_amp_wins$Group)

class(N1_amp_wins$Stimulus)
class(N1_amp_wins$Group)

# plot winsorized N1 amp data in all age group

p2 <- ggplot(N1_amp_wins, aes(Stimulus, Value_wins))+
  facet_wrap(factor(N1_amp_wins$Group,levels=c("TD", "ASD")),strip.position = "bottom")+
  stat_boxplot(geom = "errorbar",width = 0.5)+
  geom_boxplot(outlier.shape = NA, aes(fill = Stimulus))+
  stat_summary(fun= "mean", geom= "point", shape=20, size=5, colour= "blue", position = position_dodge(width = 0.75))+
  
  scale_fill_manual(labels = c("Std 1", "Std 2"), values = c("grey", "red")) +
  geom_jitter(position = position_jitterdodge(),
              aes(shape = Group),size=2)+
  #ggtitle("N1 amplitude")+
  labs(y = NULL, fill = "Stimulus", shape = "Group")+
  #labs(y = "Mean Potential (uV)", fill = "Stimulus", 
       #shape = "Group")+
  theme_classic()+
 coord_cartesian(ylim = c(-4, 8))+
  scale_y_continuous(breaks = seq(-4, 8, by = 2))+
  theme(strip.background = element_blank(), 
        strip.placement = "outside", 
        axis.title.x  = element_blank(),
        #plot.title=element_text(size=15,face="bold", hjust=0.5),
        plot.title=element_blank(),
        axis.title.y  = element_text(size=15,face="bold", hjust=0.5),
        #axis.text=element_text(size=14, color="black", face="bold"),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size = 16, colour = "black", face = "bold"),
        axis.line=element_line(size=1, colour = "black"),
        axis.title=element_text(size=12, face="bold"),
        #strip.text=element_text(size=14, face="bold"),
        strip.text = element_blank(),
        legend.position="none")

p2


## Keep some objects in the work space

objects_to_keep <- c("ERP_paired_analysis", "Adol_ERP", "p1","p2", "N1_amp_wins",
                     "N1_amp_wins_ASD","N1_amp_wins_TD","objects_to_keep") # List of objects you want to keep

# Remove all other objects

for (obj in ls()) {
  if (!(obj %in% objects_to_keep)) {
    rm(list = obj)
  }
}

rm(obj)

## ANOVA and Permutation

std1_TD_N1 <- N1_amp_wins_TD[N1_amp_wins_TD$Stimulus=='Standard 1', ]
std2_TD_N1 <- N1_amp_wins_TD[N1_amp_wins_TD$Stimulus=='Standard 2', ]

std1_ASD_N1 <- N1_amp_wins_ASD[N1_amp_wins_ASD$Stimulus=='Standard 1', ]
std2_ASD_N1 <- N1_amp_wins_ASD[N1_amp_wins_ASD$Stimulus=='Standard 2', ]


mean_std1_TD_N1 <- format(round(mean(std1_TD_N1$Value_wins), 3))
mean_std1_ASD_N1 <- format(round(mean(std1_ASD_N1$Value_wins), 3))
stdev_std1_TD_N1 = format(round(sd (std1_TD_N1$Value_wins), 3))
stdev_std1_ASD_N1 = format(round(sd (std1_ASD_N1$Value_wins), 3))

mean_std2_TD_N1 <- format(round(mean(std2_TD_N1$Value_wins), 3))
mean_std2_ASD_N1 <- format(round(mean(std2_ASD_N1$Value_wins), 3))
stdev_std2_TD_N1 = format(round(sd (std2_TD_N1$Value_wins), 3))
stdev_std2_ASD_N1 = format(round(sd (std2_ASD_N1$Value_wins), 3))


# permutation ANOVA

N1_amp <- N1_amp_wins
attach(N1_amp)
mod1 <- lm(N1_amp$Value_wins ~ N1_amp$Group + N1_amp$Stimulus + N1_amp$Group:N1_amp$Stimulus)
ANOVA <- summary(aov(mod1))
ANOVA
Fgroup <-  ANOVA[[1]]$"F value"[1]   # Saving F values for future use
Fcondition <-  ANOVA[[1]]$"F value"[2]
Finteract <-  ANOVA[[1]]$"F value"[3]

# Now start resampling
nreps <- 1000 
FG <- numeric(nreps)    #Set up space to store F values as calculated.
FC <- numeric(nreps)  
FGC <- numeric(nreps)
FG[1] <- Fgroup          # The first F of our 5000 
FC[1] <- Fcondition
FGC[1] <- Finteract


newN1 <- data.frame(Value =double(),
                    Group =double(),
                    condition =double())
len <- nrow(N1_amp)

for (i in 2:nreps) {
  Value <- sample(N1_amp$Value_wins, len)
  Group<-N1_amp$Group
  condition<-N1_amp$Stimulus
  newN1<-data.frame(Value,Group,condition)
  mod2 <- lm(newN1$Value ~ newN1$Group + newN1$condition + newN1$Group:newN1$condition)
  b <- summary(aov(mod2))
  FG[i] <- b[[1]]$"F value"[1]
  FC[i] <- b[[1]]$"F value"[2]
  FGC[i] <- b[[1]]$"F value"[3]
}

probG <- length(FG[FG >= Fgroup])/nreps
probC <- length(FC[FC >= Fcondition])/nreps       
probGC  <-  length(FGC[FGC >= Finteract ])/nreps



# group p as italic subtitle under title — matches manuscript style
p_grp_label <- ifelse(probG < 0.001,
                      "(p-group < 0.001)",
                      paste0("(p-group = ", format(round(probG, 3), nsmall = 3), ")"))


p2 <- p2 + labs(subtitle = p_grp_label) +
  theme(plot.subtitle = element_text(size = 13, face = "bold.italic", hjust = 0.5,
                                     margin = margin(t = 75, b = 8)))

p2

export_folder <- "C:/Users/cigde/Dropbox/Habituation_paper/final_figures/"
ggsave(paste0(export_folder, "fig2_N1_adolescents_box.pdf"), p2, width = 6, height = 4)
ggsave(paste0(export_folder, "fig2_N1_adolescents_box.png"), p2, width = 6, height = 4)

############### Adolescent finished ######################

## Keep only p1, p2 and ERP_paired_analysis

objects_to_keep <- c("ERP_paired_analysis", "p1","p2", "objects_to_keep") # List of objects I want to keep


# Remove all other objects

for (obj in ls()) {
  if (!(obj %in% objects_to_keep)) {
    rm(list = obj)
  }
}

rm(obj)



# Adult TD

Adult_ERP <- ERP_paired_analysis[ERP_paired_analysis$Age == "Adult" , ]
Adult_TD_ERP <- Adult_ERP[Adult_ERP$Group == "TD" , ]
N1_amp_TD <- Adult_TD_ERP[Adult_TD_ERP$ERP_feature=="N1_amp", ]

## See if any sample needs to be excluded (three times stdev or mean)

# Get mean / stdev etc.. Standard 1

mean_S1 = mean ((N1_amp_TD[N1_amp_TD$Stimulus == "Standard 1" , ])$Value)
stdev_S1 = sd ((N1_amp_TD[N1_amp_TD$Stimulus == "Standard 1" , ])$Value)
three_times_stdev_S1 = 3*stdev_S1
lower_edge_S1 = mean_S1 - three_times_stdev_S1
higher_edge_S1 = mean_S1 + three_times_stdev_S1

# Find outliers and save them for future use Standard 1

Standard_1 <- N1_amp_TD[N1_amp_TD$Stimulus == "Standard 1" , ]

index_S1 <- c()
counter_S1 <- 0
for(i in 1:length(Standard_1$Value)){
  if (Standard_1$Value[i]<lower_edge_S1 || Standard_1$Value[i]>higher_edge_S1) {
    counter_S1 <- counter_S1 +1
    index_S1[counter_S1] = i;
  }
}


# Get mean / stdev etc.. Standard 2

mean_S2 = mean ((N1_amp_TD[N1_amp_TD$Stimulus == "Standard 2" , ])$Value)
stdev_S2 = sd ((N1_amp_TD[N1_amp_TD$Stimulus == "Standard 2" , ])$Value)
three_times_stdev_S2 = 3*stdev_S2
lower_edge_S2 = mean_S2 - three_times_stdev_S2
higher_edge_S2 = mean_S2 + three_times_stdev_S2

# Find outliers and save them for future use Standard 2

Standard_2 <- N1_amp_TD[N1_amp_TD$Stimulus == "Standard 2" , ]

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
N1_amp_TD_2 <- N1_amp_TD[ !(N1_amp_TD$Subject %in% c(drops)), ]


## Winsorize outliers - replace with upper limit / lower limit

N1_amp_wins_TD <- N1_amp_TD_2 %>%
  group_by (Stimulus) %>%
  mutate (Value_wins = ifelse(Value>quantile(Value,0.75, na.rm =T) + 1.5 * IQR (Value, na.rm = T), 
                              quantile(Value,0.75, na.rm =T) + 1.5 * IQR (Value, na.rm = T),
                              ifelse(Value < quantile (Value, 0.25, na.rm = T) - 1.5 *IQR (Value, na.rm = T), 
                                     quantile (Value, 0.25, na.rm = T) - 1.5 *IQR (Value, na.rm = T), Value)))

## Keep some objects in the work space

objects_to_keep <- c("ERP_paired_analysis", "p1","p2","Adult_ERP", "N1_amp_wins_TD","objects_to_keep") # List of objects you want to keep

# Remove all other objects

for (obj in ls()) {
  if (!(obj %in% objects_to_keep)) {
    rm(list = obj)
  }
}

rm(obj)


# Adult ASD

Adult_ASD_ERP <- Adult_ERP[Adult_ERP$Group == "ASD" , ]
N1_amp_ASD <- Adult_ASD_ERP[Adult_ASD_ERP$ERP_feature=="N1_amp", ]

## See if any sample needs to be excluded (three times stdev or mean)

# Get mean / stdev etc.. Standard 1

mean_S1 = mean ((N1_amp_ASD[N1_amp_ASD$Stimulus == "Standard 1" , ])$Value)
stdev_S1 = sd ((N1_amp_ASD[N1_amp_ASD$Stimulus == "Standard 1" , ])$Value)
three_times_stdev_S1 = 3*stdev_S1
lower_edge_S1 = mean_S1 - three_times_stdev_S1
higher_edge_S1 = mean_S1 + three_times_stdev_S1

# Find outliers and save them for future use Standard 1

Standard_1 <- N1_amp_ASD[N1_amp_ASD$Stimulus == "Standard 1" , ]

index_S1 <- c()
counter_S1 <- 0
for(i in 1:length(Standard_1$Value)){
  if (Standard_1$Value[i]<lower_edge_S1 || Standard_1$Value[i]>higher_edge_S1) {
    counter_S1 <- counter_S1 +1
    index_S1[counter_S1] = i;
  }
}


# Get mean / stdev etc.. Standard 2

mean_S2 = mean ((N1_amp_ASD[N1_amp_ASD$Stimulus == "Standard 2" , ])$Value)
stdev_S2 = sd ((N1_amp_ASD[N1_amp_ASD$Stimulus == "Standard 2" , ])$Value)
three_times_stdev_S2 = 3*stdev_S2
lower_edge_S2 = mean_S2 - three_times_stdev_S2
higher_edge_S2 = mean_S2 + three_times_stdev_S2

# Find outliers and save them for future use Standard 2

Standard_2 <- N1_amp_ASD[N1_amp_ASD$Stimulus == "Standard 2" , ]

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
N1_amp_ASD_2 <- N1_amp_ASD[ !(N1_amp_ASD$Subject %in% c(drops)), ]


## Winsorize outliers - replace with upper limit / lower limit

N1_amp_wins_ASD <- N1_amp_ASD_2 %>%
  group_by (Stimulus) %>%
  mutate (Value_wins = ifelse(Value>quantile(Value,0.75, na.rm =T) + 1.5 * IQR (Value, na.rm = T), 
                              quantile(Value,0.75, na.rm =T) + 1.5 * IQR (Value, na.rm = T),
                              ifelse(Value < quantile (Value, 0.25, na.rm = T) - 1.5 *IQR (Value, na.rm = T), 
                                     quantile (Value, 0.25, na.rm = T) - 1.5 *IQR (Value, na.rm = T), Value)))

N1_amp_wins <- rbind (N1_amp_wins_TD, N1_amp_wins_ASD)

N1_amp_wins$Stimulus = as.factor(N1_amp_wins$Stimulus)
N1_amp_wins$Group = as.factor(N1_amp_wins$Group)

class(N1_amp_wins$Stimulus)
class(N1_amp_wins$Group)

# plot winsorized N1 amp data in all age group

p3 <- ggplot(N1_amp_wins, aes(Stimulus, Value_wins))+
  facet_wrap(factor(N1_amp_wins$Group,levels=c("TD", "ASD")),strip.position = "bottom")+
  stat_boxplot(geom = "errorbar",width = 0.5)+
  geom_boxplot(outlier.shape = NA, aes(fill = Stimulus))+
  stat_summary(fun= "mean", geom= "point", shape=20, size=5, colour= "blue", position = position_dodge(width = 0.75))+
  
  scale_fill_manual(labels = c("Std 1", "Std 2"), values = c("grey", "red")) +
  geom_jitter(position = position_jitterdodge(),
              aes(shape = Group),size=2)+
  # ggtitle("N1 amplitude")+
 # labs(y = "Mean Potential (uV)", fill = "Stimulus", 
       #shape = "Group")+
  labs(y = NULL) +
  theme_classic()+
  coord_cartesian(ylim = c(-4, 8))+
  scale_y_continuous(breaks = seq(-4, 8, by = 2))+
  theme(strip.background = element_blank(), 
        strip.placement = "outside", 
        axis.title.x  = element_blank(),
       # plot.title=element_text(size=15,face="bold", hjust=0.5),
        plot.title=element_blank(),
        axis.title.y  = element_text(size=15,face="bold", hjust=0.5),
        #axis.text=element_text(size=14, color="black", face="bold"),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size = 16, colour = "black", face = "bold"),
        axis.line=element_line(size=1, colour = "black"),
        axis.title=element_text(size=12, face="bold"),
        strip.text=element_text(size=14, face="bold"),
        legend.position="none")

p3


## Keep some objects in the work space

objects_to_keep <- c("ERP_paired_analysis", "Adult_ERP", "p1","p2", "p3", "N1_amp_wins",
                     "N1_amp_wins_ASD","N1_amp_wins_TD","objects_to_keep") # List of objects you want to keep

# Remove all other objects

for (obj in ls()) {
  if (!(obj %in% objects_to_keep)) {
    rm(list = obj)
  }
}

rm(obj)

## ANOVA and Permutation

std1_TD_N1 <- N1_amp_wins_TD[N1_amp_wins_TD$Stimulus=='Standard 1', ]
std2_TD_N1 <- N1_amp_wins_TD[N1_amp_wins_TD$Stimulus=='Standard 2', ]

std1_ASD_N1 <- N1_amp_wins_ASD[N1_amp_wins_ASD$Stimulus=='Standard 1', ]
std2_ASD_N1 <- N1_amp_wins_ASD[N1_amp_wins_ASD$Stimulus=='Standard 2', ]


mean_std1_TD_N1 <- format(round(mean(std1_TD_N1$Value_wins), 3))
mean_std1_ASD_N1 <- format(round(mean(std1_ASD_N1$Value_wins), 3))
stdev_std1_TD_N1 = format(round(sd (std1_TD_N1$Value_wins), 3))
stdev_std1_ASD_N1 = format(round(sd (std1_ASD_N1$Value_wins), 3))

mean_std2_TD_N1 <- format(round(mean(std2_TD_N1$Value_wins), 3))
mean_std2_ASD_N1 <- format(round(mean(std2_ASD_N1$Value_wins), 3))
stdev_std2_TD_N1 = format(round(sd (std2_TD_N1$Value_wins), 3))
stdev_std2_ASD_N1 = format(round(sd (std2_ASD_N1$Value_wins), 3))


# permutation ANOVA

N1_amp <- N1_amp_wins
attach(N1_amp)
mod1 <- lm(N1_amp$Value_wins ~ N1_amp$Group + N1_amp$Stimulus + N1_amp$Group:N1_amp$Stimulus)
ANOVA <- summary(aov(mod1))
ANOVA
Fgroup <-  ANOVA[[1]]$"F value"[1]   # Saving F values for future use
Fcondition <-  ANOVA[[1]]$"F value"[2]
Finteract <-  ANOVA[[1]]$"F value"[3]

# Now start resampling
nreps <- 1000 
FG <- numeric(nreps)    #Set up space to store F values as calculated.
FC <- numeric(nreps)  
FGC <- numeric(nreps)
FG[1] <- Fgroup          # The first F of our 5000 
FC[1] <- Fcondition
FGC[1] <- Finteract


newN1 <- data.frame(Value =double(),
                    Group =double(),
                    condition =double())
len <- nrow(N1_amp)

for (i in 2:nreps) {
  Value <- sample(N1_amp$Value_wins, len)
  Group<-N1_amp$Group
  condition<-N1_amp$Stimulus
  newN1<-data.frame(Value,Group,condition)
  mod2 <- lm(newN1$Value ~ newN1$Group + newN1$condition + newN1$Group:newN1$condition)
  b <- summary(aov(mod2))
  FG[i] <- b[[1]]$"F value"[1]
  FC[i] <- b[[1]]$"F value"[2]
  FGC[i] <- b[[1]]$"F value"[3]
}

probG <- length(FG[FG >= Fgroup])/nreps
probC <- length(FC[FC >= Fcondition])/nreps       
probGC  <-  length(FGC[FGC >= Finteract ])/nreps

# no significant p value thus no annotation add invisible text on p3 so all three have equal spacing

p3 <- p3 + theme(axis.title.y = element_text(size = 16, face = "bold")) +
  labs(subtitle = " ") +
  theme(plot.subtitle = element_text(size = 13, margin = margin(t = 45, b = 8)))

p3

export_folder <- "C:/Users/cigde/Dropbox/Habituation_paper/final_figures/"
ggsave(paste0(export_folder, "fig2_N1_adults_box.pdf"), p3, width = 6, height = 4)
ggsave(paste0(export_folder, "fig2_N1_adults_box.png"), p3, width = 6, height = 4)

############### Adults finished ########################

library(patchwork)

# put p1, p2 and p3 together in one panel - stack vertical


combined <- (p1 / p2 / p3) +
  plot_layout(heights = c(1, 1, 1)) +
  plot_annotation(title = "N1 amplitude",
                  theme = theme(plot.title = element_text(size = 18, face = "bold", hjust = 0.5))) &
  theme(plot.margin = margin(l = 20))

final <- wrap_elements(panel = combined) +
  labs(tag = "Mean Potential (uV)") +
  theme(plot.tag = element_text(size = 22, face = "bold", angle = 90),
        plot.tag.position = c(0.02, 0.5))

final

export_folder <- "C:/Users/cigde/Dropbox/Habituation_paper/final_figures/"
ggsave(paste0(export_folder, "figure2_N1_amp_all_ages_vertical.pdf"), final, width = 7, height = 12)
ggsave(paste0(export_folder, "figure2_N1_amp_all_ages_vertical.png"), final, width = 7, height = 12, dpi = 300)





###########################################

# combine three age-group panels horizontally
ylims <- c(-3, 7.5)

strip_theme <- theme(plot.title = element_blank(), axis.title.y = element_blank())
no_y        <- theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())

p1b <- p1 + coord_cartesian(ylim = ylims) + theme(plot.title = element_blank())
p2b <- p2 + coord_cartesian(ylim = ylims) + strip_theme + no_y
p3b <- p3 + coord_cartesian(ylim = ylims) + strip_theme + no_y

p1b <- p1b + labs(x = "Children") +
  theme(axis.title.x = element_text(size = 14, face = "bold"))
p2b <- p2b + labs(x = "Adolescents") +
  theme(axis.title.x = element_text(size = 14, face = "bold"))
p3b <- p3b + labs(x = "Adults") +
  theme(axis.title.x = element_text(size = 14, face = "bold"),
        legend.position = "top", legend.title = element_blank(),
        legend.text = element_text(size = 14)) +
  guides(shape = "none")

combined <- (p1b | p2b | p3b) +
  plot_annotation(title = "N1 amplitude",
                  theme = theme(plot.title = element_text(size = 18, face = "bold", hjust = 0.5)))
combined


export_folder <- "C:/Users/cigde/Dropbox/Habituation_paper/final_figures/"

ggsave(paste0(export_folder, "figure2_N1_amp_all_ages_horizontal.pdf"), combined, width = 15, height = 5.5)
ggsave(paste0(export_folder, "figure2N1_amp_all_ages_horizontal.png"), combined, width = 15, height = 5.5, dpi = 300)
