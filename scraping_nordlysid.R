library(rvest)
library(dplyr)


df_2 <- data.frame(matrix(ncol = 2, nrow = 0))
#provide column names
colnames(df) <- c('text', 'iteration')

# timeout_vec <- seq(5866, 20000, 100)
# unknown = 0

for (i in 34647:74300) {
link = paste0("https://nordlysid.fo/tidindi/", i)
page = try(read_html(link))

if(substr(page[1],1,5) == "Error"){
  print("try_2")
  Sys.sleep(15)
  page = try(read_html(link))
  if(substr(page[1],1,5) == "Error"){
    print("try_3")
    Sys.sleep(15)
    page = try(read_html(link))
  }
}

name = page %>% html_nodes("#ease_adgroup_1 iframe , .newsarticle--self") %>% html_text()


  if (length(name) == 2) {
    df[nrow(df)+1, 1] <- name[2]
    df[nrow(df), 2] <- i
  } else if (length(name) == 0) {
    next
  }else {
    unknown = unknown + 1
  }
  print(i)
}


save(df, file = "Wordle/74300.Rdata")



