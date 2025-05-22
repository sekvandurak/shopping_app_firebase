# Shopping List App

A Flutter application for managing your grocery shopping list. This app allows you to add, view, and track grocery items with different categories.

## Features

- Add new grocery items with quantity and category
- View your shopping list with item details
- Clean and intuitive user interface
- Firebase Realtime Database integration for data persistence

## Screenshots

[Add screenshots of your app here]

## Installation

1. Clone this repository
   ```
   git clone https://github.com/YOUR_USERNAME/shopping_list.git
   cd shopping_list
   ```

2. Install dependencies
   ```
   flutter pub get
   ```

3. Set up Firebase configuration (see below)

4. Run the app
   ```
   flutter run
   ```

## Firebase Configuration Setup

This app uses Firebase Realtime Database for data storage. To protect sensitive Firebase URLs from being exposed in the public repository, the configuration is kept in a separate file that is not tracked by git.

### Setup Instructions

1. Copy the template configuration file to create your own config file:
   ```
   cp lib/config/env_config.template.dart lib/config/env_config.dart
   ```

2. Edit `lib/config/env_config.dart` and replace the placeholder with your Firebase URL:
   ```dart
   class EnvConfig {
     static const String firebaseUrl = 'YOUR_FIREBASE_URL_HERE';
   }
   ```

3. The actual configuration file (`env_config.dart`) is already added to `.gitignore` to prevent it from being committed to the repository.

## Project Structure

- `lib/models/` - Data models for the app
- `lib/widgets/` - UI components
- `lib/data/` - Data and category definitions
- `lib/config/` - Configuration files

## Dependencies

- Flutter
- http - For making API requests to Firebase


## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

@Sekvan Durak

