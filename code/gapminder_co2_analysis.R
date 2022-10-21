library(tidyverse)
gapminder_data <- read_csv("data/gapminder_data.csv")

#summarizing our data

summarize(gapminder_data, averageLifeExp=mean(lifeExp))

gapminder_data %>% summarize(averageLifeExp=mean(lifeExp))

gapminder_data_summarized <- gapminder_data %>% 
  summarize(averageLifeExp=mean(lifeExp))

#filtering our data using filter()

gapminder_data %>%
  filter(year == 2007) %>%
  summarize(average=mean(lifeExp))


gapminder_data %>%
  filter(year==1952) %>%
  summarize(average_gdp = mean(gdpPercap)) 

# grouping data

gapminder_data %>%
  group_by(year) %>%
  summarise(average = mean(lifeExp))

gapminder_data %>%
  group_by(continent) %>%
  summarise(average = mean(lifeExp), min = min(lifeExp))

# adding new columns with mutate

gapminder_data %>%
  mutate(gdp = pop * gdpPercap,
         popInMillions = pop / 1000000)

#subset columns (or change their order) with select()

gapminder_data %>%
  select(pop, year)

       #reorganize and/or drop columns

gapminder_data %>%
  select(continent, country, pop)

# moving between long and wide data with pivot_wider() and pivot_longer()
# it's usually best to have data in long format, but here's and example of how you would switch between the two:

gapminder_data %>%
  select(country, continent, year, lifeExp) %>%
  pivot_wider(names_from = year, values_from = lifeExp)

#dataset for analysis

gapminder_data_2007 <- read_csv("data/gapminder_data.csv") %>%
  filter(year == 2007 & continent == "Americas") %>%
  select(-year, -continent)


# data cleaning

read_csv("data/co2-un-data.csv")
# first row does not contain headers; messy. Easiest to get rid of first
# two rows and then rename all of the columns

read_csv("data/co2-un-data.csv", skip = 2,
         col_names = c("region", "country", "year",
                       "series", "value", "footnotes", "source"))


read_csv("data/co2-un-data.csv", skip = 1)
# one of the columns is named "...2" which is a problem. can use rename()

read_csv("data/co2-un-data.csv", skip = 1) %>%
  rename("country" =...2)

# to remove capital letters from headers:
read_csv("data/co2-un-data.csv", skip = 1) %>%
  rename_all(tolower)

# save data to object

co2_emissions_dirty <- read_csv("data/co2-un-data.csv", skip = 2,
                                col_names = c("region", "country", "year",
                                              "series", "value", "footnotes", "source"))

#practicing select ()

co2_emissions_dirty %>%
  select(country, year, series, value)

# keyboard shortcut for the pipe operator %>% is command+shift+m

co2_emissions_dirty %>% 
  select(country, year, series, value) %>% 
  mutate(series = recode(series, "Emissions (thousand metric tons of carbon dioxide)" = "total_emissions",
                         "Emissions per capita (metric tons of carbon dioxide)" = "per_capita_emissions")) %>% 
  pivot_wider(names_from = series, values_from = value) %>% 
  # number of observations per year
  count(year)


co2_emissions <- co2_emissions_dirty %>% 
  select(country, year, series, value) %>% 
  mutate(series = recode(series, "Emissions (thousand metric tons of carbon dioxide)" = "total_emissions",
                         "Emissions per capita (metric tons of carbon dioxide)" = "per_capita_emissions")) %>% 
  pivot_wider(names_from = series, values_from = value) %>% 
  filter(year == 2005) %>% 
  select(-year)


# joining data frames

# inner_join(): drops rows that don't contain both ___?

df <- inner_join(gapminder_data_2007, co2_emissions)
df

# anti_join(): what are the observations that are in one but not the other?
anti_join(gapminder_data_2007, co2_emissions, 
          by = "country")

#starting from the beginning and adding:

co2_emissions <- read_csv("data/co2-un-data.csv",
                          skip = 2,
                          col_names = c("region", "country", "year",
                                        "series", "value", "footnotes", "source")) %>% 
  select(country, year, series, value) %>% 
  mutate (series = recode(series, "Emissions (thousand metric tons of carbon dioxide)" = "total_emissions",
                          "Emissions per capita (metric tons of carbon dioxide)" = "per_capita_emissions")) %>% 
  pivot_wider(names_from = series, values_from = value) %>% 
  filter(year == 2005) %>% 
  select(-year) %>% 
  mutate(country = recode(country,
                          "Bolivia (Plurin, State of)" = "Bolivia",
                          "United States of America" = "United States",
                          "Venezuela (Boliv. Rep. of)" = "Venezuela"))

# a second antijoin
anti_join(gapminder_data_2007, co2_emissions, by = "country")

gapminder_data_2007 <- read_csv("data/gapminder_data.csv") %>% 
  filter(year == 2007 & continent == "Americas") %>% 
  select (-year, -continent) %>% 
  mutate(country = recode(country, "Puerto Rico" = "United States")) %>% 
  group_by(country) %>% 
  summarise(lifeExp = sum(lifeExp * pop) / sum(pop),
            gdpPercap = sum(gdpPercap * pop) / sum(pop), 
            pop = sum(pop))

gapminder_co2 <- inner_join(gapminder_data_2007, co2_emissions, by = "country")

gapminder_co2 %>% 
  mutate(region = if_else(country == "Canada" | 
                            country == "United States" | 
                            country == "Mexico", "north", "south"))

write_csv(gapminder_co2, "data/gapminder_co2.csv")





















