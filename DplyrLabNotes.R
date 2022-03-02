# Dplyr Lab Info
# 2 March 2022
# JAH

# what is dplyr?
# new(ish) provides tool for manipulating data in R
# part of tidyverse package
# fast!
# individual functions that correspond to most common operations

## Core Verbs
# filter (): pic/subset observations by their values (rows)
# arrange(): reordering rorws
# select(): choose variables (columns) by names
# mutate(): creating new variables with functions of existing variable 
# summarise() and group_by((): collapses many values down to a single summary

library(tidyverse)
data("starwars")
class(starwars)

# tbl = tibble
# modern take on data frames which keeps great aspects of data frames and drops frustrating ones
glimpse(starwars)
head(starwars)

# complete cases to clean up data 
starwarsclean <- starwars[complete.cases(starwars[,1:10]),]
# give us all the rows put only first 10 besides NA [,1;10]),]
glimpse(starwarsclean)

is.na(starwarsclean)
anyNA(starwarsclean) # any NAs at all?

head(starwarsclean)


########################
# filter(): subset by rows
# use >, >=, <, <=, !=, == for conditional statements
# logical operators & | !

# filter auto, exludes NAs - have to ask

filter(starwarsclean, gender == "masculine", height < 180)
# commas or ampersands (&) can be used

filter(starwarsclean, gender == "masculine", height < 180, height > 100)

filter(starwarsclean, eye_color %in% c("blue", "brown"))
# %in% only the c() listed so, either or

# faster than :
# filter(starwarsclean, eye_color == "blue" | eye_color == "brown")

#########
# arrange(): reodering rows
arrange(starwarsclean, by=height)
arrange(starwarsclean, by=desc(height))
# descending desc()

arrange(starwarsclean, by=height, desc(mass)) # following variables serve as 'tie-breaker'
tail(arrange(starwarsclean, by=height))

##########
# select(): chooses variables by their names (columns)
## these all do the same:
starwarsclean[,1:10]
select(starwarsclean, 1:10)
select(starwarsclean, name:homeworld)
select(starwarsclean, -(films:starships)) # - or ! to exclude

### rearrange columns
select(starwarsclean, name, gender, species,
       everything()) # everything() helper function: everything else goes after
select(starwarsclean, contains("color"))
# other helper functions: ends_with(), starts_with(), matches, num_range()

### rename columns
select(starwarsclean, name, haircolor = hair_color, everything()) 

##############
#mutate(): creates new variables with functions of existing variables 

mutate(starwarsclean, ratio = height/mass)
starwars_lbs <- mutate(starwarsclean, mass_lbs = mass*2.2) # convert kg to lbs in new column

select(starwars_lbs, 1:3, mass_lbs, everything ())

# transmute
transmute(starwarsclean, mass_lbs = mass*2.2)

##############
# summarize and group_by(): collapses values and provides summary
summarise(starwarsclean, meanHeight = mean(height), TotalN = n())

summarise(starwars, meanHeight = mean(height, na.rm=TRUE))
# to get rid of NAs

summarise(starwars, meanHeight = mean(height, na.rm=TRUE), TotalN = n())

# group_by()
starwarsgenders <- group_by(starwars, gender)
head(starwarsgenders)
summarise(starwarsgenders, meanHeight = mean(height, na.rm = TRUE), N=n())


#############
## PIPING %>%
# used to emphasize a sequence of actions 
# let's you pass an intermediate results onto the next function - it takes the output of one statement/function and uses it as the input of the next statement/function
# avoid when manipulating more than one object or if you have meaningful intermediate objects
# formatting: always have a space before pipe %>% and usually followed by a new line (with auto indent)

starwarsclean %>%
  group_by(gender) %>%
  summarise(meanHeight=mean(height), number=n())

# case_when() useful for multiple ifelse statements
ifelse(starwarsclean$gender=="feminine", "F", "M")
# m if it's false, must specify yes or no
starwarsclean$sexid <- ifelse(starwarsclean$gender=="feminine", "F", "M")

starwarsclean %>%
  mutate(sp=case_when(species=="Human" ~ "Humanoid", TRUE ~ "Non-human")) 

starwarsclean %>%
  group_by(films) %>%
  mutate(
    sp = case_when(species == "Human" ~ "Humanoid", species == "Ewok" ~ "Mammal", TRUE ~ "Non-human"),
    status = case_when(str_detect(films, "A New Hope") ~ "OG", TRUE ~ "Later")) %>%
  select(name,sp, status, everything()) %>%
  arrange(status) %>%
  {starwarsOGstatus <<- .}

glimpse(starwarsOGstatus)


##### Convert long to wide format and vice-versa
glimpse(starwarsclean)

wideSW <- starwarsclean %>%
  select(name, sex, height) %>%
  pivot_wider(names_from = sex, values_from = height, values_fill = NA)

# long format
wideSW %>%
  pivot_longer(cols=male:female,
              names_to = "sex",
              values_to = "height",
              values_drop_na = T)


# one more example

starwars %>%
  select(name,homeworld) %>%
  group_by(homeworld) %>%
  mutate(rn = row_number()) %>%
  ungroup() %>%
  pivot_wider(names_from = homeworld,
              values_from = name)
