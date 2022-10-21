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


gapminder_data_2007
























