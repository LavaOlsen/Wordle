library(stringr)
library(tidytext)
library(dplyr)
library(stringr)

df_words <- data.frame(matrix(ncol = 2, nrow = 0))
#provide column names
colnames(df_words) <- c('text', 'iteration')


for (i in 1:nrow(df)) {
  
df_words[i, 1] <- df[i,1] %>%
  gsub(pattern = "SKRIVAÐ:.*Eldri tíðindi"
       , replacement = "") %>% 
  gsub(pattern = "\t"
     , replacement = "") %>% 
  gsub(pattern = "\r"
       , replacement = "") %>% 
  gsub(pattern = "\n"
       , replacement = "") %>% 
  gsub(pattern = "|"
       , replacement = "") %>% 
  gsub(pattern = "Gev okkum eitt prei"
       , replacement = "") %>% 
  str_to_lower() %>% 
  str_replace_all("[^[:alpha:]']", " ")

df_words[i, 2] <- df[i,2]

}

df_words <- unnest_tokens(tbl = df_words, output = word, input = text, token = "words")

words_count_overall <- df_words %>%
  count(word, sort=TRUE) 

