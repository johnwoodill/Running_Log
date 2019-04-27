library(tidyverse)
library(lubridate)
library(ggthemes)
library(scales)

dat <- read_csv("data/run_log.csv")

dat <- dat %>% 
  group_by(date) %>% 
  summarise(miles = sum(miles),
            time = sum(time),
            time = as.numeric(time/60/60),
            notes = paste0(notes, collapse = '; ')) %>% 
  ungroup()

dat$date <- as.Date(dat$date, "%m-%d-%Y")
dat <- ungroup(dat)
class(dat$date)
mdat <- data.frame(date = as.Date(seq(mdy("01-01-2019"), mdy("12-31-2019"), by = "1 day")))
head(mdat)
mdat <- left_join(mdat, dat, by = "date")
mdat$month <- month(mdat$date, label = TRUE)
mdat$week <- floor_date(mdat$date, unit="week", week_start=1)
mdat$week <- as.numeric(as.factor(mdat$week))
mdat$week_count <- paste0(mdat$month, " (W", mdat$week, ")")


head(mdat)
mdat$miles <- replace_na(mdat$miles, 0)

pdat1 <- mdat %>% 
  group_by(week_count) %>% 
  summarise(miles = sum(miles, na.rm = TRUE),
            time = sum(time, na.rm = TRUE),
            week = mean(week, na.rm = TRUE)) %>% 
  arrange(week) %>% 
  ungroup()

head(pdat1)

pdat1$week_count <- factor(pdat1$week_count, levels = pdat1$week_count, labels = pdat1$week_count)

ggplot(pdat1, aes(x=week_count,  y=miles)) +
  geom_bar(stat="identity", fill="#619CFF") +
  theme_tufte(11) +
  geom_text(data = filter(pdat1, miles > 0), aes(label=round(miles, 2)), vjust=-1) +
  annotate("segment", x=-Inf, xend=Inf, y=-Inf, yend=-Inf, color = "grey", size=1) + #Bottom
  annotate("segment", x=-Inf, xend=-Inf, y=-Inf, yend=Inf, color = "grey", size=1) + # Left
  annotate("segment", x=Inf, xend=Inf, y=-Inf, yend=Inf, color = "grey", size=1) + # Right
  annotate("segment", x=-Inf, xend=Inf, y=Inf, yend=Inf, color = "grey", size=1) + # Top
  labs(x=NULL, y="MPW") +
  ylim(0, max(pdat1$miles) + 1) +
  theme(axis.text.x = element_text(angle=45, vjust=1, hjust=1)) +
  NULL

ggsave("figures/mpw_bar.tiff", width = 12, height = 6)