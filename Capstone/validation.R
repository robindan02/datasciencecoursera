#### Test Prediction Accuracy
## Validation Dataset: https://www.kaggle.com/snapcrack/all-the-news

library(data.table)
library(formattable)

source('C:/Users/hp/Desktop/Coursera/Online Coursera/Capstone/Original/model.R')
source('C:/Users/hp/Desktop/Coursera/Online Coursera/Capstone/Original/shinyapp/prediction.R')

# Load validation data
articles1 <- fread("C:/Users/hp/Desktop/Coursera/Online Coursera/Capstone/Original/validation/articles1.csv", encoding = "UTF-8")[,10]
articles2 <- fread("C:/Users/hp/Desktop/Coursera/Online Coursera/Capstone/Original/validation/articles2.csv", encoding = "UTF-8")[,10]
articles3 <- fread("C:/Users/hp/Desktop/Coursera/Online Coursera/Capstone/Original/validation/articles3.csv", encoding = "UTF-8")[,10]

articles <- rbind(articles1, articles2, articles3)

# Sample Data
set.seed(1337)
dataSize <- nrow(articles)
testSize <- 10000
inValid <- sample(1:dataSize, testSize)

validationData <- articles[inValid,]

# Prepare validation data
validationData <- cleanSourceText(validationData)

twoGrams <- splitGrams(validationData, 2, c("word1", "word2"))
threeGrams <- splitGrams(validationData, 3, c("word1", "word2", "word3"))
fourGrams <- splitGrams(validationData, 4, c("word1", "word2", "word3", "word4"))
fiveGrams <- splitGrams(validationData, 5, c("word1", "word2", "word3", "word4", "word5"))

# Remove word grams with less than 10 occurences
filterNoise <- function(gramData) {
  return(filter(gramData, Freq > 9))
}

twoGrams <- filterNoise(twoGrams)
threeGrams <- filterNoise(threeGrams)
fourGrams <- filterNoise(fourGrams)
fiveGrams <- filterNoise(fiveGrams)

# Remove occurences of single letters that aren't really words
wrongLetters <- letters[!letters %in% c("a","i")]

twoGrams <- filter(twoGrams, !(word1 %in% wrongLetters | word2 %in% wrongLetters))
threeGrams <- filter(threeGrams, !(word1 %in% wrongLetters | word2 %in% wrongLetters | word3 %in% wrongLetters))
fourGrams <- filter(fourGrams, !(word1 %in% wrongLetters | word2 %in% wrongLetters | 
                                   word3 %in% wrongLetters | word4 %in% wrongLetters))
fiveGrams <- filter(fiveGrams, !(word1 %in% wrongLetters | word2 %in% wrongLetters | 
                                   word3 %in% wrongLetters | word4 %in% wrongLetters | word5 %in% wrongLetters))

# Paste all but the last word together to form a test
threeGrams <- data.frame(paste(threeGrams[,1], threeGrams[,2], sep = " "), threeGrams[,3]) %>%
  setNames(c("test", "answer"))
fourGrams <- data.frame(paste(fourGrams[,1], fourGrams[,2], fourGrams[,3], sep = " "), fourGrams[,4]) %>%
  setNames(c("test", "answer"))
fiveGrams <- data.frame(paste(fiveGrams[,1], fiveGrams[,2], fiveGrams[,3], fiveGrams[,4], sep = " "), fiveGrams[,5]) %>%
  setNames(c("test", "answer"))

# Only keep the highest frequency test term to prevent testing on duplicate words/phrases
removeDuplicates <- function(gramData) {
  return(gramData <- gramData[!duplicated(gramData$test),])
}

twoGrams <- twoGrams[!duplicated(twoGrams$word1),]
threeGrams <- removeDuplicates(threeGrams)
fourGrams <- removeDuplicates(fourGrams)
fiveGrams <- removeDuplicates(fiveGrams)


# Test model accuracy
checkAccuracy <- function(modelList) {
  
  bestPrediction <- function(inputText) {
    return(predictNextWord(inputText, modelList, 1)[1,1])
  }
  
  makePredictions <- function(gramData) {
    return(sapply(X = gramData[,1], FUN = bestPrediction))
  }
  
  checkPredictions <- function(predictions, gramData) {
    return(predictions == gramData[,2])
  }
  
  calculateAccuracy <- function(checkedData) {
    return(sum(checkedData)/length(checkedData))
  }
  
  twoGramsPredictions <- makePredictions(twoGrams) 
  threeGramsPredictions <- makePredictions(threeGrams) 
  fourGramsPredictions <- makePredictions(fourGrams) 
  fiveGramsPredictions <- makePredictions(fiveGrams) 
  
  twoGramsChecks <- checkPredictions(twoGramsPredictions, twoGrams)
  threeGramsChecks <- checkPredictions(threeGramsPredictions, threeGrams)
  fourGramsChecks <- checkPredictions(fourGramsPredictions, fourGrams)
  fiveGramsChecks <- checkPredictions(fiveGramsPredictions, fiveGrams)
  
  accuracy <- c(1:4)
  
  accuracy[1] <- calculateAccuracy(twoGramsChecks)
  accuracy[2] <- calculateAccuracy(threeGramsChecks)
  accuracy[3] <- calculateAccuracy(fourGramsChecks)
  accuracy[4] <- calculateAccuracy(fiveGramsChecks)
  
  return(accuracy)
}


# Run accuracy checks against all model sets
comboAccuracy <- checkAccuracy(comboModels)
blogsAccuracy <- checkAccuracy(blogsModels)
twitterAccuracy <- checkAccuracy(twitterModels)
newsAccuracy <- checkAccuracy(newsModels)

# Visualize results
results <- rbind(comboAccuracy, blogsAccuracy, twitterAccuracy, newsAccuracy)
colnames(results) <- c("1-Word", "2-Words", "3-Words", "4-Words")
rownames(results) <- c("Combined Model", "Blogs Model", "Twitter Model", "News Model")

percent(results)
results

# saveRDS(results, file = 'validationResults.rds')

# saveRDS(twoGrams, file = 'twoGramsValidation.rds')
# saveRDS(threeGrams, file = 'threeGramsValidation.rds')
# saveRDS(fourGrams, file = 'fourGramsValidation.rds')
# saveRDS(fiveGrams, file = 'fiveGramsValidation.rds')