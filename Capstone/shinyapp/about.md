### The Project
Welcome! 

This application predicts the next word, or sequence of words, in a given text sequence using a simple backoff algorithm. It also
contains a word suggestion algorithm that matches letters from a given text sequence to find similar words.

This application was created for the [Data Science Capstone](https://www.coursera.org/learn/data-science-project/) from Johns Hopkins University and Coursera in cooperation with SwiftKey.

* [Github Repository](https://github.com/crhammond88/text-prediction)
* [Slideshow Presentation] (http://rpubs.com/crhammond88/text-prediction)


******

### The Models

There are four data models to explore in the app. Each model was created using the [Capstone Dataset](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip). The data was cleaned and filtered then tokenized into separate grams of one to five words. The frequency of each gram was then calculated to use as a statistical basis for predicting the most likely word in a sequence. 

The combination model was trained using the full english dataset provided. The blogs, news, and twitter models were trained using the full english dataset provided for each respective source.

******

### The Prediction Algorithms

The next word prediction algorithm uses one to four words to predict the next word by searching for matching word sequences in the corresponding model. The algorithm will begin by trying to match the longest sequence of words possible, then reduces its search by one word at a time until a match is found. If multiple matches are found with the same number of search words, the match with the highest frequency is then selected as the primary prediciton. If no match is found, the most frequent individual words in the current model are used as a default.

* The word cloud on the 'Next Word' tool will display alternative predictions. 

* The 'More Words' tool randomly selects between the two most likely predictions to avoid prediction loops. 

The predictions from the 'Word Suggestion' tool are based on a similar methodology to the next word prediciton algorithm. In this instance, individual letters are used to find matches by following a backoff process at the beginning and end of the input word. 

******

### The Accuracy

An independent dataset of news articles was used for validating the models for a more unbiased result. The results show that predictions are most accurate when using two words to predict a third. 

The context of the source text is also very important to the accuracy of the predictions. The news model achieved the highest performance due to the similarity of writing style in the validation set of news articles. The twitter model performed particularly poorly. The combination model achieved nearly as high of an accuracy rating as the news model, and it's expected to produce the best results across different types of text. 

![Validation Screenshot](validationResults.JPG)

* [Validation Dataset on Kaggle](https://www.kaggle.com/snapcrack/all-the-news)

******

### Ways to Improve

##### Better Data Cleaning 
* Punctuation can be utilized to improve predictions. Most punctuation was ignored.
* Removing foreign characters and website URLs would reduce noise in the models.
* Twitter data would be more accurate with filtering for hastags and '@' mentions. Special symbols were ignored.

##### Smarter Algorithm
* The models could be structured better for faster indexing to achieve higher prediciton speeds.
* A more sophisticated backoff algorithm could be used to calculate and compare the probability of different results between model sizes.
* The next word algorithm could use the word suggestion algorithm to attempt to find more meaningful results instead of relying on a default prediction.

##### More Data
* Support for additional languages could be added.
* Using larger datasets to build the models may yield higher prediction accuracy. 
* It may be possible to achieve higher accuracy in a specific medium by weighting the data from that source more heavily.



