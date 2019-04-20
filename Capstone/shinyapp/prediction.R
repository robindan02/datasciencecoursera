library(shiny)
library(tm)
library(tokenizers)
library(stringr)
library(dplyr)

# Clean text 
cleanInputText <- function (inputText) {
  if(inputText == "") { return("") }
  
  cleanText <- inputText %>%
    str_replace_all("[^[:alnum:]'.:;&+-]", " ") %>% #remove unwanted characters and punctuation
    removeNumbers() %>%
    stripWhitespace() %>%
    tokenize_ngrams(n=1) %>% #split into single words (removes most punctuation & sets to lower)
    unlist()
  return(cleanText)
}

# Predict Two-gram if available
predictWordTwo <- function (inputText, modelList) {
  twoWords <- filter(modelList[[2]], word1 == inputText)
  if(nrow(twoWords) == 0) {
    twoWords <- modelList[[1]] #predict 1gram if nothing available
  }
  return(twoWords)
}

# Predict Three-gram if available
predictWordThree <- function (inputText, modelList) {
  threeWords <- filter(modelList[[3]], word1 == inputText[1], word2 == inputText[2])
  if(nrow(threeWords) == 0) {
    threeWords <- predictWordTwo(inputText[2], modelList)
  }
  return(threeWords)
}

# Predict Four-gram if available
predictWordFour <- function (inputText, modelList) {
  fourWords <- filter(modelList[[4]], word1 == inputText[1], word2 == inputText[2], word3 == inputText[3])
  if(nrow(fourWords) == 0) {
    fourWords <- predictWordThree(inputText[2:3], modelList)
  }
  return(fourWords)
}

# Predict Five-gram if available
predictWordFive <- function (inputText, modelList) {
  fiveWords <- filter(modelList[[5]], word1 == inputText[1], word2 == inputText[2], word3 == inputText[3], word4 == inputText[4])
  if(nrow(fiveWords) == 0) {
    fiveWords <- predictWordFour(inputText[2:4], modelList)
  }
  return(fiveWords)
}


# Predict the next word using backoff algorithm
predictNextWord <- function (inputText, modelList, maxWords=1, maxInput=4) {
  
  inputText <- cleanInputText(inputText)
  inputSize <- length(inputText)
  
  if(inputSize > maxInput) {
    firstWord <- inputSize - maxInput + 1
    inputText <- inputText[firstWord:inputSize]
    inputSize <- maxInput
  }
  
  if(inputSize == 4) {
    predictedWords <- predictWordFive(inputText, modelList)
  }
  else if(inputSize == 3) {
    predictedWords <- predictWordFour(inputText, modelList)
  }
  else if(inputSize == 2) {
    predictedWords <- predictWordThree(inputText, modelList)
  }
  else {
    predictedWords <- predictWordTwo(inputText, modelList)
  }
  
  numRows <- nrow(predictedWords)
  numCols <- ncol(predictedWords)
  
  if(numRows < maxWords) { maxWords <- numRows }
  
  return(predictedWords[1:maxWords,(numCols-1):numCols])
}

# Find words with similiar characters using oneGrams model
findSimilar <- function(inputText, modelList, maxWords) {
  cleanText <- cleanInputText(inputText)
  inputSize <- length(cleanText)
  
  cleanText <- cleanText[inputSize]
  
  if(is.na(cleanText) | cleanText == "") { matchedWords <- modelList[[1]] }
  else { 
    matchedWords <- matchWords(cleanText, inputText, modelList)
    matchedWordsBack <- matchWords(cleanText, inputText, modelList, front = FALSE)
    
    matchedWords <- union(matchedWords, matchedWordsBack)
    matchedWords <- filter(matchedWords, !(word == inputText))
    
    numRows <- nrow(matchedWords)
    
    if(numRows < maxWords) { maxWords <- numRows }
  }
  
  return(matchedWords[1:maxWords,1])
}

# Recursively find the best matches
matchWords <- function(inputText, originalText, modelList, front=TRUE) {
  matchedWords <- filter(modelList[[1]], grepl(inputText, word))
  matchedWords <- filter(matchedWords, !(word == originalText))
  
  if(nrow(matchedWords) == 0) {
    textSize <- nchar(inputText)
    if(front == TRUE) {
      newSize <- textSize - 1
      newText <- substr(inputText, 1, newSize)
    }
    else { newText <- substr(inputText, 2, textSize) }
    
    matchedWords <- matchWords(newText, originalText, modelList, front)
  }
  else { 
    if(front == TRUE) {    closeMatches <- startsWith(matchedWords$word, inputText)}
    else { closeMatches <- endsWith(matchedWords$word, inputText) }

    topResults <- filter(matchedWords, closeMatches)
    bottomResults <- filter(matchedWords, !closeMatches)
    matchedWords <- rbind(topResults, bottomResults)
  }
  return(matchedWords)
}