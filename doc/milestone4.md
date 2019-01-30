# Milestone 4

Contributors: Alycia Butterworth ([alyciakb](https://github.com/alyciakb)), George J. J. Wu ([GeorgeJJW](https://github.com/GeorgeJJW))

Given the time limit of this week's milestone, we believe we can further improve our application by implementing the following changes.

#### Changes 1: Interactivity between components

To explore how the crime rates of a city has changed over time, users can now select a city directly from the map panel.

Users can also select a city directly from the rank table panel.

By connecting different components of our application together, we aim to enhance one of the core functionalities of this project - we want to empower users to compare the crime rates of different cities at a particular point in time, as well as to explore how the crime rates of a city has changed over time. By linking the map panel and the rank table panel to the time series chart, we hope we have fundamentally improved the usability of our application.

#### Changes 2: Removed Honolulu

The city Honolulu is not visible within the zoom and pan bounds of the map panel. The data points for this city has been excluded from this project. We want data points across app components to be as consistent as possible.

#### Change 3: Removed header

We removed the header component of our application, as we found it to be redundant in relation to the interactive titles above the map panel. We want to keep the user interface of our app as compact and minimal as possible.

#### Changes 4: Refactored data wrangling pipeline

Previously the data wrangling logic of this project was embedded in a poorly organized [RMarkdown document](https://github.com/UBC-MDS/violent_crimes_usa/blob/master/src/eda.Rmd). We want to make this data project more maintainable as well as more reproducible. For these reasons, we have refactored our data wrangling pipeline into a standalone R script document called [prepare_data.R](https://github.com/UBC-MDS/violent_crimes_usa/blob/master/src/prepare_data.R).

## If we can start over




## Greatest challenges

#### George:

I found it surprisingly challenging to visualize less frequent crime types in conjunction with more frequent crime types. On the map panel, for instance, the less frequent crime types such as rape and homicide incidents tend to get "drowned out" by the more frequent crimes types such as robbery and aggravated assault. I wish I could implement a solution to dynamically re-discretize crime rates to different colours, normalized to the max value of crime rates that is being plotted.

I also found the data wrangling process to be surprisingly labourious. I had to revisit our data wrangling logic a number of times throughout the project to re-evaluate the integrity and validity of our data. I found that many bugs and other issues in the application were often introduced by my failure to wrangle the data properly.  
