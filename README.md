# inSociety Messenger

## General info
The project has been created to demonstrate programming skills. It widely uses networking, user authorization with the choice of a suitable service (such as Google account or email). Messenger has 10 screens, and lots of custom views. Absolutely all view elements are built only with code and the UIKit library.

## Networking
The project does not store any information. I used the Firebase backend service for these tasks so that all users have real time access to current data. FirebaseAuth used to authorize users, FirebaseFirestore to store data, and FirebaseStorage to store images (user avatars). For each of them I created a singleton class that performs the corresponding tasks.

## Code realization
Every time application launches, the AppDelegate class checks the current user ID. If the ID is not found, then the user is not registered on the server, so it is opening the registration screen. If the ID is received, application sends a request to the server and it checks whether the user has passed the full registration with filling in the personal profile data. If the user has not completed registration, screen SetupProfile will open, and if all the user data is already on the server, he immediately gets to the main screen with chats and a list of people nearby. At any time, the user can send a chat request to communicate with a new person and the person will immediately receive it. If the person confirms the request, they have a common chat. If a person rejects the chat request, the user will simply disappear from the list of his waiting chats

## Chat realization
The third-party library MessageKit was used for the dialog box. It provides a convenient functionality with placing messages on screen and real-time updates. It is enough to create a class that inherits from the MessagesViewController class. After that, it is needed to implement the design and functionality in delegate methods that accept user messages that are also on the server.

## Views
As said, all view elements were executed programmatically. The project does not have a main.storyboard file, and the elements are laid out using NSLayoutConstraints. The application has a screen with two collection views at once, scrolling in different directions and taking different cells. It was implemented using the UICollectionViewCompositionalLayout and DiffableDataSource classes introduced by Apple in 2019. These are new classes that help build collections of any kind with much more functionality.
