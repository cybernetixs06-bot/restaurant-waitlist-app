# Restaurant Waitlist App 

## how to run the project 

Clone repository.

Run flutter pub get.

Start an Android emulator.

Run flutter run



## Why I chose the technology and the data storage, in two sentences
Flutter was chosen because it provides a simple cross-platform solution and is suitable for building a small mobile application quickly. SharedPreferences was chosen because the app only needs to persist a small waitlist and the last ticket number locally, without requiring a full database.


## What is complete and what is not

Complete
Add party.

Validate name.

Validate party size.

Generate unique ticket numbers.

Display waitlist in joining order.

Display parties ahead.

Remove any party.

Persist waitlist.

Persist ticket numbering across app restarts.

Edit party.

Undo removal.

History.


## Not complete



Estimated waiting time. 
bcz there is no cretiria for estimation  the time in task 



## AI Suggestion Check
I checked the AI suggestions by testing edge cases, including adding a party with an empty name, adding a party with an invalid size, removing a party and adding a new one to verify that ticket numbers are never reused, and closing and reopening the app to verify that the data persists.

