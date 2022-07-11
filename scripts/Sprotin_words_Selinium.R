
library('RSelenium')
library("tidyverse")
library("netstat")

#find chrome versions
binman::list_versions("chromedriver")


#start the server
rs_driver_object <- rsDriver(browser = 'chrome',
                             chromever = "103.0.5060.53", 
                             verbose = TRUE, 
                             port = free_port())


#we need to acces the client site
#create a client object
remDr <- rs_driver_object$client

# open a browser
remDr$open()

#maximize window
remDr$maxWindowSize()



#getting words

alfabet <- c("a", "á", "b", "d", "e", "f", "g", "h", "i", "í", "j", "k", "l", "m", "n", "o", "ó", "p", "r", "s", "t", "u", "ú", "v", "y", "ý", "æ", "ø") # ð is missing, since no word is starting with ð


#for (i in 1:length(alfabet)) {
 

for (i in 7:length(alfabet)) {
  
# navigate to website
remDr$navigate('https://sprotin.fo/dictionaries?_SearchFor=&_SearchInflections=0&_SearchDescriptions=0&_Group=&_DictionaryId=1&_DictionaryPage=1')
Sys.sleep(2)

  #find element
  search_box <- remDr$findElement(using = "class name", "dictionary-input--textbox")
  search_box$sendKeysToElement(list(alfabet[i]))
  print(alfabet[i])
  Sys.sleep(3)
  search_buttom <- remDr$findElement(using = "class name", "dictionary-input--search-icon")
  search_buttom$clickElement()
  Sys.sleep(3)
  total_results <- remDr$findElement(using = "class name", "dictionary-selector--total-results")
  Sys.sleep(2)
  total_result_character <- total_results$getElementText() %>%  unlist() %>% as.numeric()
  total_iterations <- ceiling(total_result_character/100) #rounding up
  
  print(total_iterations)
  
  for (j in 1:total_iterations) {
    
  #find all the words within a search
  Sys.sleep(5)
  words <- remDr$findElements(using = "class name", "dictionary-results--word-title")
  Sys.sleep(5)
  
  
  #how many words are there?
  #length(words)
  
  #we need lapply to extract the words, since they are in a list
  
  # t$getElementText()
  words_unlisted <- lapply(X = words, function (x) x$getElementText()) %>% 
    unlist()
  Sys.sleep(3)
  
  if(i == 1 & j == 1){
    words_total = words_unlisted
  } else {
    words_total = c(words_total, words_unlisted)
  }
  
  print(length(words_total))
  
  if (j < total_iterations) {
  Sys.sleep(2)
  next_buttom <- remDr$findElement(using = "class name", "dictionary-results--pager-item--next")
  Sys.sleep(2)
  next_buttom$clickElement()
  Sys.sleep(2)
  search_buttom$clickElement()
  }
  
  }
  save(words_total, file = "Github/Wordle/total_words.Rdata")
}





# elementId <- next_buttom$elementId
# 
# if (elementId == next_buttom$elementId) {
#   
# }




#after all the words are retreived, we want to

#1 remove all the numbers from the strings (since there might be two words, called hey1, hey2, e.g. same spelling, but different meaning).

#2 take unique of all the words.
