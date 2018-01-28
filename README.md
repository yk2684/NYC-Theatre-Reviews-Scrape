# Scraping NYC Theatre Reviews 

Script for scraping usernames, basic information on the users, and reviews of Broadway and Off-Broadway shows from [Show-Score](https://www.show-score.com/) (NYC theatre review aggregator) using R. 

### Dataset
Dataset for the users/reviews scraped are in each of the show folders (Scraped March 2017) - They are all saved as csv files.

Shows scraped:
* Aladdin
* Amelie
* Anastasia
* Bandstand
* Beautiful: The Carol King Musical
* A Bronx Tale, Cats
* Come From Away
* Charlie and the Chocolate Factory
* Chicago
* Dear Evan Hansen
* A Doll's House Part 2
* Falsettos
* Groundhog Day
* Hadestown
* Hamilton
* Hello, Dolly!
* Natasha, Pierre & the Great Comet of 1812
* The Price
* Sunset Boulevard
* Sweeney Todd

### usernames.R
Script to scrape usernames and their age, gender, and location listed on their profile page. 

### reviews.R
Script to scrape the show's score, reviewer, media associated with reviewer, date reviewed, and the review.