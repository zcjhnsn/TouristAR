# Welcome to TouristAR

TouristAR is an Augmented Reality app for iOS. Using the user's current location, it queries Wikipedia for articles that have a coordinate location within 10000 meters of the user. These articles are then plotted in 3D space around the user with closer locations having larger labels. Since labels can be placed up to 5 miles away, there is an ability to see these locations in a list sorted by distance from the user. When the user taps on a location, a detail view will appear showing a map of the location, an image provided by Wikipedia (if there is one), and two options. The user can learn more about the location by tapping the Learn More button and the Wikipedia page will be opened in their default browser. The user can also tap of the Apple Maps button to get directions to the location via Apple Maps.

This app was tested on an iPhone 12 Pro running iOS 14 and an iPhone XR running iOS 13 and the iOS 14 beta.

The most difficult part about this project was getting the labels to line up in the correct place relative to the user. There was a bit of math and testing involved but I got it as close as I could. Apple's ARKit framework made working in AR so much easier than I thought it would be.

A demo video can be found here: https://drive.google.com/file/d/1QTzN3lwXhK-iSh2ynU1MiA8F4v4kWtrU/view?usp=sharing 

