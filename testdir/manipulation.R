

library(tidyverse)

set.seed(123)

iris_sub <- as_tibble(iris) %>% 
  group_by(Species) %>% 
  sample_n(3) %>% 
  ungroup()

print(iris_sub)
filter(iris_sub, Species == "virginica")
filter(iris_sub, Species != "setosa")
filter(iris_sub, Petal.Length > 5, Sepal.Length > 5)

arrange(iris_sub, (Sepal.Width))

# Assignment <-
iris_3 <- filter(iris_sub, Sepal.Width > 3)

# Select ()
select(iris_sub, -c(Sepal.Length, Sepal.Width))
select(iris_sub, contains("al."))

# Mutate()
x_max <- nrow(iris_sub)
x <- 1:x_max

mutate(iris_sub, row_id = x)
mutate(iris_sub, mu_sl = mean(Sepal.Length))
mutate(iris_sub, sep.area = Sepal.Length * Sepal.Width / 2)

mutate(group_by(iris_sub, Species), mu_sl = mean(Sepal.Length))

# Pipe
iris_summary <- iris_sub |>  
  group_by(Species) |> 
  summarize(mu_sl= mean(Sepal.Length),
            sum_sl= sum(Sepal.Length))

iris_summary