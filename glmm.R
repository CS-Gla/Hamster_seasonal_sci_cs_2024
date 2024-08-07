# Load necessary libraries
library(dplyr)
library(ggplot2)
library(car)
library(nlme)
library(lme4)
library(lmerTest)
library(readxl)
library(rstudioapi)
library(reshape2)
library(tidyverse)
library(tidyr)
library(sjPlot)


#Set working directory to local directory
setwd(dirname(getActiveDocumentContext()$path))

#Load body mass data from file
df <- read_excel("melt2.xlsx")

df = na.omit(df)
#filter for blank and na values
df <- df %>%
  filter(!is.na(ID) & !is.na(Group) & !is.na(week) & !is.na(bw) & Group != "")

df = subset(df, ave(bw != 0, ID, Group, week, FUN = any))

# Fit the GLMM with week vargamma()
glmer_model <- lme4::glmer(bw ~ Group * week + (1 | ID), data = df, family = Gamma (link = "log"), control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=10000)))
# Summarize the model
summary(glmer_model)

#QC: check for model singularity
isSingular(glmer_model)

#build random effects plot
ranef_plot <- plot_model(glmer_model, type = "re")
ranef_plot

#QC:  Check residuals
residuals <- residuals(glmer_model)
ggplot(data = data.frame(residuals), aes(sample = residuals)) +
  stat_qq() +
  stat_qq_line() +
  ggtitle("QQ Plot of Residuals")

#QC:  Additional diagnostic plots
plot(glmer_model)


#build summary object
res = summary(glmer_model)
res

#sink summary object to output file
sink(file = "glm_output.txt")
summary(glmer_model)
sink(file = NULL)
