import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:advanced_weather_app/constants/text_constants.dart';
import 'package:advanced_weather_app/models/location.dart';
import 'package:advanced_weather_app/models/weather_data.dart';

class WeatherApiService {
  static Future<List<Location>> fetchLocations(String query) async {
    final String uri =
        TextConstants.citiesUri.replaceFirst('<substring>', query);

    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'] ?? [];
      return results.map((json) => Location.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load locations');
    }
  }

  static Future<CurrentWeatherData> fetchCurrentWeather(
    double latitude,
    double longitude,
  ) async {
    final String uri = TextConstants.currentWeatherUri
        .replaceFirst('<latitude>', latitude.toString())
        .replaceFirst('<longitude>', longitude.toString());

    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final currentWeather = data['current'];
      return CurrentWeatherData(
        type: WeatherType.tab1,
        currentTemperature: currentWeather['temperature_2m'],
        currentWeatherCodeDescription: currentWeather['weather_code'],
        currentWindSpeed: currentWeather['wind_speed_10m'],
      );
    } else {
      throw Exception('Failed to load current weather');
    }
  }

  static Future<HourlyWeatherData> fetchTodayWeather(
    double latitude,
    double longitude,
  ) async {
    final String uri = TextConstants.todayWeatherUri
        .replaceFirst('<latitude>', latitude.toString())
        .replaceFirst('<longitude>', longitude.toString());

    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final hourly = data['hourly'];
      return HourlyWeatherData(
        type: WeatherType.tab2,
        hourlyTime: List<DateTime>.from(
          hourly['time'].map((time) => DateTime.parse(time)),
        ),
        hourlyTemperature: List<double>.from(hourly['temperature_2m']),
        hourlyWeatherCodeDescription:
            List<int>.from(hourly['weather_code']),
        hourlyWindSpeed: List<double>.from(hourly['wind_speed_10m']),
      );
    } else {
      throw Exception('Failed to load today\'s weather');
    }
  }

  static Future<WeeklyWeatherData> fetchWeeklyWeather(
    double latitude,
    double longitude,
  ) async {
    final String uri = TextConstants.weeklyWeatherUri
        .replaceFirst('<latitude>', latitude.toString())
        .replaceFirst('<longitude>', longitude.toString());

    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final daily = data['daily'];
      return WeeklyWeatherData(
        type: WeatherType.tab3,
        dailyTime: List<DateTime>.from(
          daily['time'].map((time) => DateTime.parse(time)),
        ),
        dailyTemperatureMax: List<double>.from(daily['temperature_2m_max']),
        dailyTemperatureMin: List<double>.from(daily['temperature_2m_min']),
        dailyWeatherCodeDescription: List<int>.from(daily['weather_code']),
      );
    } else {
      throw Exception('Failed to load weekly weather');
    }
  }

  Future<WeatherData> fetchWeatherData(
    WeatherType type,
    Location location,
  ) async {
    try {
      switch (type) {
        case WeatherType.tab1:
          return await fetchCurrentWeather(
            location.latitude,
            location.longitude,
          );
        case WeatherType.tab2:
          return await fetchTodayWeather(
            location.latitude,
            location.longitude,
          );
        case WeatherType.tab3:
          return await fetchWeeklyWeather(
            location.latitude,
            location.longitude,
          );
      }
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }
}
