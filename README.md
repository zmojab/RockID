
# RockID

Rockid is a mobile application built using Flutter for both iOS and Android devices that allows users to identify and classify different types of rocks. Whether you're a geology enthusiast or just curious about the rocks you find, this app will help people identify rough stones as well as gemstones that have been treated and cut based on their appearance, texture, and other characteristics.

## Features

- **Login creditionals:** Firebase Authorization is used to register the user via email, and then they can log in to the app and navigate to the home page.
- **Rocks found:** Every time a user finds a rock and chooses to display it, it is stored in Firestore. This page displays the time, date, and location for each rock found.
- **Rock information:** This page allows the user to search for every rock in the application, and when they click on a specific rock, it displays general information about that rock.
- **Recently found rocks:** All the rocks found in the application will be shown on the recently found rocks page in chronological order as users scroll down.
- **Rock Classification:** The user is presented with an option to save their location. They can then choose to upload an image or take a photo using their phone's camera. The application will then attempt to identify that rock.
- **User profile:** Every user has a profile where they can edit their name, occupation, bio, profile picture, and phone number. They also have the option to choose if they want to keep some of these attributes private, so they will not be shown to other users.


## Installation

1. Install the Flutter SDK and emulator using the instuctions in the following [link](https://docs.flutter.dev/get-started/install)

2. Clone this repository to your local machine:
```bash
  git clone https://github.com/hishaam19/RockID.git
```
3. Change your working directory to the project folder:
```bash
  cd rockID
```

4. Get the required dependencies by running:
```bash
  flutter pub get
```

5. Run the app using:
```bash
  flutter run
```

## Technologies Used

- **Flutter:** A popular open-source UI software development toolkit by Google for building natively compiled applications for mobile, web, and desktop from a single codebase.

- **TensorFlow Lite:** An open-source deep learning framework for on-device inference used mostly for mobile applications.

- **Firebase:** Google's mobile platform that helps with authentication, database management, and cloud storage.

## Classification Models

- **Purpose:** The rock ID app uses three classification models: one for rough stones, another for polished stones, and a model for determining whether a stone is rough or polished, which picks which of these models will be used to classify the rock image taken by the user.

- **How to use:** To replace the current training models in the application, you just have to put the new tflite files in the assets folder of the Rockid Flutter application. Additionally, add a labels.txt file that contains the index followed by the name of the class on each line for every class in that model. Afterward, replace the models and labels file paths in the camera page with the new files.
- **Datasets:** here are some link to some datasets that can be trained and used for this application:

   - [Rough stones](https://kaggle.com/datasets/d819d192e0a2628c44f9b3d2a26ae6df4cc7ad4af4eadd5660e966753c29f55b)

  - [Polished Stones](https://kaggle.com/datasets/e9b1e3b4dc44665c3b482e956e8b345f8bfa2db7af6ce335bbf70b3a4dd53ee8)

  - [Rough or Polished Stones](https://kaggle.com/datasets/0a3a236f0bdc89dc55c2392678ac4bb134af45d6563be127c529ed4555e44fd0)


## Contributing

To contribute to the RockID application please use the following steps.

 
1. Create a branch from the main and name it "development."
2. Create a branch from "development" for the feature or bug fix.
3. Commit changes made and add a descriptive commit message.
4. Create a pull request to the "development" branch and explain the purpose of the changes.
5. When all changes and bug fixes have been completed, create a pull request from "development" to the main branch.


## Google sign in
1. Use the following commands to get the SHA-1 and SHA-256 fingerprints.
2. Windows:
     ```bash
     keytool -list -v \
     -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore
     ```
 3. Mac/Linux:
      ```bash
       keytool -list -v \
     -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore
      ```
4. Go to firebase.com and login into the RockID account and under autherization go to sign-in method and go to project settings and add both the SHA-1 and SH-256 fingerprints.

## Future improvements

- **Improving the training models:** Currently, both the rough and polished classification models have an accuracy of 80-82. This can possibly be improved by optimizing the dataset and trying different hyperparameters.
- **Adding more rocks:** Adding more rocks to the app will make the app more robust.
- iOS compatibility: Unfortunately, we ran out of time and could not get this app to run on iOS. We set up the emulator, but it would not build successfully.
- **Maps page:** Add more filters and attributes to the pins, such as username, rock information, etc.
- **Friend list:** When a user views another user's profile, they can have the option to send messages or send a friend request. If they accept it, all that user's friends will be viewable within the application.




## Authors

- [@wadea1984](https://github.com/wadea1984)
- [@jim-wallace](https://github.com/jim-wallace)
- [@UZIIMAN](https://github.com/UZIIMAN)
- [@hishaam19](https://github.com/hishaam19)



