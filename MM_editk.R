rm(list = ls())
library(countrycode)
library(doBy)
library(foreign)
library(gdata)
library(ggplot2)
library(knitr)
library(lmtest)
library(reshape)
library(sandwich)
library(stargazer)
library(WDI)
library(car)
library(readr)
library(dplyr)
library(tidyr)
library(stringr)
mm <- read_csv("Documents/Course_Work /Springboard/Data/MissingMigrants.csv")

#Seperate Month, Day, and Year
mm_clean <- mm %>% 
  separate('Reported Date', into=c("Month", "Day"), sep= " ") 

mm_clean<- mm_clean %>% 
  rename(Reported_Year = `Reported Year`) %>% 
  rename(Total_Dead_and_Missing = `Total Dead and Missing`) %>% 
  rename(Number_Females = `Number of Females`) %>% 
  rename(Number_Males = `Number of Males`) %>% 
  rename(Number_Dead = `Number Dead`) %>% 
  rename(Number_Survived = `Number of Survivors`)
#delete old month column
mm_clean$`Reported Month` <- NULL


#remove comma from day column --doesn't work
mm_clean <-mm_clean %>% 
  mutate(Day = gsub(",", "", Day))
#str_remove(mm_clean$Day, [","])


# replace NA values in Number_Dead column
mm_clean <- mm_clean %>%
  mutate(Number_Dead = ifelse(is.na(Number_Dead), mean(Number_Dead, na.rm = T), Number_Dead))

#replace NA values in Number_survived column
mm_clean<- mm_clean %>% 
  mutate(Number_Survived = ifelse(is.na(Number_Survived), mean(Number_Survived, na.rm=T), Number_Survived))

#create new column of total migrants per incident 
mm_clean$Total_Migrants <- mm_clean$Total_Dead_and_Missing + mm_clean$Number_Survived

#round decimals to 2 digits 
mm_clean <- mm_clean %>% 
  mutate_if(is.numeric, round, digits=2)

