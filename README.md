# Flutter Notification App

## Overview

This Flutter app is designed to send notifications at user-defined intervals. It integrates Firebase for authentication and utilizes various Flutter packages to manage notifications and user interactions.

### Primary Functionalities
- **Notification Scheduling**: Users can set intervals for sending notifications.
- **User Authentication**: Basic email and password authentication.

### Additional Features
- Integration with Firebase for user management and notification handling.

## Firebase Setup

### Services and Configurations
- **Packages Used**:
  - `flutter_local_notifications: ^17.2.2`
  - `firebase_messaging: ^15.1.1`
  - `firebase_auth: ^5.2.1`
- **Custom Firebase Functions**:
  - Retrieving user email for personalized notifications.

## Dependencies

### Required Packages
- `cupertino_icons: ^1.0.8`
- `firebase_core: ^3.4.1`
- `cloud_firestore: ^5.4.1`
- `firebase_messaging: ^15.1.1`
- `firebase_auth: ^5.2.1`
- `shared_preferences: ^2.3.2`
- `google_sign_in: ^6.1.0`
- `flutter_local_notifications: ^17.2.2`


## Environment Configuration

- **Configuration Files**: Ensure jdk bin and flutter bin are in Environment variables to make firebase work

## User Authentication

- **Supported Methods**: Email and password authentication.

## UI/UX Details

- **Design Choices**:
  - Custom styles and animations to enhance user experience.
- **User Interactions**:
  - Users can select notification types and intervals, which are then used to trigger notifications.


## Notification Handling

- **Management**: Notifications are managed based on user input for time intervals.


## Architecture and Design Choices

### **Model-View-Controller (MVC) Architecture**

- **Model**: Represents the data and business logic of the app.
- **View**: The UI components that display data to the user. 
- **Controller**: Manages user inputs and updates the model. 

###  **Error Handling**

- **User Feedback**: Error messages and snack bars are used to provide feedback on actions like registration, login, and notification settings.
- **State Management**: Used to manage and display error messages dynamically.

### **Performance Optimization**

- **Efficient Data Handling**: Used lists and maps to manage and retrieve notifications efficiently.
- **Avoid Redundant Updates**: Cancelled existing timers before starting new ones to avoid redundant notification dispatches.

