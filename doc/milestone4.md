# Milestone 4

Contributors: Alycia Butterworth ([alyciakb](https://github.com/alyciakb)), George J. J. Wu ([GeorgeJJW](https://github.com/GeorgeJJW))

Given the time limit of this week's milestone, we believe we can further improve our application by implementing the following changes.

#### Changes 1: Interactivity between components

To explore how the crime rates of a city has changed over time, users can now select a city directly from the map panel.

![map_select](https://i.imgur.com/stLxkvv.gif)

Users can also select a city directly from the rank table panel.

![table_select](https://i.imgur.com/9uU5ae1.gif)

By connecting different components of our application together, we aim to enhance one of the core functionalities of this project - we want to empower users to compare the crime rates of different cities at a particular point in time, as well as to explore how the crime rates of a city has changed over time. By linking the map panel and the rank table panel to the time series chart, we hope we have fundamentally improved the usability of our application.

#### Changes 2: Removed Honolulu

The city Honolulu is not visible within the zoom and pan bounds of the map panel. The data points for this city has been excluded from this project. We want data points across app components to be as consistent as possible.

#### Change 3: Removed header

We removed the header component of our application, as we found it to be redundant in relation to the interactive titles above the map panel. We want to keep the user interface of our app as compact and minimal as possible.

#### Changes 4: Refactored data wrangling pipeline

Previously the data wrangling logic of this project was embedded in a poorly organized [RMarkdown document](https://github.com/UBC-MDS/violent_crimes_usa/blob/master/src/eda.Rmd). We want to make this data project more maintainable as well as more reproducible. For these reasons, we have refactored our data wrangling pipeline into a standalone R script document called [prepare_data.R](https://github.com/UBC-MDS/violent_crimes_usa/blob/master/src/prepare_data.R).

## If we were to start over...

Throughout the MDS program, we've been told that data cleaning is about 80% of a data scientist's job. If we were to go back and start again, we would devote more time to the data cleaning portion, as we did a more minimalistic approach to it this time, which led to extra challenges.

We left our data in a wide dataframe with our crime rates each being in their own column. Starting over, we could combine all four crimes into two columns: the values in one column being the name of the crime, ex. "homicide", and the other column having the per capita rate of that crime. This would cause our dataframe to be significantly longer, but it would make the downstream reactive process much easier. It would be especially prevalent in the coding for displaying information for multiple crimes over multiple years. Further, had we created a more workable dataframe to begin with, we think it would've been easier to add more options for the users.

Unfortunately, by the time we realized that our data would be easier to work with in a different format, we had made too much progress on our app and we would've had to rewrite most of the app in order to rectify the situation. Due to time constraints, this was not an option. If we were to start again, we would spend more time early on looking at the data and reformatting it to be more usable for our purpose.


## Greatest Challenges

#### George:

I found it surprisingly challenging to visualize less frequent crime types in conjunction with more frequent crime types. On the map panel, for instance, the less frequent crime types such as rape and homicide incidents tend to get "drowned out" by the more frequent crimes types such as robbery and aggravated assault. I wish I could implement a solution to dynamically re-discretize crime rates to different colours, normalized to the max value of crime rates that is being plotted.

I also found the data wrangling process to be surprisingly labourious. I had to revisit our data wrangling logic a number of times throughout the project to re-evaluate the integrity and validity of our data. I found that many bugs and other issues in the application were often introduced by my failure to wrangle the data properly.  

#### Alycia:

My greatest challenges stemmed from the format in which we left our data. Above we discuss reformatting the data early on would have helped in the app coding process.

Creating a reactive title that had both the year and the crime type proved more difficult than expected. If I put both the reactive year and crime type on the same line, it would reprint the year every time a crime was added, making it repetitive and hard to read. I solved this by making the title non-reactive, but having two lines of reactive text below that show the user what their selections are, line 1 being the year and line 2 being the crime(s) selected.

My second challenge was being able to offer the users "Average over time" and "All cities" as options to select from in the sidebar panel. The bulk of the coding that I did was manipulating the dataframe if the users selected those, so that the table and plot wouldn't break, but would instead produce the averages.
