# Milestone 3

Contributors: Alycia Butterworth ([alyciakb](https://github.com/alyciakb)), George J. J. Wu ([GeorgeJJW](https://github.com/GeorgeJJW))


## Reflection on our Feedback Session

The feedback session we had with two peer groups proved very useful. Our peers were able to use and navigate the app the way we hoped, with no apparent issues, and we were able to suggest ideas to improve the design. We were able to incorporate a number of feedback into our application within this week's timeframe.

**CHANGE 1:**

Feedback Received:

*“Graphs are on different scales, this is hard for comparison”*

*“Scaling of line charts to be on same axis scale, it looks like there's more homicides than robberies”*

*“Make 4 plots into one, then put the map and the plot side by side so you don't need to scroll”*

Changes Made:

We combined the four line plots into one time-series plot with four lines, one for each type of crime. We added a hover feature, so if the users hover over a point on any line it will tell them the year, crime, and number of crime incidents per capita.

**CHANGE 2:**

Feedback Received:

*“Like how you guys have description at the top of the selection panel, but maybe have it as a subtitle until the title. Some may mistake it for selection instructions.”*

Changes Made:

We removed the text from the top of the sidebar panel (“Compare Crime Rates (per 100k population) of Major US Cities”) and added it as a subtitle above the map/table tabs.

**CHANGE 3:**

Feedback Received:

*“If no type of the crime is selected, the map breaks...”*

Changes Made:

Added an error statement to each of the map, plot, and table section, so if the users unselect all crime types, the app should inform the users that they must select a crime in order to view the map and plot.

**CHANGE 4:**

Feedback Received:

*"Maybe use color scale to show magnitude in the map instead of of circle size"*

Changes Made:

We changed the map markers from using size and shape to encode information to simply using colours to encode information.

---------------------

Other feedback we received but didn’t implement due to time or technical difficulties included: 

1.	Changing the table to default order by the crime from highest rate to lowest rate, instead of ordering by alphabetical. We attempted to change this, but if a user deselected all crimes and then reselected a crime, the table would not render properly. However, users are still able to manually change the ordering by clicking on the column header that they would like the table ordered by.
2.	Using `pickerSelect` to have a select all/deselect all option for the crimes. Since there are only four crimes and because we do not want to make it easier for a user to deselect all crimes, we decided to leave the check boxes the way it is.
3.	Having the user click on a city on the map or in the rank table and have the line chart below auto-update to show that city. This is something that is on our wishlist that we would like to implement, but due to time constraints and the technicality of it, we did not implement it this week.

-----------------------

Being a fly-on-the-wall allowed us to see how users would naturally interact with our app and observe how they view what we’ve created. It’s very important to see how users interact with the app to be able to make it more intuitive and user-friendly. This exercise proved to be the most valuable segment in our feedback session. It allowed us to see and hear the confusion when reading the four line plots, which led to the biggest design change that we made in our app. 

The feedback session gave us input on what potential app users liked and didn’t like about our design choices, as well as showed us how users may “break” (cause an error) in the app. It allowed us to make changes that should lead to a better and more user-friendly app design.

## Reflection on our App Changes

The biggest change in our app from our original design is moving from four line charts to one. We found this significantly improves readability. We also chose to show crime rates on the map by coloured dots only, not by dot size. This helps keep the dots from overlapping. 

Our wishlist item is still to make the map and table interactive with the line chart, so if you click on a city on the map/table the line chart will automatically update to show you that city's crime rates over time.

Overall, I believe we were able to impleemnt many of the changes we wanted to between milestone 2 and milestone 3, along with others that were suggested by our peer feedback.
