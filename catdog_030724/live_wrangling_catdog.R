#load packages
library(readr) #read_csv
library(dplyr) #wrangling & %>%
library(stringr) #str_replace_all
library(tidyr) #pivot_longer

#set working directory

# list files
mydir = "input/animals"
myfiles = list.files(path=mydir, pattern = "*.csv", full.names = TRUE)

#Batch read
df_list <- setNames(lapply(myfiles, read_csv), myfiles)

#combine to master file
cdf <- bind_rows(df_list, .id="file_id")

#remove blank rows
cdf_1 <- cdf %>%
  select(!(blank))

#rename column headers
cdf_2 <- cdf_1 %>%
  rename("type" = "animaltype",
         "age" = "AgeYears")

#Replacing AND . / , to &
cdf_3 <- cdf_2 %>%
  mutate(colour = str_replace_all(colour, "AND|and|&|,|/|\\.", " & "))

#stringr string squish spaces
cdf_4 <- cdf_3 %>% 
  mutate(across(c(1:8), str_squish))

#compare old & new

cdf %>%
  count(colour) %>%
  slice(1:10)

cdf_4 %>%
  count(colour) %>%
  slice(1:10)

#String to title 
cdf_5 <- cdf_4 %>%
  mutate(across(c(2:7), str_to_title))

cdf_4 %>%
  count(colour) %>%
  slice(1:10)

cdf_5 %>%
  count(colour) %>%
  slice(1:10)

cdf_6 <- cdf_5 %>%
  mutate(type = recode(type, "D" = "Dog"))

write_csv(cdf_6, "cleaned_catdog_data_03july.csv")

