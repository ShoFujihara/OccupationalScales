# library
library(tidyverse)
library(haven)
library(magrittr)
library(psych)

# read master data (Survey among High School Students and their Mothers, 2012)
# https://ssjda.iss.u-tokyo.ac.jp/Direct/gaiyo.php?eid=0873&lang=eng
hsm <- readr::read_delim("0873/0873.dat", delim = "\t")

# read occupational scales from github
sei_ssi <- read_csv("https://raw.githubusercontent.com/ShoFujihara/OccupationalScales/master/SSM_sei_ssi_v1.0.csv")

# create data for match
c_sei_ssi <- sei_ssi %>% 
  mutate(c_2SSM = ssm,
         c_sei = sei,
         c_ssi = ssi) %>% 
  select(c5_2SSM, c_sei, c_ssi)

mc_sei_ssi <- sei_ssi %>% 
  mutate(m2_2SSM = ssm,
         mc_sei = sei,
         mc_ssi = ssi) %>% 
  select(m2_2SSM, mc_sei, mc_ssi)

m_sei_ssi <- sei_ssi %>% 
  mutate(m17m_cSSM = ssm,
         m_sei = sei,
         m_ssi = ssi) %>% 
  select(m17m_cSSM, m_sei, m_ssi)

f_sei_ssi <- sei_ssi %>% 
  mutate(m17f_cSSM = ssm,
         f_sei = sei,
         f_ssi = ssi) %>% 
  select(m17f_cSSM, f_sei, f_ssi)

m1st_sei_ssi <- sei_ssi %>% 
  mutate(m19bSSM = ssm,
         m1st_sei = sei,
         m1st_ssi = ssi) %>% 
  select(m19bSSM, m1st_sei, m1st_ssi)

# merge 
hsm <- left_join(hsm, c5sei_ssi, by = "c5_2SSM")
hsm <- left_join(hsm, mc_sei_ssi, by = "m2_2SSM")
hsm <- left_join(hsm, m_sei_ssi, by = "m17m_cSSM")
hsm <- left_join(hsm, f_sei_ssi, by = "m17f_cSSM")
hsm <- left_join(hsm, m1st_sei_ssi, by = "m19bSSM")

# gender
hsm %<>% mutate(gender = factor(c1_1, level = 1:2, labels = c("male", "female")))

names(hsm)

# check
hsm %>% group_by(c5_2SSM) %>% summarise(mean = mean(c5_sei),
                                        sd = sd(c5_sei),
                                        N = n())

# histogram
hsm %>% ggplot(aes(x = c5_sei)) + 
  geom_histogram() +
  theme_minimal()

# plot
hsm %>% ggplot(aes(x = f_sei, y = c5_sei, color = gender)) + 
  geom_point(alpha = 0.5) + 
  geom_smooth(method = "lm") + 
  labs(x = "Father's SEI", y = "Child's occupational expectation (SEI)") +
  theme_minimal()

# correlation by gender
hsm %>% filter(gender == "male") %>% select(ends_with("sei")) %>% pairs.panels()
hsm %>% filter(gender == "female") %>% select(ends_with("sei")) %>% pairs.panels()
