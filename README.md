# Traveler

Traveler is your companion app for traveling. Whether it's within your hometown, or traveling to the other side of the world, Traveler allows you to save every place you would like to visit, and reminds you when you are nearby it! Simply save a place that you've been wanting to visit, and the next time you are in the area, Traveler will give you a notification to remind you to check it out!

## Table of Contents

- [How to Use](#how-to-use)
- [Design Journey](#design-journey)
- [Future Features](#future-features)
- [Installation](#installation)
- [Third Party APIs](#third-party-apis)
- [Packages](#packages)
- [Support](#support)
- [Appendix](#appendix)


## How to Use

To the people who love to wander cities, but can't be bothered to be staring at Google Maps the entire time, this app is for you. I've built this app to be as simple to use as possible: simply click the ![add_place icon]() to add a new place, type in the location you would like to save, and it should appear in the drop down menu. After selecting it, you can provide a little description so you don't forget why you wanted to visit. Next time you are in the area of your saved location, you will get a quick notification reminding you to visit your saved place!

## Design Journey

*Add UI drawings*
*Add Figma images*

## Future Features

- Complete the Feed page
- Link friends to the main user
- Create a profile page
- Clicking a saved place in `My Places` opens a page that provides users with more information about their saved spot, as well as allows them to edit the place.
- Populate the Map page with User's saved locations.
- Populate the Map page with User's friend's saved locations (different color)
- Add a Filter function to the maps page to see only certain friends.
- Add a username/first and last name to the user's database.
- Figure out map cacheing to improve app load times.
- Link feed page cards with the additional information about the specific location's details.
- Link notification pop-up to a page about the unique place, and add a Google Maps/Apple Maps link.
- Add search feature to friends page to find friends.
- Add images to the app
- Manually drop a marker when saving a new location, either in the main mapp, or on the add places map.

## Setup and Installation

### Creating the Supabase Database

For this project I used Supabase to take care of my user authentication and backend. While there are other apps that also provide this functionality such as Firebase, I found Supabase to provide everything I needed, while also being open-source, and was free for the extents of this project. Supabase also provides an AI helper for creating endpoints. It works well enough, but after the initial edge function is created, I found it easier to go in and manually adjust the functions when changing the tables.

1. Create a [Supabase Account]()
2. Setup the [User Authetication]() through Supabase
3. Create 3 tables. 

    *Note: The User Auth table provides the user_id foreign key*

    #### Locations
    | place_id | user_id | gmaps_id | latLng | title | info |
    |----------|---------|----------|--------|-------|------|
    | primary-key | foreign-key | String from GMaps | [##.##, ##.##] | "Place Name" | "Some Discriptor" |

    #### Users_to_Locations (INSERT NAME FOR LINKING TABLE)
    | uuid | user_id | place_id |
    |------|---------|----------|
    | primary-key | foreign-key | foreign-key |

    #### Users_to_Friends (INSERT NAME FOR LINKING TABLE)
    | uuid | user_id | friend_id |
    |------|---------|-----------|
    | primary-key | foreign-key | foreign-key |

4. Setup the Edge functions

    #### /add_location

    ```
    < Add Code for this endpoint here >
    ```

    #### /get_locations

    ```
    < Add Code for this endpoint here >
    ```

    #### /get-saved-places

    ```
    < Add Code for this endpoint here >
    ```

### Initializing the Application

1. Clone repo locally: [/** Add Github link here **/]
2. Create a `.env` file in the project directory
    ```
    MAPS_API_KEY=<Pull this from your Google Maps API>
    SUPABASE_URL=<Pull this from Supabase>
    SUPABASE_KEY=<Pull this from Supabase>
    ```
3. Verify `Flutter` and `Dart` versions
    | `Flutter` | `Dart` |
    |-----------|--------|
    | `3.29.2`  | `3.7.2`|
4. Run `flutter pub get`. This will pull all the packages required for the project.
5. Run `flutter build apk`

## Third Party APIs

The three third party APIs that were used heavily for this project were Google Maps, Google Places, and Supabase.
Google Maps and Google Places are used for all the map pages. Using this is how the distance between the user and the location is determined. Supabase takes care of all backend parts, from User Auth to database tables, and API functions.

## Packages

- [flutter_launch_icons]()
- [flutter_native_splash]()
- [go_router]()
- [google_maps_flutter]()
- [http]()
- [json_annotation]()
- [json_serializable]()
- [flutter_secure_storage]()
- [google_places_flutter]()
- [geocoding]()
- [geolocator]()
- [flutter_dotenv]()
- [supabase_flutter]()
- [background_fetch]()
- [flutter_local_notifications]()

## Support

## Appendix

## Use this README File 

Use this section to show us what your Mobile App is about.   Include a Screenshot to the App, link to the various frameworks you've used. Include your presentation video here that shows off your Mobile App.   Emojis are also fun to include 📱 😄

Look at some other Flutter Apps online and see how they use there README File.  Good examples are:

- https://github.com/miickel/flutter_particle_clock
- https://github.com/Tarikul711/flutter-food-delivery-app-ui    
- https://github.com/mohak1283/Instagram-Clone


## Include A Section That Tells Developers How To Install The App

Include a section that gives intructions on how to install the app or run it in Flutter.  What versions of the plugins are you assuming?  Maybe define a licence

##  Contact Details

Having Contact Details is also good as it shows people how to get in contact with you if they'd like to contribute to the app. 


## Commands

Clean the Build
```
flutter clean
```


Grab all Dependencies
```
flutter pub get
```


Build the Icon and Splash Screen
```
dart run flutter_launcher_icons
```

Note: For android the same image is used for the splash and the app icon.
TODO: Figure out how to adjust the 'branding' to have the app name in the splash page.

Build the APK
```
flutter build apk
```

