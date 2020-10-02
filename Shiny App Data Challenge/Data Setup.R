library(openxlsx)
library(tidyverse)

## Presidential Data

# Read in data
pres <- read.xlsx("Data/pres_dat_76_16.xlsx")

# Remove "Other" candidate value and duplicates
pres <- pres[-c(2545, 3543, 3544),]

# Get rid of non major parties
pres <- subset(pres, party == "republican" | party == "democrat")

# Subset for states that have passed a similar law
key_states <- c("CT", "CO", "DE", "DC", "IL", "IN", "KY", "ME", "MD", "MS", "NE", 
                "NM", "NC", "OH", "SC", "UT", "VT", "VA", "WV")

# Subset of enaction years
enaction <- c(2008, 2019, 2010, 2009, 2013, 1995, 2010, 2004, 2010, 1997, 1994, 2016, 2016, 1981, 1997, 2018, 2010, 2004, 2013)

test <- data.frame(key_states, enaction)%>%
  rename(state_po = key_states)

pres <- subset(pres, state_po %in% key_states)

# Remove unnecessary variables
pres <- pres[,-c(4,5,6,10,13,14,15)]

# Create variables for percentage vote and lean
pres$pctfor <- pres$candidatevotes/pres$totalvotes

pres$lean <- 0 # Lean will be equal to republican-democrat

# Order by year, then state, then party
pres <- pres[with(pres, order(year, state, party)),]

# Calculate lean values
for (i in 1:nrow(pres)){
  if (pres[i,6] == "democrat"){
    pres[i,10] = pres[i+1, 9] - pres[i,9]
  } else{
    pres[i,10] = pres[i,9] - pres[i-1,9]
  }
}

pres <- left_join(pres, test, by = "state_po")

## Senate Data

# Read in data
sen <- read.xlsx("Data/sen_dat_76_18.xlsx")


# Subset for states that have passed a similar law

# Some winning state senators represented third parties. For simplicity, we have 
# removed CT senate elections, the 2012 and 2018 ME senate elections, and the 1976 VA 
# senate election, all of which included major vote getters from three or more 
# different parties. Additionally, Bernie Sanders was  reclassified from an
# independent to democrat in the appropriate years. 

key_states_sen <- c("CO", "DE", "DC", "IL", "IN", "KY", "ME", "MD", "MS", "NE", 
                "NM", "NC", "OH", "SC", "UT", "VA", "VT","WV")

me_drop_years <- c(2012:2013, 2015:2018)
me_drop_rows <- subset(sen, state_po == "ME" & year %in% me_drop_years)
sen <- anti_join(sen, me_drop_rows)

va_drop_years <- c(1976)
va_drop_rows <- subset(sen, state_po == "VA" & year %in% va_drop_years)
sen <- anti_join(sen, va_drop_rows)

# Get rid of non major parties
sen <- subset(sen, party == "republican" | party == "democrat")

# Subset States that have pass similar law
sen <- subset(sen, state_po %in% key_states)

# Remove unnecessary variables
sen <- sen[,-c(4,5,6,8,9,10,13,14,17,18)]

# Create variables for percentage vote and lean
sen$pctfor <- sen$candidatevotes/sen$totalvotes

sen$lean <- 0 # Lean will be equal to republican-democrat

# Order by year, then state, then party
sen <- sen[with(sen, order(year, state, party)),]

# Calculate lean values
for (i in 1:nrow(sen)){
  if (sen[i,6] == "democrat"){
    sen[i,10] = sen[i+1, 9] - sen[i,9]
  } else{
    sen[i,10] = sen[i,9] - sen[i-1,9]
  }
}

# Adding Enaction Years
sen <- left_join(sen, test, by = "state_po")

# Combine Data Sets
omni <- rbind(pres, sen)

# Export Final Data Set
write.csv(omni, "Data/prop18_lean_omni.csv", row.names = FALSE)

