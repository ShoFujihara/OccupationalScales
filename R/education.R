library(tidyverse)

d <- read_csv("education.csv")

library(Hmisc)

# Total
RANK <- d %>% 
  filter(occ != 232) %>%
  group_by(occ) %>%
  mutate(edu_1 = sum(edu_1),
         edu_2 = sum(edu_2),
         edu_3 = sum(edu_3),
         edu_4 = sum(edu_4)) %>%
  select(-gender, -edu_5) %>%
  unique() %>%
  ungroup() %>%
  mutate(edu_1 = ifelse(edu_1 == 0, 0, edu_1),
         edu_2 = ifelse(edu_2 == 0, 0, edu_2),
         edu_3 = ifelse(edu_3 == 0, 0, edu_3),
         edu_4 = ifelse(edu_4 == 0, 0, edu_4)) %>%
  mutate(total = edu_1 + edu_2 + edu_3 + edu_4,
         w = total / sum(total),
         pedu_1 = edu_1 / total,
         pedu_2 = edu_2 / total,
         pedu_3 = edu_3 / total,
         pedu_4 = edu_4 / total)

RANK %>% print(n = 1000)

RANK %>% summarise(prop1 = sum(edu_1)/sum(edu_1 + edu_2 + edu_3 + edu_4),
                prop2 = sum(edu_2)/sum(edu_1 + edu_2 + edu_3 + edu_4),
                prop3 = sum(edu_3)/sum(edu_1 + edu_2 + edu_3 + edu_4),
                prop4 = sum(edu_4)/sum(edu_1 + edu_2 + edu_3 + edu_4)) %>%
  select(contains("prop"))

RANK <- RANK %>% mutate(
         rank_1 = wtd.rank(pedu_1, weights = w, normwt = TRUE) / 231,
         rank_2 = wtd.rank(pedu_2, weights = w, normwt = TRUE) / 231,
         rank_3 = wtd.rank(pedu_3, weights = w, normwt = TRUE) / 231,
         rank_4 = wtd.rank(pedu_4, weights = w, normwt = TRUE) / 231,
         s = 
           (0.102 / 2) * pedu_1 + 
           (0.102 + 0.462 / 2) * pedu_2 + 
           (0.102 + 0.462 + 0.172 / 2) * pedu_3 + 
           (0.102 + 0.462 + 0.172 + 0.264 / 2) * pedu_4,
         s_rank = rank(s)/231)

RANK %>% select(contains("rank"),s,s_rank) %>% cor()
RANK %>% select(occ,rank_4,pedu_4) %>% arrange(rank_4) %>% print(n = 1000)
RANK %>% select(occ, s,s_rank) %>% print(n = 232)
RANK %>% select(occ,rank_1,rank_2,rank_3,rank_4, s,s_rank) %>% arrange(s_rank) %>% print(n = 232)


RANK %>% select(occ, contains("rank_"),s,s_rank) %>%
  pivot_longer(c(rank_1,rank_2,rank_3,rank_4), 
               values_to = "rank") %>%
  separate(name, sep = "_", into = c("X", "edu")) %>%
  mutate(edu = factor(edu, 
                      levels = 1:4,
                      labels = c("JH","HS","JC","Univ")
                      )) %>%
  ggplot(aes(x = factor(occ), y = rank, color = edu, shape = edu)) +
  geom_point() +
  theme_minimal()
  
RANK %>% ggplot(aes(x = s)) + 
  geom_histogram() +
  theme_minimal()

RANK %>% ggplot(aes(x = s_rank)) + 
  geom_histogram() +
  theme_minimal()

RANK %>% select(occ,edu_rank = s_rank) %>%
  write.csv("education_rank.csv", row.names	= FALSE)

exp(1.40) = p / (1 - p)

d <- d %>%
  mutate(total = edu_1 + edu_2 + edu_3 + edu_4 + edu_5,
         univ = edu_4 / total)

d <- d %>%
  group_by(occ) %>%
  mutate(Total = sum(edu_4) / sum(total))

d %>% 
  select(occ,gender,univ,Total) %>%
  pivot_wider(c(occ,Total),
              names_from = gender, 
              values_from = univ) %>%
  rename(univ_prop = Total,
         univ_prop_men = Men,
         univ_prop_women = Women)
