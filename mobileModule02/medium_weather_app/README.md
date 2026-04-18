# Medium Weather App

A Flutter weather application that integrates GPS geolocation with real-time weather data and API integration.

**Module 02** of the Piscine Mobile - Building upon Module 01 with advanced geolocation, weather API integration, and data management.


## Overview

This project extends the basic weather app from Module 01 by adding GPS geolocation and real weather data integration. The app fetches weather information based on the device's location or user input.

## Requirements

### Exercise 00: Geolocation

Implement geolocation functionality to determine the device's location:

- **Trigger**: manual via geolocation button
- **GPS Access**: Use device GPS to retrieve coordinates
- **Permission Handling**:
  - **✓ Granted**: Retrieve coordinates and fetch weather data (display coordinates as text)
  - **✗ Denied**: App remains functional; user can search by city name with notification, but they would be informed that they don’t have access to their location.

### Exercise 01: Location Search

Implement a city search feature with autocomplete suggestions:

- **Search Input**: Allow users to search by city name, country, or region
- **Suggestions**: Display suggestion list as user types (the city name, the city's region, the country of the city)
- **Selection**: Select a location from suggestions to fetch weather data
- **API Integration**: Use geocoding API to retrieve available locations

### Exercise 02: Weather Display Tabs

Implement three tabs to display weather information with detailed data views:

#### Tab 1: Current Weather
Display real-time weather information:
- Location (city name, region, country)
- Current temperature (Celsius)
- Weather description (e.g., cloudy, sunny, rainy)
- Wind speed (km/h)

#### Tab 2: Hourly Forecast (Today)
Display hourly weather breakdown for the current day:
- Location (city name, region, country)
- Hourly weather list showing:
  - Time of day
  - Temperature at each hour
  - Weather description
  - Wind speed (km/h)

#### Tab 3: Weekly Forecast
Display daily weather summary for the week:
- Location (city name, region, country)
- Daily weather list showing:
  - Date
  - Min/Max temperatures
  - Weather description

#### Behavior Requirements
- App starts on the "Current" tab
- Search results maintain active tab (stay on selected tab during search)
- Tab switching displays data from the last selected location

### Exercise 03: Error Handling

Implement comprehensive error handling for edge cases:

#### Error Scenarios
- **Invalid City Name**: User enters a non-existent city
- **Connection Failure**: API request fails or network is unavailable

#### Requirements
- Display clear error messages to the user
- Messages persist until user action (valid input or restored connection)
- Ensure robust error recovery mechanisms


### Core Features

- **GPS Geolocation**: Retrieve device coordinates using device GPS
- **Weather API Integration**: Fetch real-time weather data
- **Geocoding**: Convert coordinates to city names
- **Location Permissions**: Handle user permission requests gracefully
- **Fallback Search**: Allow manual city search when location access is denied

## Architecture

This Flutter project follows a modular architecture with clear separation of concerns:

- **Services Layer**: Contains business logic for location services, geocoding, and weather API integration
- **Models Layer**: Defines data structures for locations and weather information
- **Widgets Layer**: Implements the UI components with proper state management
- **Constants**: Centralized text constants for the application

### Tech Stack

- **Framework**: Flutter with Material Design 3
- **Geolocation**: `geolocator` package for GPS access and permissions
- **HTTP Requests**: `http` package for API calls
- **Theme Support**: Light and dark mode with Material Design 3

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
├── main.dart                      # App entry point and main UI logic
├── constants/
│   └── text_constants.dart        # UI text constants
├── models/
│   ├── location.dart              # Location data model
│   └── weather_data.dart          # Weather information model
├── services/
│   ├── location_service.dart      # GPS permission and location retrieval
│   ├── get_location_info.dart     # Geocoding API integration
│   └── weather_api_service.dart   # Weather API integration
└── widgets/
    ├── screen_body.dart           # Main UI layout and weather display
    ├── location_list.dart         # Location search results display
    ├── location_search_field.dart # Search input widget
    └── weather_block.dart         # Individual weather information widget
```

## Implementation Notes

- **Location Service**: Handles GPS permission requests and coordinates retrieval using the `geolocator` package
- **Geocoding API**: Converts coordinates to location names via the geocoding service
- **Weather API**: Fetches real-time weather data based on location
- **Material Design 3**: Implements modern Flutter UI with support for light and dark themes
- **Error Handling**: Gracefully handles permission denials, service unavailability, and API errors
- **Responsive UI**: Uses TabBar for navigating between current location and search results
- **Location Models**: Maintains location state with actual vs. searched location distinction


