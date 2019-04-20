library(shiny)

# Load Models
oneGramsCombo <- readRDS(file = 'models/combo/oneGramsCombo.rds')
twoGramsCombo <- readRDS(file = 'models/combo/twoGramsCombo.rds')
threeGramsCombo <- readRDS(file = 'models/combo/threeGramsCombo.rds')
fourGramsCombo <- readRDS(file = 'models/combo/fourGramsCombo.rds')
fiveGramsCombo <- readRDS(file = 'models/combo/fiveGramsCombo.rds')

oneGramsBlogs <- readRDS(file = 'models/blogs/oneGramsBlogs.rds')
twoGramsBlogs <- readRDS(file = 'models/blogs/twoGramsBlogs.rds')
threeGramsBlogs <- readRDS(file = 'models/blogs/threeGramsBlogs.rds')
fourGramsBlogs <- readRDS(file = 'models/blogs/fourGramsBlogs.rds')
fiveGramsBlogs <- readRDS(file = 'models/blogs/fiveGramsBlogs.rds')

oneGramsTwitter <- readRDS(file = 'models/twitter/oneGramsTwitter.rds')
twoGramsTwitter <- readRDS(file = 'models/twitter/twoGramsTwitter.rds')
threeGramsTwitter <- readRDS(file = 'models/twitter/threeGramsTwitter.rds')
fourGramsTwitter <- readRDS(file = 'models/twitter/fourGramsTwitter.rds')
fiveGramsTwitter <- readRDS(file = 'models/twitter/fiveGramsTwitter.rds')
 
oneGramsNews <- readRDS(file = 'models/news/oneGramsNews.rds')
twoGramsNews <- readRDS(file = 'models/news/twoGramsNews.rds')
threeGramsNews <- readRDS(file = 'models/news/threeGramsNews.rds')
fourGramsNews <- readRDS(file = 'models/news/fourGramsNews.rds')
fiveGramsNews <- readRDS(file = 'models/news/fiveGramsNews.rds')


comboModels <- list(oneGramsCombo, twoGramsCombo, threeGramsCombo, fourGramsCombo, fiveGramsCombo)
blogsModels <- list(oneGramsBlogs, twoGramsBlogs, threeGramsBlogs, fourGramsBlogs, fiveGramsBlogs)
twitterModels <- list(oneGramsTwitter, twoGramsTwitter, threeGramsTwitter, fourGramsTwitter, fiveGramsTwitter)
newsModels <- list(oneGramsNews, twoGramsNews, threeGramsNews, fourGramsNews, fiveGramsNews)
