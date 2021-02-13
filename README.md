# Event-search-App

## Brief Outline

I opted to use MVVM architecture along with Inputs and Outputs protocols that enables easier unit test. Inputs/Outputs protocols are also beneficial as they force other authors to reach the viewModel through the Inputs and Outputs each time and that will realize consistent style across the entire code. 
In this app, SearchViewController sends all the UI events via Inputs to SearchViewModel, and SearchViewModel perform logics within the viewModel, then return actions via Outputs.  SearchViewController to update its UI depending on the received actions. 
I also believe that using Inputs/Outputs provide high testability as all the expected behavior can be mocked by calling viewModel’s Inputs methods and I can verify if it is functioning properly by checking Outputs. 

## Achieved Requirements

- [x] Favorited events are persisted between app launches
- It is achived by using UserDefaults. 
- [x] Events are searchable through SeatGeek API
- It is able to search events using “q” argument. 
- [x] Unit tests are preferable.
- Partially done. I could only implement unit test for viewModel within given time. 
- [x] Third party libraries are allowed.
- The app uses KingFisher for image download and cacheing. 
- [x] Cocoapods, Carthage, Swift Package Manager are all allowed as long as there is a clear instructions on how to build and run the application.  
- [x] Make sure that the application supports iOS 12 and above.
- the app supports iOS 12 and above. 
- [x] The application must compile with Xcode 12.x.x
- the app compile with Xcode 12. 
- [x] Please add a README or equivalent documentation about your project.
- As well as README, I have added some comments in the code. 
- [x] The screenshots are just blueprints. UI doesn’t have to follow them.
- Some discrepancies are explained in the below. 
- [x] Please submit your application even if it’s partially done! 

## Discrepancies on UI design between given screenshot and actual app

### NavigationBar’s color
I did not change the color of navigationBar as I could not find the same color of the screenshot.

### Dimmed tableView during typing
I did not implement dimmed tableView while user is typing in the searchBar as I did not feel it is necessary. In this app, the content of text in the searchBar and shown result in the table are always match. If the results shows up when user tap enter, I should have implemented dimmed tableView during the searchBar’s presentation. 

### Title appears within navigationBar in EventViewController
In the screenshot, there is a title appears within the navigationBar in the EventViewController where just one event shows up after cell is tapped. I could not find most appropriate way to implement this design within the given time. I once tried to make the navigationBar transparent and put the title behind the navigationBar. However, since I cannot take the anchors of the navigationBarButtons, I could not appropriately place the titles leading anchor and trailing anchor.


## What feature I would add if I were given more time

### FavoritesViewController 
I would add another viewController that user can brows events that he/she added in favorites. I would need to implement UITabBarController to realize this feature. 

### Recommendation 
It would be a good idea to show recommended events when there is no texts entered in the searchBar. 

### Show Location
It would add a button with text of venue’s address and when it is tapped, the app opens MKMapView and let user know the location visually. 


