library(rvest)
library(stringr)
library(tidyr)
library(dplyr)
library(data.table)

#Load in website
# i.e. https://www.show-score.com/broadway-shows/dear-evan-hansen
Show <- html("Link")
#select to scrape the reviews by looking at website HTML
selector_name <- ".show-review-tile"
Show_reviews <-html_nodes(x = Show, css = selector_name) %>%
html_text()
head(Show_reviews)

##Cleaning text
#Replace these characters and words with whitespace. (.{62}$ - getting rid 62 characters from the end of the sring)
Show_reviews_clean <- gsub('\\"|\\?|\\n|Off|Get|Alerts|Edit|votes|Full Review|Helpful|.{62}$', " ", Show_reviews)
head(Show_reviews_clean)

#Replace whitespace between scores, news outelets, reviewers, etc. with "="
Show_reviews_clean <- gsub('     ', "=", Show_reviews_clean, fixed=TRUE)
Show_reviews_clean <- gsub('    ', "=", Show_reviews_clean, fixed=TRUE)
Show_reviews_clean <- gsub('    ', "=", Show_reviews_clean, fixed=TRUE)
Show_reviews_clean <- gsub('        ', "=", Show_reviews_clean, fixed=TRUE)
Show_reviews_clean <- gsub('            ', "=", Show_reviews_clean, fixed=TRUE)
Show_reviews_clean <- gsub('      ', "=", Show_reviews_clean, fixed=TRUE)
head(Show_reviews_clean)

#Remove leading and trailing white space
Show_final <- str_trim(Show_reviews_clean)
#Convert text into a dataframe
df.Show <- data.frame(Show_final)
#Split the dataframe into 8 columns
df.Show <- str_split_fixed(Show_final, "=", 8)
#Delete the first column
df.Show <- df.Show[, -1] #delete column 1
#Delete empty column and the column with "On"
df.Show <- df.Show[, -c(4:5)] # delete columns 4 through 5
#Add names to the columns
colnames(df.Show) <- c("Score", "Media", "Reviewer", "Date", "Review")

#Split dataframe into two (professional reviews/user reviews)
df.Show_1 <- df.Show[1:25,] #Select the first 25 rows
df.Show_2 <- df.Show[26:50,] #Select the rest of the rows

#Clean the second dataframe (user reviews)
#Move date in the Review column into the Date column
df.Show_2$Date <- str_split_fixed(df.Show_2$Review, "See.*", 2)
#Delete the date in the Review column
df.Show_2$Review <- gsub(".*See", "", df.Show_2$Review)
#Merge the two dataframes into one
df.Show <- rbind(df.Show_1, df.Show_2)

#Write to csv
write.csv(df.Show, "Show_text_analysis.csv")


