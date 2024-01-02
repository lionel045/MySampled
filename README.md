# 🎵 MySampled

Welcome to **MySampled**, an innovative application for music sample recognition. Integrating **Shazam's API** with a sample recognition API, MySampled positions itself as an essential tool for music enthusiasts, DJs, and ## 🌟 Sample Recognition Features
Uncover the hidden samples in your favorite tracks using state-of-the-art technology.
- **Shazam Integration**: Quickly identify the music playing around you with Shazam's API.
- **UIKit User Interface**: Effortlessly navigate using an intuitive and responsive user interface.

![Screen1](https://github.com/lionel045/MySampled/assets/64079278/1cc7048b-f650-42eb-a953-452fa989e080)
![Screen2](https://github.com/lionel045/MySampled/assets/64079278/9341689e-371f-4737-8889-58efb20a1237)
![Screen3](https://github.com/lionel045/MySampled/assets/64079278/4d9f5284-8659-4b33-8db6-5e7f65eedc32)

## 🛠 Prerequisites

- Have a Mac
- Have Xcode: Our chosen development environment for compiling and running the application.
- API Key via RapidAPI: You need to generate an API key for Shazam by visiting Shazam API on RapidAPI.

🔑 **API Key Configuration for integrating Shazam's API in MySampled**:
  - Obtain the API Key: Go to [RapidAPI](https://rapidapi.com/diyorbekkanal/api/shazam-api6/pricing) and generate your Shazam API key.
  - Create the `ApiKey.plist` file: In Xcode, create an `ApiKey.plist` file within your project.
  - Add the API Key in `ApiKey.plist`: Open the `ApiKey.plist` file. Create a new dictionary with the key `X-RapidAPI-Key`. Insert the API key you obtained from RapidAPI as the value for this key.

## 📲 Installation

1. Clone the repository:
```bash
   git clone https://github.com/lionel045/MySampled
```
2. Open the project in Xcode: Launch Xcode and open the project folder.
3. Create an `ApiKey.plist` file: In the root section, add ***X-RapidAPI-Key*** in the row and insert the previously generated API key.
4. Run the application: Compile and launch the application on your iOS simulator or device.

# Roadmap

## 🚧 Current State of the Project
- MySampled is currently in active development. The core features are established, but we are focused on the continuous improvement of the application, especially in terms of user interface.

## Upcoming Steps
- **Front-End Improvement**: We are concentrating on enhancing the user interface to provide a more intuitive, responsive, and pleasant experience. This includes revising layouts, enriching user interactions, and optimizing visual performance.

- **Adding a Tab Bar**: To improve navigation within the application, we plan to integrate a tab bar. This will allow users to quickly access different features and sections of the app.

- **Data Persistence**: We aim to implement data persistence functionality. This will enable users to save and easily retrieve identified tracks and discovered samples.

[Shazam API Link](https://rapidapi.com/diyorbekkanal/api/shazam-api6/pricing)
No worries, the API usage is free.
