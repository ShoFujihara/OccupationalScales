library(tidyverse)
d <- read_csv("gender_occupational_segregation.csv")

prop_women <- d %>% 
  mutate(occ = occ,
         num = as.numeric(num)) %>% 
  pivot_wider(c(occ,jtitle), 
              names_from = gender,
              values_from = num) %>%
  mutate(prop = Women/(Men + Women))

prop_women %>% 
  mutate(occ = factor(occ)) %>%
  ggplot(aes(x = occ, y = prop)) +
  geom_point() +
  theme_minimal()

prop_women <- prop_women %>% 
  select(occ,prop)

write_csv(prop_women, "prop_gender_occupational_segregation.csv")


# data
sei <- read_csv("JESS_232_sei_ssi_v1.0.csv")
japan <- read_csv("Japanese_title_occupation.csv")
edu <- read_csv("education_rank.csv")
  
# plot
d <- sei %>% 
  left_join(japan, by = "occ") %>%
  left_join(prop_women, by = "occ") %>%
  left_join(edu, by = "occ") %>%
  rename(fp = prop) %>%
  mutate(slfp = log((100*fp + 1 )/(100 - 100*fp + 1)))

d %>%
  select(occ,jtitle,fp,slfp) %>%
  arrange(fp) %>%
  knitr::kable(digits = 3)


# histgram
library(ggpubr)
SEI <- d %>% 
  ggplot(aes(x = sei)) +
  geom_histogram(alpha = 0.7, fill = "red") + 
  theme_minimal() +
  theme(legend.position = "NULL")

SSI <- d %>% 
  ggplot(aes(x = ssi)) +
  geom_histogram(alpha = 0.7, fill = "blue") + 
  theme_minimal() +
  theme(legend.position = "NULL")

FP <- d %>% 
  ggplot(aes(x = fp)) +
  geom_histogram(alpha = 0.7, fill = "green") + 
  theme_minimal() +
  theme(legend.position = "NULL")

SLFP <- d %>% 
  ggplot(aes(x = slfp)) +
  geom_histogram(alpha = 0.7, fill = "purple") + 
  theme_minimal() +
  theme(legend.position = "NULL")

EDU <- d %>% 
  ggplot(aes(x = edu_rank)) +
  geom_histogram(alpha = 0.7, fill = "orange") + 
  theme_minimal() +
  theme(legend.position = "NULL")


fig_1 <- ggarrange(SEI,SSI,EDU,FP,SLFP)
ggsave(plot = fig_1, "fig_1.png", device = "png",
       height = 5, width = 10)

fig_2 <- d %>% 
  ggplot(aes(x = fp, y = slfp)) +
  geom_point(alpha = 0.5, color = "green") + 
  geom_hline(yintercept = 0, linetype = 2) +
  geom_vline(xintercept = 0.5, linetype = 2) +
  labs(x = "Proportion of women", y = "Started logit") + 
  theme_minimal()
ggsave(fig_2, "fig_2.png", device = "png",
       height = 5, width = 8)

library(GGally)
fig_3 <- d %>% 
  select(sei, ssi, edu_rank, fp, slfp) %>% 
  ggpairs() +
  theme_minimal()
ggsave(plot = fig_3, "fig_3.png", device = "png",
         height = 5, width = 8)





d %>% 
  ggplot(aes(x = sl)) + 
  geom_histogram() +
  theme_minimal()


d %>% 
  ggplot(aes(x = sl, y = sei)) +
  geom_point() +
  geom_smooth() + 
  theme_minimal()

d %>% 
  ggplot(aes(x = sl, y = edu_rank)) +
  geom_point() +
  geom_smooth() + 
  theme_minimal()
