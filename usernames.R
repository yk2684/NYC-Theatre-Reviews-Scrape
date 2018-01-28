library(rvest)
library(stringr)
library(data.table)

getwd()
#setting up working direcotry
setwd("Your_working_directory")
#clear environment
rm(list=ls())

#Load in the show link and add the page numbers - will loop through each page to scrape the usernames
#i.e. ('https://www.show-score.com/broadway-shows/once-on-this-island?page=', 1:23)
Show <- lapply(paste0('Link_to_Show_Of_Your_Choice', 1:100),
                function(url){
                  url %>% read_html() %>% 
                    html_nodes(".-light-gray") %>% 
                    html_text() })
Show <- unlist(Show)
Show

#Some cleaning of the scraped usernames
remove <- c("Edit \n", "Edit Show \n", "View in admin\n", "\nReport Abuse\n", " View in admin\n")
Show_username <- setdiff(Show, remove)
Show_username <- sapply(Show_username, tolower)
Show_username

Show_username <- gsub(" ", "-", Show_username, fixed=TRUE)
Show_username <- gsub("'", "-", Show_username, fixed=TRUE)
Show_username <- gsub(".", "", Show_username, fixed=TRUE)
Show_username

#Load in the scraped usernames to access their profile pages and scrape their age, gender, and location listed
Show_username_scrape <- lapply(paste0('https://www.show-score.com/member/', Show_username),
                                function(url){
                                  url %>% read_html() %>% 
                                    html_nodes(".user-details__main-info :nth-child(1)") %>% 
                                    html_text() })
Show_username_scrape_2 <- paste(Show_username_scrape, 1)
Show_username_scrape_2 <- gsub("c(\"", "", Show_username_scrape, fixed=TRUE)
Show_username_scrape_2 <- gsub("\"", "", Show_username_scrape_2, fixed=TRUE)
Show_username_scrape_2 <- gsub(")", "", Show_username_scrape_2, fixed=TRUE)
Show_username_scrape_2 <- gsub("|", "=", Show_username_scrape_2, fixed=TRUE)
Show_username_scrape_2 <- gsub(",", "=", Show_username_scrape_2, fixed=TRUE)
Show_username_scrape_2 <- str_trim(Show_username_scrape_2)

#Split the dataframe into 4 columns 
df.Show_username <- data.frame(str_split_fixed(Show_username_scrape_2, "=", 4))
#Delete the '='s
df.Show_username$X4 <- gsub("=", "", df.Show_username$X4, fixed=TRUE)

#Delete the first 25 rows
df.Show_username <- df.Show_username[-1:-25,]

#Add names to the columns
colnames(df.Show_username) <- c("Username", "Location", "Age", "Sex")

#Write to csv
write.csv(df.Show_username, "Show_username.csv")


