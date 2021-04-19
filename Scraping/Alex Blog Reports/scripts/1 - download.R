# 1 - Download Entries

library(rvest)
library(tidyverse)
library(tidytext)

#Get Entries into one data frame!

#Input URL
url <- "https://www.alexrecker.com/entries.html"
mainURL <- "https://www.alexrecker.com"

#Read URL
html_document <- read_html(url)

#Get Entry Links
links <- html_document %>% 
  html_nodes('td') %>% 
  html_children() %>% 
  html_attr('href')

#put it all together
allurls <- paste(mainURL, links, sep = "")

#Create a Function to get date, title, and body from entries and return as one data frame
scrape_alex_blog <- name <- function(url) {
  read_url_html <- read_html(url)
  
  date_text <- read_url_html %>% html_elements("h1") %>% html_text2()
  
  title_text <- read_url_html %>% html_elements("h2") %>% html_text2()
  
  body_text <- read_url_html %>% html_elements("body") %>% html_text2()
  
  
  entry <- data.frame(
    url = url,
    date = date_text,
    title = title_text,
    body = body_text)
  
  return(entry)
  
}

#iterate over all entries.
all_entries <- data.frame()
for (i in 1:length(allurls)) {
  cat("Downloading", i, "of", length(allurls), "URL:", allurls[i], "\n")
  entry <- scrape_alex_blog(allurls[i])
  # Append current article data.frame to the data.frame of all articles
  all_entries <- rbind(all_entries, entry)
}

#save text as data frame
write_csv(all_entries, file = "data/alex_blog.csv")
