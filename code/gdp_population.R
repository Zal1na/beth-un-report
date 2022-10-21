library(tidyverse) # to import data files, file->import dataset ->from text (readr)

gapminder_1997 <- read_csv("gapminder_1997.csv")

name <- "Ben"
name
age <- 26
age
name <- "harry potter" # objects can't start with a number (e.g. 1name) or have a space (the name)
name
round(3.1415927,2)
getwd() # outputs the current working directory
ggplot(data = gapminder_1997) + # plotting begins; hitting tab auto-fills the code that Rstudio guesses
  aes(x = gdpPercap) + # "+" chains together functions in ggplot
  labs(x = "GDP Per Capita") + #labs funtion for labels
  aes(y = lifeExp) +
  labs(y = "Life Expectancy") +
  geom_point() +
  labs(title = "Do People in Wealthy Countries Live Longer?") +
  aes(color = continent) +
  scale_color_brewer(palette = "Set1") +
  aes(size = pop/1000000) +
  labs(size = "population in millions")

#to clean this code up, you can combine like this:

ggplot(data = gapminder_1997) +
  aes(x = gdpPercap, y = lifeExp, color = continent, size =pop/1000000) +
  geom_point() +
  scale_color_brewer(palette = "Set1") +
  labs(x = "GDP Per Capita", y = "Life Expectancy", 
       title = "Do people in wealthy countries live longer?", size = "population in millions")

#plotting for data exploration

gapminder_data <- read_csv("gapminder_data.csv")
view(gapminder_data)

ggplot(data = gapminder_data) +
  aes(x = year, y = lifeExp, color = continent) +
  geom_point()
str(gapminder_data)
#what about making this a line plot?
ggplot(data = gapminder_data) +
  aes(x = year, y = lifeExp, color = continent) +
  geom_line() #that's even worse!
ggplot(data = gapminder_data) +
  aes(x = year, y = lifeExp, color = continent, group = country) +
  geom_line() 

ggplot(data = gapminder_data) +
  aes(x = continent, y = lifeExp) +
  geom_boxplot() 

ggplot(data = gapminder_1997) +
  aes(x = continent, y = lifeExp) +
  geom_jitter() +
  geom_violin()

ggplot (data = gapminder_1997, aes(x=continent, y=lifeExp)) +
  geom_violin() +
  geom_jitter(aes(size=pop))

ggplot (data = gapminder_1997, aes(x=continent, y=lifeExp)) +
  geom_violin(aes(fill = continent)) +
  geom_jitter(alpha=0.5) #alpha designates transparency

ggplot(gapminder_1997) +
  aes(x=lifeExp) +
  geom_histogram(binwidth=2)

ggplot(gapminder_1997) +
  aes(x=lifeExp) +
  geom_density()

#ggplot2 themes

ggplot(gapminder_1997) +
  aes(x=lifeExp) +
  geom_histogram() +
  theme_classic()

ggplot(gapminder_1997) +
  aes(x=lifeExp) +
  geom_histogram(bins=20) +
  theme_minimal() +
  theme(axis.text.x=element_text(angle = 45, vjust=0.75, hjust = 0.75))

# Facet

ggplot(gapminder_1997) +
  aes(x=gdpPercap, y = lifeExp) +
  geom_point() +
  facet_wrap(vars(continent)) 

ggplot(gapminder_1997) +
  aes(x=gdpPercap, y = lifeExp) +
  geom_point() +
  facet_grid(rows = vars(continent))

ggsave("awesome_plot.jpg", width = 6, height = 4) #the default is to save the last plot that was run

violin_plot <- ggplot(data =gapminder_1997)+
  aes(x=continent, y=lifeExp)+
  geom_violin(aes(fill=continent))+theme_bw()

violin_plot

ggsave(plot=violin_plot, 
       filename="awesome_violin_plot.jpg",
       width=6,
       height=4)

install.packages(c("gganimate","gifski"))
library(gganimate)
library(gifski)

ggplot(data=gapminder_data)+
  aes(x=log(gdpPercap), y=lifeExp, size=pop, color=continent)+
  geom_point()


staticHansPlot <- ggplot(data=gapminder_data)+
  aes(x=log(gdpPercap), y=lifeExp, size=pop/1000000, color=continent)+
  geom_point(alpha=0.5)+
  scale_color_brewer(palette="Set1")+
  labs(x="GDP Per Capita", y="Life Expectancy", color="Continent", size = "Population (in millions)") +
  theme_classic()

staticHansPlot

animatedHansPlot <- staticHansPlot +
  transition_states(year, transition_length = 1, state_length = 1) +
  ggtitle("{closest_state}")

animatedHansPlot

anim_save("hansAnimatedPlot.gif",
          plot=animatedHansPlot,
          renderer = gifski_renderer())
