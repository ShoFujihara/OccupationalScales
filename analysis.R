# load packages
library(tidyverse)
library(ggrepel)

# data
d <- read_csv("JESS_232_sei_ssi_v1.0.csv")
japan <- read_csv("Japanese_title_occupation.csv")

# plot
d %>% 
  left_join(japan, by = "occ") %>% 
  drop_na(sei, ssi) %>%
  ggplot(aes(x = sei, y = ssi)) +
  geom_point(alpha = 0.5) +
  geom_text_repel(aes(label = str_sub(jtitle, start = 1, end = 4)),
                  family = "HiraKakuPro-W3",
                  max.overlaps = 12) +
  geom_smooth(
    method = lm,
    se = FALSE,
    color = "black",
    linetype = "dashed",
    size = 0.5,
  ) +
  labs(x = "SEI", y = "Status") + 
  theme_minimal(base_family = "HiraKakuPro-W3")
