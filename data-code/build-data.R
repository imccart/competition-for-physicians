# Meta --------------------------------------------------------------------

## Author:        Ian McCarthy
## Date Created:  10/27/2023
## Date Edited:   10/27/2023
## Description:   Build Analytic Data


# Preliminaries -----------------------------------------------------------
if (!require("pacman")) install.packages("pacman")
pacman::p_load(ggplot2, tidyverse, lubridate, stringr, modelsummary, broom, janitor, here)

# Read-in data ------------------------------------------------------------
aha.data <- read_csv('data/input/aha-data.csv')
puf.data <- read_csv('data/input/physician-utilization-puf.csv')


# Identify Specific Codes -------------------------------------------------

# Relevant codes/variables:
##  Proton beam radiation treatment therapy — CPT 77523
##  da Vinci robotic surgery — HCPCS S2900
##  Gamma knives — CPT 77432
##  Robotic Surgery: ROBOHOS, ROBOSYS, ROBONET, ROBOVEN
##  Proton Beam: PTONHOS, PTONSYS, PTONNET, PTONVEN
##  Stereotactic: SRADHOS, SRADSYS, SRADNET, SRADVEN

## filter puf.data for hcpcs codes 77523, 77432 (there is not S2900 in the data)
puf.small <- puf.data %>%
    filter(hcpcs_code %in% c("77523", "77432", "S2900"))

## merge back to full data to get all codes for a physician that ever used one of the new codes
puf.phys <- puf.data %>%
    inner_join(puf.small %>% select(npi) %>% distinct(), by="npi") %>%
    write_csv('data/output/puf-physician.csv')

