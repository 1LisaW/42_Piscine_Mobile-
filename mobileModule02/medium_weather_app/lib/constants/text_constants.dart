class TextConstants {
  static const String titleTab_1 = "Currently";
  static const String titleTab_2 = "Today";
  static const String titleTab_3 = "Weekly";

  static const String citiesUri = "https://geocoding-api.open-meteo.com/v1/search?name=<substring>&count=5&language=en&format=json";
  static const String currentWeatherUri = "https://api.open-meteo.com/v1/forecast?latitude=<latitude>&longitude=<longitude>&current=temperature_2m,weather_code,wind_speed_10m&timezone=auto";
  static const String todayWeatherUri = "https://api.open-meteo.com/v1/forecast?latitude=<latitude>&longitude=<longitude>&forecast_days=1&hourly=temperature_2m,wind_speed_10m,weather_code&timezone=auto";
  static const String weeklyWeatherUri = "https://api.open-meteo.com/v1/forecast?latitude=<latitude>&longitude=<longitude>&timezone=auto&daily=weather_code,temperature_2m_max,temperature_2m_min";

  static const String errorConnectionLost = 'The service connection is lost, please check your internet connection and try again later.';
  static const String errorNoResults = 'Could not find any result for the supplied address or coordinates.';
  static const String errorGeolocationUnavailable = 'Geolocation is not available, please enable it in your App settings.';
}
