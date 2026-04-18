import 'package:flutter/material.dart';
import 'package:medium_weather_app/constants/text_constants.dart';
import 'package:medium_weather_app/models/location.dart';
import 'package:medium_weather_app/models/weather_data.dart';
import 'package:medium_weather_app/services/weather_api_service.dart';

class LocationWeatherBlock extends StatelessWidget {
  final Location location;
  final String type;

  const LocationWeatherBlock({super.key, required this.location, required this.type});
  @override
  Widget build(BuildContext context) {
    if (location.name.isEmpty) {
      return Column(
        children: [
          Text(
            type,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            '${location.latitude}, ${location.longitude}',
            style: const TextStyle(fontSize: 18, color: Colors.grey),
            )
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            location.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        if (location.admin1.isNotEmpty)
          Text(
            location.admin1,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
        Text(
          location.country,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class CurrentWeatherBlock extends StatefulWidget {
  final Location location;

  const CurrentWeatherBlock({super.key, required this.location});

  @override
  State<CurrentWeatherBlock> createState() => _CurrentWeatherBlockState();
}

class _CurrentWeatherBlockState extends State<CurrentWeatherBlock> {
  late Future<CurrentWeatherData> currentWeatherData;

  Future<CurrentWeatherData> _fetchCurrentWeather() async {
    try {
      return await WeatherApiService.fetchCurrentWeather(
        widget.location.latitude,
        widget.location.longitude,
      );
    } catch (_) {
      throw TextConstants.errorConnectionLost;
    }
  }

  @override
  void initState() {
    super.initState();
    currentWeatherData = _fetchCurrentWeather();
  }

  @override
  void didUpdateWidget(covariant CurrentWeatherBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location.latitude != widget.location.latitude ||
        oldWidget.location.longitude != widget.location.longitude) {
      setState(() {
        currentWeatherData = _fetchCurrentWeather();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: FutureBuilder<CurrentWeatherData>(
        future: currentWeatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}', style: const TextStyle(color: Colors.red, fontSize: 18),),
            );
          } else if (snapshot.hasData) {
            final weather = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LocationWeatherBlock(location: widget.location, type: TextConstants.titleTab_1),
 
                  Text(
                    '${weather.currentTemperature}°C',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${weather.currentWindSpeed} km/h',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

class TodayWeatherBlock extends StatefulWidget {
  final Location location;

  const TodayWeatherBlock({super.key, required this.location});

  @override
  State<TodayWeatherBlock> createState() => _TodayWeatherBlockState();
}

class _TodayWeatherBlockState extends State<TodayWeatherBlock> {
  late Future<HourlyWeatherData> todayWeatherData;

  @override
  void initState() {
    super.initState();
    todayWeatherData = WeatherApiService.fetchTodayWeather(
      widget.location.latitude,
      widget.location.longitude,
    );
  }

  @override
  void didUpdateWidget(covariant TodayWeatherBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location.latitude != widget.location.latitude ||
        oldWidget.location.longitude != widget.location.longitude) {
      setState(() {
        todayWeatherData = WeatherApiService.fetchTodayWeather(
          widget.location.latitude,
          widget.location.longitude,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: FutureBuilder<HourlyWeatherData>(
        future: todayWeatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final weather = snapshot.data!;
            return Center(
              child: Column(
                children: [
                  LocationWeatherBlock(location: widget.location, type: TextConstants.titleTab_2),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 600),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: weather.hourlyTime.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Row(
                              children: [
                                Text(
                                  weather.hourlyTime[index]
                                      .toLocal()
                                      .toString()
                                      .split(' ')[1]
                                      .substring(0, 5),
                                ),
                                const SizedBox(width: 16),
                                Text('${weather.hourlyTemperature[index]}°C'),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    weather.getWeatherDescription(
                                      weather
                                          .hourlyWeatherCodeDescription[index],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text('${weather.hourlyWindSpeed[index]} km/h'),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

class WeeklyWeatherBlock extends StatefulWidget {
  final Location location;

  const WeeklyWeatherBlock({super.key, required this.location});

  @override
  State<WeeklyWeatherBlock> createState() => _WeeklyWeatherBlockState();
}

class _WeeklyWeatherBlockState extends State<WeeklyWeatherBlock> {
  late Future<WeeklyWeatherData> weeklyWeatherData;

  @override
  void initState() {
    super.initState();
    weeklyWeatherData = WeatherApiService.fetchWeeklyWeather(
      widget.location.latitude,
      widget.location.longitude,
    );
  }

  @override
  void didUpdateWidget(covariant WeeklyWeatherBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location.latitude != widget.location.latitude ||
        oldWidget.location.longitude != widget.location.longitude) {
      setState(() {
        weeklyWeatherData = WeatherApiService.fetchWeeklyWeather(
          widget.location.latitude,
          widget.location.longitude,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: FutureBuilder<WeeklyWeatherData>(
        future: weeklyWeatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final weather = snapshot.data!;
            return Center(
              child: Column(
                children: [
                  LocationWeatherBlock(location: widget.location, type: TextConstants.titleTab_3),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 600),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: weather.dailyTime.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Row(
                              children: [
                                Text(
                                  weather.dailyTime[index]
                                      .toLocal()
                                      .toString()
                                      .split(' ')[0],
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  '${weather.dailyTemperatureMin[index]}°C / ${weather.dailyTemperatureMax[index]}°C',
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    weather.getWeatherDescription(
                                      weather
                                          .dailyWeatherCodeDescription[index],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

class WeatherBlock extends StatelessWidget {
  final String type;
  final Location location;

  const WeatherBlock({super.key, required this.type, required this.location});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TextConstants.titleTab_1:
        return CurrentWeatherBlock(location: location);
      case TextConstants.titleTab_2:
        return TodayWeatherBlock(location: location);
      case TextConstants.titleTab_3:
        return WeeklyWeatherBlock(location: location);
      default:
        return const Center(child: Text('Invalid weather type'));
    }
  }
}
