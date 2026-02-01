# Weather App - Module 01

A Flutter weather application built with a modern UI featuring a top navigation bar and tabbed bottom navigation.

## Overview

This project implements the foundational components of a weather application:
- **Top Navigation Bar** with search and geolocation features
- **Bottom Tab Navigation** with three main views
- **Interactive UI** supporting both click and swipe navigation

## Project Structure

### Top Bar Features
- **Search TextField**: Enter location names to search for weather data
- **Geolocation Button**: Automatically detect current location

The top bar functionality displays selected data across all tabs:
- Entering text in search shows the tab name + search input in all tabs
- Clicking geolocation button shows the tab name + "Geolocation" in all tabs

### Bottom Tab Navigation
The application includes three tabs with names and icons:

| Tab | Name | Functionality |
|-----|------|---------------|
| 1 | Currently | Displays current weather |
| 2 | Today | Displays today's weather |
| 3 | Weekly | Displays weekly forecast |

**Interaction Methods:**
- Click on tab to switch
- Swipe left/right to navigate between tabs
- Currently tab is selected by default on app startup
- Content changes dynamically when switching tabs

## Setup & Running

This project uses **Flutter Web in Docker** for a consistent development environment without local SDK installation.

### Prerequisites

- Docker installed and running
- Port 8080 available

### Quick Start

1. Navigate to the project:
   ```powershell
   cd ./weather_app
   ```

2. Start the development environment:
   ```powershell
   ./script.sh
   ```

3. Open [http://localhost:8080](http://localhost:8080) in your browser

4. Test button functionality and debug output

### Troubleshooting

If port 8080 is already in use:

```powershell
docker stop <container-id>
```

To check active containers:

```powershell
docker container ls
```

## Development

The project structure includes:
- `lib/main.dart` - Application entry point
- `lib/widgets/screen_body.dart` - Main screen component
- `lib/constants/text_constants.dart` - Text constants

All widget interactions and state changes are handled through Flutter's reactive framework.
