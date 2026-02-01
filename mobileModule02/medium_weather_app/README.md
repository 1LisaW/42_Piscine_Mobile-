# Medium Weather App

A Flutter weather application that integrates real-time location data with weather information.

## Overview

This project extends the basic weather app from Module 01 by adding GPS geolocation and real weather data integration. The app fetches weather information based on the device's location or user input.

## Requirements

### Core Features

- **GPS Geolocation**: Retrieve device coordinates using device GPS
- **Weather API Integration**: Fetch real-time weather data
- **Geocoding**: Convert coordinates to city names
- **Location Permissions**: Handle user permission requests gracefully
- **Fallback Search**: Allow manual city search when location access is denied

### Permission Handling

The app must handle two distinct scenarios:

#### ✓ Permission Granted

When the user grants location access:
- Retrieve device coordinates via GPS
- Display coordinates on screen
- Fetch and display weather data for the location

#### ✗ Permission Denied

When the user denies location access:
- App remains fully functional
- User can search for weather by city name via search field
- Clear notification informing user about location access restrictions

## Architecture

This Flutter project follows a modular structure:

- `lib/main.dart` - Application entry point
- `lib/services/` - Business logic and API integrations
- `lib/widgets/` - UI components
- `lib/constants/` - Application constants and configurations

## Getting Started

### Prerequisites

- Flutter SDK installed
- Device with GPS capability or emulator with location services

### Installation

```bash
flutter pub get
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── constants/
│   └── text_constants.dart   # UI text constants
├── services/
│   └── location_service.dart # GPS and location logic
└── widgets/
    └── screen_body.dart      # Main UI widget
```

## Implementation Notes

- Location permission requests follow platform-specific guidelines (iOS/Android)
- Weather data is fetched only after coordinates are obtained
- The app gracefully handles permission denials with appropriate user feedback


