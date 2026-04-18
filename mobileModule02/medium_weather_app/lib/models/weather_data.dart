import 'package:medium_weather_app/constants/text_constants.dart';

enum WeatherType {
  tab1,
  tab2,
  tab3,
}

extension WeatherTypeExtension on WeatherType {
  String get displayName {
    switch (this) {
      case WeatherType.tab1:
        return TextConstants.titleTab_1;
      case WeatherType.tab2:
        return TextConstants.titleTab_2;
      case WeatherType.tab3:
        return TextConstants.titleTab_3;
    }
  }
}

class CurrentWeatherData extends WeatherData {
  final double currentTemperature;
  final int currentWeatherCodeDescription;
  final double currentWindSpeed;

  CurrentWeatherData({
    required super.type,
    required this.currentTemperature,
    required this.currentWeatherCodeDescription,
    required this.currentWindSpeed,
  });
}

class HourlyWeatherData extends WeatherData {
  final List<DateTime> hourlyTime;
  final List<double> hourlyTemperature;
  final List<int> hourlyWeatherCodeDescription;
  final List<double> hourlyWindSpeed;

  HourlyWeatherData({
    required super.type,
    required this.hourlyTime,
    required this.hourlyTemperature,
    required this.hourlyWeatherCodeDescription,
    required this.hourlyWindSpeed,
  });
}

class WeeklyWeatherData extends WeatherData {
  final List<DateTime> dailyTime;
  final List<double> dailyTemperatureMax;
  final List<double> dailyTemperatureMin;
  final List<int> dailyWeatherCodeDescription;

  WeeklyWeatherData({
    required super.type,
    required this.dailyTime,
    required this.dailyTemperatureMax,
    required this.dailyTemperatureMin,
    required this.dailyWeatherCodeDescription,
  });
}



class WeatherData {
  final WeatherType type;

  WeatherData({required this.type});

  String getWeatherDescription(int description) {
    switch (description) {
      case 0:
        return 'Clear Sky';
      case 1:
        return 'Mainly clear';
      case 2:
        return 'Partly cloudy';
      case 3:
        return 'Overcast';
      case 45:
        return 'Fog';
      case 48:
        return 'Depositing rime fog';
      case 51:
        return 'Light drizzle';
      case 53:
        return 'Moderate drizzle';
      case 55:
        return 'Dense drizzle';
      case 56:
        return 'Light freezing drizzle';
      case 57:
        return 'Dense freezing drizzle';
      case 61:
        return 'Slight rain';
      case 63:
        return 'Moderate rain';
      case 65:
        return 'Heavy rain';
      case 66:
        return 'Light freezing rain';
      case 67:
        return 'Heavy freezing rain';
      case 71:
        return 'Slight snow fall';
      case 73:
        return 'Moderate snow fall';
      case 75:
        return 'Heavy snow fall';
      case 77:
        return 'Snow grains';
      case 80:
        return 'Slight rain showers';
      case 81:
        return 'Moderate rain showers';
      case 82:
        return 'Violent rain showers';
      case 85:
        return 'Slight snow showers';
      case 86:
        return 'Heavy snow showers';
      case 95:
        return 'Thunderstorm';
      case 96:
        return 'Thunderstorm with slight hail';
      case 99:
        return 'Thunderstorm with heavy hail';
      default:
        return 'Unknown weather condition';
    }
  }

}
