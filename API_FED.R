# Macro Avan - Tutorial 7 - Kevin Lima
# Estabelecendo pacotes
library(dplyr)
library(ggplot2)
library(stargazer)
library(fredr)
library(signal)
library(mFilter)
library(quantmod)
library(ggthemes)  
library(scales) 
library(patchwork)  
library(ipeadatar)
library(devtools)
library(neverhpfilter)
library(tidyverse)
library(summarytools)
library(tidyverse)
library(ggpubr)
library(mFilter)

# PIB e M2
fredr_set_key("85b22f476f8c978315f5bd0343e0e172")
gdp <- fredr(series_id = "A939RX0Q048SBEA")
gdp <- gdp[-c(2,4,5)]
colnames(gdp) <- c("date", "gdp")

M2 <- fredr(series_id = "M2REAL")
M2 <- M2[-c(2,4,5)]
colnames(M2) <- c("date", "M2")
M2 <- M2 %>%
  dplyr::filter(month(date) %in% c(1, 4, 7, 10))

df <- full_join(gdp, M2, by = "date")
df <- na.omit(df)


df <- df %>%
  mutate(
    tM2 = (M2 / lag(M2) - 1) * 100,
    tgdp = (gdp / lag(gdp) - 1) * 100)

hp_M2 <- hpfilter(df$M2, freq = 1600)  
df$M2_tend <- hp_M2$trend  
df$M2_cic <- hp_M2$cycle       
hp_gdp <- hpfilter(df$gdp, freq = 1600)  
df$gdp_tend <- hp_gdp$trend  
df$gdp_cic <- hp_gdp$cycle  

        
ggplot(df, aes(x = M2, y = gdp)) +
  geom_point(color = "blue", alpha = 0.6) +           
  geom_smooth(method = "lm", se = TRUE, color = "red") +  
  labs(
    title = "Relação entre M2 e gdp",
    x = "M2",
    y = "gdp"
  ) +
  theme_minimal()

ggplot(df, aes(x = tM2, y = tgdp)) +
  geom_point(color = "blue", alpha = 0.6) +           
  geom_smooth(method = "lm", se = TRUE, color = "red") +  
  labs(
    title = "Relação entre taxa de variação M2 e gdp",
    x = "M2",
    y = "gdp"
  ) +
  theme_minimal()

ggplot(df, aes(x = M2_cic, y = gdp_cic)) +
  geom_point(color = "blue", alpha = 0.6) +           
  geom_smooth(method = "lm", se = TRUE, color = "red") +  
  labs(
    title = "Relação entre ciclo M2 e gdp",
    x = "M2",
    y = "gdp"
  ) +
  theme_minimal()


mod1 <- lm(gdp ~ M2, data = df)
summary(mod1)
mod2 <- lm(tgdp ~ tM2, data = df)
summary(mod2)
mod3 <- lm(gdp_cic ~ M2_cic, data = df)
summary(mod3)


# inflação e M2
fredr_set_key("85b22f476f8c978315f5bd0343e0e172")
infla <- fredr(series_id = "A939RX0Q048SBEA")
infla <- infla[-c(2,4,5)]
colnames(infla) <- c("date", "infla")
infla <- infla %>%
  dplyr::filter(month(date) %in% c(1, 4, 7, 10))

M2 <- fredr(series_id = "M2REAL")
M2 <- M2[-c(2,4,5)]
colnames(M2) <- c("date", "M2")
M2 <- M2 %>%
  dplyr::filter(month(date) %in% c(1, 4, 7, 10))

df1 <- full_join(infla, M2, by = "date")
df1 <- na.omit(df1)


df1 <- df1 %>%
  mutate(
    tM2 = (M2 / lag(M2) - 1) * 100,
    tinfla = (infla / lag(infla) - 1) * 100)

hp_M2 <- hpfilter(df1$M2, freq = 1600)  
df1$M2_tend <- hp_M2$trend  
df1$M2_cic <- hp_M2$cycle       
hp_infla <- hpfilter(df1$infla, freq = 1600)  
df1$infla_tend <- hp_infla$trend  
df1$infla_cic <- hp_infla$cycle  


ggplot(df1, aes(x = M2, y = infla)) +
  geom_point(color = "blue", alpha = 0.6) +           
  geom_smooth(method = "lm", se = TRUE, color = "red") +  
  labs(
    title = "Relação entre M2 e inflação",
    x = "M2",
    y = "infla"
  ) +
  theme_minimal()

ggplot(df1, aes(x = tM2, y = infla)) +
  geom_point(color = "blue", alpha = 0.6) +           
  geom_smooth(method = "lm", se = TRUE, color = "red") +  
  labs(
    title = "Relação entre taxa de variação M2 e inflação",
    x = "M2",
    y = "infla"
  ) +
  theme_minimal()

ggplot(df1, aes(x = M2_cic, y = infla_cic)) +
  geom_point(color = "blue", alpha = 0.6) +           
  geom_smooth(method = "lm", se = TRUE, color = "red") +  
  labs(
    title = "Relação entre ciclo M2 e inflação",
    x = "M2",
    y = "infla"
  ) +
  theme_minimal()


mod1 <- lm(infla ~ M2, data = df1)
summary(mod1)
mod2 <- lm(tinfla ~ tM2, data = df1)
summary(mod2)
mod3 <- lm(infla_cic ~ M2_cic, data = df1)
summary(mod3)


# inflação e desemprego
fredr_set_key("85b22f476f8c978315f5bd0343e0e172")
infla <- fredr(series_id = "A939RX0Q048SBEA")
infla <- infla[-c(2,4,5)]
colnames(infla) <- c("date", "infla")
infla <- infla %>%
  dplyr::filter(month(date) %in% c(1, 4, 7, 10))

des <- fredr(series_id = "UNRATE")
des <- des[-c(2,4,5)]
colnames(des) <- c("date", "des")
des <- des %>%
  dplyr::filter(month(date) %in% c(1, 4, 7, 10))

df2 <- full_join(infla, des, by = "date")
df2 <- na.omit(df2)


df2 <- df2 %>%
  mutate(
    tdes = (des / lag(des) - 1) * 100,
    tinfla = (infla / lag(infla) - 1) * 100)

hp_des <- hpfilter(df2$des, freq = 1600)  
df2$des_tend <- hp_des$trend  
df2$des_cic <- hp_des$cycle       
hp_infla <- hpfilter(df2$infla, freq = 1600)  
df2$infla_tend <- hp_infla$trend  
df2$infla_cic <- hp_infla$cycle  


ggplot(df2, aes(x = des, y = infla)) +
  geom_point(color = "blue", alpha = 0.6) +           
  geom_smooth(method = "lm", se = TRUE, color = "red") +  
  labs(
    title = "Relação entre des e inflação",
    x = "des",
    y = "infla"
  ) +
  theme_minimal()

ggplot(df2, aes(x = tdes, y = tinfla)) +
  geom_point(color = "blue", alpha = 0.6) +           
  geom_smooth(method = "lm", se = TRUE, color = "red") +  
  labs(
    title = "Relação entre taxa de variação des e inflação",
    x = "des",
    y = "infla"
  ) +
  theme_minimal()

ggplot(df2, aes(x = des_cic, y = infla_cic)) +
  geom_point(color = "blue", alpha = 0.6) +           
  geom_smooth(method = "lm", se = TRUE, color = "red") +  
  labs(
    title = "Relação entre ciclo des e inflação",
    x = "des",
    y = "infla"
  ) +
  theme_minimal()


mod1 <- lm(infla ~ des, data = df2)
summary(mod1)
mod2 <- lm(tinfla ~ tdes, data = df2)
summary(mod2)
mod3 <- lm(infla_cic ~ des_cic, data = df2)
summary(mod3)


# juros e M2
fredr_set_key("85b22f476f8c978315f5bd0343e0e172")
jur <- fredr(series_id = "TB3MS")
jur <- jur[-c(2,4,5)]
colnames(jur) <- c("date", "jur")
jur <- jur %>%
  dplyr::filter(month(date) %in% c(1, 4, 7, 10))

M2 <- fredr(series_id = "M2REAL")
M2 <- M2[-c(2,4,5)]
colnames(M2) <- c("date", "M2")
M2 <- M2 %>%
  dplyr::filter(month(date) %in% c(1, 4, 7, 10))

df3 <- full_join(jur, M2, by = "date")
df3 <- na.omit(df3)


df3 <- df3 %>%
  mutate(
    tM2 = (M2 / lag(M2) - 1) * 100,
    tjur = (jur / lag(jur) - 1) * 100)

hp_M2 <- hpfilter(df3$M2, freq = 1600)  
df3$M2_tend <- hp_M2$trend  
df3$M2_cic <- hp_M2$cycle       
hp_jur <- hpfilter(df3$jur, freq = 1600)  
df3$jur_tend <- hp_jur$trend  
df3$jur_cic <- hp_jur$cycle  


ggplot(df3, aes(x = M2, y = jur)) +
  geom_point(color = "blue", alpha = 0.6) +           
  geom_smooth(method = "lm", se = TRUE, color = "red") +  
  labs(
    title = "Relação entre M2 e juros",
    x = "M2",
    y = "juros"
  ) +
  theme_minimal()

ggplot(df3, aes(x = tM2, y = tjur)) +
  geom_point(color = "blue", alpha = 0.6) +           
  geom_smooth(method = "lm", se = TRUE, color = "red") +  
  labs(
    title = "Relação entre taxa de variação M2 e juros",
    x = "M2",
    y = "juros"
  ) +
  theme_minimal()

ggplot(df3, aes(x = M2_cic, y = jur_cic)) +
  geom_point(color = "blue", alpha = 0.6) +           
  geom_smooth(method = "lm", se = TRUE, color = "red") +  
  labs(
    title = "Relação entre ciclo M2 e juros",
    x = "M2",
    y = "juros"
  ) +
  theme_minimal()


mod1 <- lm(jur ~ M2, data = df3)
summary(mod1)
mod2 <- lm(tjur ~ tM2, data = df3)
summary(mod2)
mod3 <- lm(jur_cic ~ M2_cic, data = df3)
summary(mod3)


# juros e gdp
fredr_set_key("85b22f476f8c978315f5bd0343e0e172")
gdp <- fredr(series_id = "A939RX0Q048SBEA")
gdp <- gdp[-c(2,4,5)]
colnames(gdp) <- c("date", "gdp")


jur <- fredr(series_id = "TB3MS")
jur <- jur[-c(2,4,5)]
colnames(jur) <- c("date", "jur")
jur <- jur %>%
  dplyr::filter(month(date) %in% c(1, 4, 7, 10))

df4 <- full_join(jur, gdp, by = "date")
df4 <- na.omit(df4)


df4 <- df4 %>%
  mutate(
    tjur = (jur / lag(jur) - 1) * 100,
    tgdp = (gdp / lag(gdp) - 1) * 100)

hp_jur <- hpfilter(df4$jur, freq = 1600)  
df4$jur_tend <- hp_jur$trend  
df4$jur_cic <- hp_jur$cycle       
hp_gdp <- hpfilter(df4$gdp, freq = 1600)  
df4$gdp_tend <- hp_gdp$trend  
df4$gdp_cic <- hp_gdp$cycle  


ggplot(df4, aes(x = jur, y = gdp)) +
  geom_point(color = "blue", alpha = 0.6) +           
  geom_smooth(method = "lm", se = TRUE, color = "red") +  
  labs(
    title = "Relação entre juros e gdp",
    x = "juros",
    y = "gdp"
  ) +
  theme_minimal()

ggplot(df4, aes(x = tjur, y = tgdp)) +
  geom_point(color = "blue", alpha = 0.6) +           
  geom_smooth(method = "lm", se = TRUE, color = "red") +  
  labs(
    title = "Relação entre taxa de variação juros e gdp",
    x = "juros",
    y = "gdp"
  ) +
  theme_minimal()

ggplot(df4, aes(x = jur_cic, y = gdp_cic)) +
  geom_point(color = "blue", alpha = 0.6) +           
  geom_smooth(method = "lm", se = TRUE, color = "red") +  
  labs(
    title = "Relação entre ciclo juros e gdp",
    x = "juros",
    y = "gdp"
  ) +
  theme_minimal()


mod1 <- lm(gdp ~ jur, data = df4)
summary(mod1)
mod2 <- lm(tgdp ~ tjur, data = df4)
summary(mod2)
mod3 <- lm(gdp_cic ~ jur_cic, data = df4)
summary(mod3)
