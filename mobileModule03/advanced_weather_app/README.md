# Advanced Weather App

A Flutter weather client that shows **current conditions**, **hourly forecasts for today**, and **weekly outlooks** for any searchable place or your device location. Data comes from the public [Open-Meteo](https://open-meteo.com/) APIs (no API key). City search uses Open-Meteo’s geocoding endpoint; GPS positions are resolved to a place name via [Nominatim](https://nominatim.openstreetmap.org/) (OpenStreetMap).

## Features

- **Three tabs**: Currently · Today · Weekly — each backed by the matching Open-Meteo forecast endpoint.
- **Search**: Type a city or place (after a few characters, suggestions appear); pick one or submit the field to load that location.
- **Current location**: Uses device GPS (`geolocator`); ensure location services and app permissions are granted.
- **Charts**: Hourly and daily temperature (and related) views use `fl_chart`; dates and numbers use `intl`.
- **UI**: Full-screen background image with gradient overlay, frosted panels, portrait-only orientation.

## Tech stack

| Area        | Packages / APIs |
| ----------- | ---------------- |
| Weather     | `api.open-meteo.com` (current, hourly, daily) |
| Place search | `geocoding-api.open-meteo.com` |
| Reverse geocode (GPS) | Nominatim (`nominatim.openstreetmap.org`) |
| Location    | `geolocator` |
| HTTP        | `http` |

## Requirements

- [Flutter](https://docs.flutter.dev/get-started/install) SDK (see `environment.sdk` in `pubspec.yaml`).
- Network access for API calls.
- For “use my location”: platform location permissions configured (see [geolocator](https://pub.dev/packages/geolocator) setup for Android / iOS).

## Run the app

```bash
cd advanced_weather_app
flutter pub get
flutter run
```

## Project layout (lib)

- `main.dart` — app shell, search, tabs, and location handling.
- `services/` — `WeatherApiService`, `LocationService`, `get_location_info` (Nominatim).
- `models/` — `Location`, `WeatherData` variants.
- `widgets/` — `ScreenBody`, `WeatherBlock`, `WeatherCharts`, `LocationList`, etc.

## Assets

Background image: `assets/images/weather_background.png` (referenced in `pubspec.yaml`). If the asset is missing, the app falls back to a blue gradient.

---

For general Flutter help, see the [Flutter documentation](https://docs.flutter.dev/).
