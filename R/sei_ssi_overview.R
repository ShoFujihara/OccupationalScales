# sei_ssi_overview.R
# Generate the SEI and SSI overview figure (figures/sei_ssi_overview.svg)

library(tidyverse)
library(patchwork)

# Load data
d <- read_csv("JESS_232_sei_ssi_v1.0.csv")

# Distribution plot (SEI and SSI) - density curves
p1 <- d |>
  select(sei, ssi) |>
  pivot_longer(cols = everything(), names_to = "index", values_to = "value") |>
  mutate(index = toupper(index)) |>
  ggplot(aes(x = value, fill = index)) +
  geom_density(alpha = 0.4) +
  scale_fill_manual(values = c("SEI" = "#1F77B4", "SSI" = "#FF7F0E")) +
  labs(
    title = "Distribution of SEI and SSI",
    x = "Score",
    y = "Density",
    fill = NULL
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

# Scatter plot (SEI vs SSI)
p2 <- d |>
  ggplot(aes(x = sei, y = ssi)) +
  geom_point(alpha = 0.6) +
  geom_abline(slope = 1, intercept = 0, color = "#E74C3C") +
  labs(
    title = "SEI vs SSI",
    x = "SEI",
    y = "SSI"
  ) +
  theme_minimal()

# Combine plots
combined <- p1 + p2 +
  plot_annotation(
    title = "Socio-Economic Index (SEI) and Social Status Index (SSI)"
  )

# Save figure
ggsave(
  "figures/sei_ssi_overview.svg",
  plot = combined,
  width = 10,
  height = 5,
  bg = "white"
)

ggsave(
  "figures/sei_ssi_overview.png",
  plot = combined,
  width = 10,
  height = 5,
  dpi = 300,
  bg = "white"
)
