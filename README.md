![Title](/documentation/readmeAssets/title.png)
#### Created by John Rocha and Cory Jbara

WhereYouAt is a social media app that allows college students to share with their friends what they are doing when they go out. Users can also view trends via tableview and map to get a general idea of how many people are at certain locations/events. With the help of Firebase, features include: Google authentication, friend requests, real-time event updates, and much more. The current version is built with the Notre Dame campus in mind. 

## Features:  
  
#### Google Authentication with Firebase
Upon start up, you must authenticate with some form of Google email address. This both secures your account within the application as well as allows the app to gather any basic info that can help build a profile, most importantly your Google profile picture.  

![auth1](/documentation/readmeAssets/auth1.png)
![auth2](/documentation/readmeAssets/auth2.png)


#### Main Interface
Once the user profile is all set, the main application interface is presented in the form of three tabs: *Feed*, *Trends*, and *Map*.  
- The *Feed* tab is where all of a users' friend activity will appear including where they are at, what time they logged their location, and their own little status about their outing.
- The *Trends* tab provides anonymous statistics as to the whereabouts of everyone creating statuses with the application, whether they are on a user's friend list or not. This allows users to see the popular locations on any given night.
- The *Map* tab provides a map-view of the above trends so that the user can see what locations are active nearby. By tapping on the various location icons, the user can see how many people are at a given place.   

All of the above status information is pulled from Firebase and only corresponds to statuses made in the last 24 hours. This way, any activity or trends are relatively recent and still relevant to the user

![main1](/documentation/readmeAssets/feed.png)
![main2](/documentation/readmeAssets/trends.png)
<p align="center">
  <img src="/documentation/readmeAssets/map.png">
</p>


#### Creating a Status
By selecting the compose icon in the top right of the main interface, a user can create a status. First, the user must choose a location and is presented with a list of all those already in the application's database. If none of these locations are suitable, the user can add a new location to the database by pressing the plus icon in the top right of this view. Adding a new location simply consists of specifying the name, address, and type of location. The user must enter the address and select the adjacent "Check" button at least once before saving to ensure that the map shows the location and icon they intend.

![loc1](/documentation/readmeAssets/chooselocation.png)
![loc2](/documentation/readmeAssets/addlocation.png)

Finally, once the user has specified the location they are at, they can create a corresponding status message to be seen by their friends. A limit of 50 characters ensures that it's short and sweet, just enough to let friends know what's going down. In this view, the user can even see how many people are at that location based on the trends in the database.

<p align="center">
  <img src="/documentation/readmeAssets/addstatus.png">
</p>

#### Slide-Out Menu
A slide-out menu is present on the left edge of the screen in all three tabs of the main application interface. This menu can be accessed either by pressing the menu icon in the top-left corner of any of the tabs, or through touch by sliding out from the left edge of the screen. This menu provides access to all of the other details of the application such as viewing your current friends, adding more friends, updating your profile information, and signing out of the app. This menu can be similarly hidden again by swiping from the right edge of the menu back to the left. 

<p align="center">
  <img src="/documentation/readmeAssets/slideout.png">
</p>

