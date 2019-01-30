# Milestone 4

Contributors: Alycia Butterworth ([alyciakb](https://github.com/alyciakb)), George J. J. Wu ([GeorgeJJW](https://github.com/GeorgeJJW))

## Changes made

- Remove header.
- Adjusted layout to be more compact.


## If we were to start over...

Throughout this program, we've been told that data cleaning forms about 80% of a data scientist's job. If we were to go back and start again, we would devote more time to the data cleaning portion, as we followed a more minimalistic approach to our data cleaning. 

We left our data in a wide dataframe with our crime rates each being in their own column. Starting over, we could combine all four crimes into two columns: the values in one column being the name of the crime, ex. "homicide", and the other column having the per capita rate of that crime. This would cause our dataframe to be significantly longer, but it would make the downstream reactive process much easier. It would be especially prevelant in the coding for displaying information for multiple crimes over multiple years. Further, had we created a more workable dataframe to begin with, we think it would've been easier to add more options for the users.

Unfortunately, by the time we realized that our data would be easier to work with in a different format, we had made too much progress on our app and we would've had to rewrite most of the app in order to rectify the situation. Due to time constraints, this was not an option. If we were to start again, we would spend more time early on looking at the data and reformatting it to be more usable for our purpose.


## Greatest challenges

Alycia:

My greatest challenges stemmed from the format in which we left our data. Above we discuss reformatting the data early on would have helped in the app coding process.

Creating a reactive title that had both the year and the crime type proved more difficult than expected. If I put both the reactive year and crime type on the same line, it would reprint the year every time a crime was added, making it repetitve and hard to read. I solved this by making the title non-reactive, but having two lines of reactive text below that show the user what their selections are, line 1 being the year and line 2 being the crime(s) selected.

My second challenge was being able to offer the users "Average over time" and "All cities" as options to select from in the sidebar panel. The bulk of the coding that I did was manipulating the dataframe if the users selected those, so that the table and plot wouldn't break, but would instead produce the averages.


