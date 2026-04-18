import 'dart:ui';

import 'package:advanced_weather_app/constants/text_constants.dart';
import 'package:advanced_weather_app/models/location.dart';
import 'package:advanced_weather_app/models/weather_data.dart';
import 'package:advanced_weather_app/services/weather_api_service.dart';
import 'package:advanced_weather_app/utils/weather_icons.dart';
import 'package:advanced_weather_app/widgets/weather_charts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FrostedPanel extends StatelessWidget {
  const FrostedPanel({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
        child: Container(
          width: double.infinity,
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class LocationHeader extends StatelessWidget {
  const LocationHeader({
    super.key,
    required this.location,
    // required this.subtitle,
  });

  final Location location;
  // final String subtitle;

  @override
  Widget build(BuildContext context) {
    if (location.name.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   subtitle,
          //   style: TextStyle(
          //     color: Colors.white.withValues(alpha: 0.75),
          //     fontSize: 13,
          //     letterSpacing: 0.3,
          //   ),
          // ),
          const SizedBox(height: 16),
          Text(
            '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    final region = location.admin1.trim();
    final placeLine = region.isNotEmpty
        ? '${location.name}, $region'
        : location.name;

    return Center(child:
     Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Text(
        //   subtitle,
        //   style: TextStyle(
        //     color: Colors.white.withValues(alpha: 0.75),
        //     fontSize: 13,
        //     letterSpacing: 0.3,
        //   ),
        // ),
        const SizedBox(height: 6),
        Text(
          location.name,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        Text(
          region.isNotEmpty ? '${region}, ${location.country}' : location.country,
          // '${region}, ${location.country}',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    )
    ); 
   
  }
}

class CurrentWeatherBlock extends StatefulWidget {
  const CurrentWeatherBlock({super.key, required this.location});

  final Location location;

  @override
  State<CurrentWeatherBlock> createState() => _CurrentWeatherBlockState();
}

class _CurrentWeatherBlockState extends State<CurrentWeatherBlock> {
  late Future<CurrentWeatherData> currentWeatherData;

  @override
  void initState() {
    super.initState();
    currentWeatherData = WeatherApiService.fetchCurrentWeather(
      widget.location.latitude,
      widget.location.longitude,
    );
  }

  @override
  void didUpdateWidget(covariant CurrentWeatherBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location.latitude != widget.location.latitude ||
        oldWidget.location.longitude != widget.location.longitude) {
      setState(() {
        currentWeatherData = WeatherApiService.fetchCurrentWeather(
          widget.location.latitude,
          widget.location.longitude,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CurrentWeatherData>(
      future: currentWeatherData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(48),
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Center(
            child: Text('No data', style: TextStyle(color: Colors.white)),
          );
        }

        final weather = snapshot.data!;
        final icon = weatherIconForCode(weather.currentWeatherCodeDescription);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              // flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: FrostedPanel(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                              LocationHeader(
                                location: widget.location,
                              ),
                              const SizedBox(height: 44),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${weather.currentTemperature.toStringAsFixed(1)}°C',
                                          style: TextStyle(
                                            color: weather.currentTemperature > 0
                                                ? Colors.orange
                                                : Colors.blue,
                                            fontSize: 44,
                                            fontWeight: FontWeight.w300,
                                            height: 1,
                                          ),
                                        ),
                                        const SizedBox(height: 28),
                                        Text(
                                          weather.getWeatherDescription(
                                            weather.currentWeatherCodeDescription,
                                          ),
                                          style: TextStyle(
                                            color: Colors.white
                                                .withValues(alpha: 0.95),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Icon(icon, size: 72, color: Colors.blue),
                                        const SizedBox(height: 48),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.air_rounded,
                                      color: Colors.white.withValues(alpha: 0.9),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Wind ${weather.currentWindSpeed.toStringAsFixed(1)} km/h',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class TodayWeatherBlock extends StatefulWidget {
  const TodayWeatherBlock({super.key, required this.location});

  final Location location;

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
    final timeFmt = DateFormat('HH:mm');

    return FutureBuilder<HourlyWeatherData>(
      future: todayWeatherData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Center(
            child: Text('No data', style: TextStyle(color: Colors.white)),
          );
        }

        final weather = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: FrostedPanel(
                child: Column(
                  children: [
                    LocationHeader(
                      location: widget.location,
                      // subtitle: TextConstants.titleTab_2,
                    ),
                    
                    if (MediaQuery.orientationOf(context) ==
                        Orientation.portrait) ...[
                          const SizedBox(height: 8),
                    Text(
                      'Today temperatures',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                      const SizedBox(height: 12),
                      TodayTemperatureChart(data: weather),
                    ],
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: weather.hourlyTime.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final code = weather.hourlyWeatherCodeDescription[index];
                  return SizedBox(
                    width: 108,
                    child: FrostedPanel(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            timeFmt.format(
                              weather.hourlyTime[index].toLocal(),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Icon(
                            weatherIconForCode(code),
                            color: Colors.blue,
                            size: 28,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${weather.hourlyTemperature[index].toStringAsFixed(1)}°',
                            style: TextStyle(
                              color: weather.hourlyTemperature[index] > 0
                                  ? Colors.orange
                                  : Colors.blue,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${weather.hourlyWindSpeed[index].toStringAsFixed(0)} km/h',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 11,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class WeeklyWeatherBlock extends StatefulWidget {
  const WeeklyWeatherBlock({super.key, required this.location});

  final Location location;

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
    final dayFmt = DateFormat('dd/MM');

    return FutureBuilder<WeeklyWeatherData>(
      future: weeklyWeatherData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Center(
            child: Text('No data', style: TextStyle(color: Colors.white)),
          );
        }

        final weather = snapshot.data!;
        final days = weather.dailyTime.length.clamp(0, 7);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: FrostedPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LocationHeader(
                      location: widget.location,
                      // subtitle: TextConstants.titleTab_3,
                    ),
                   
                     if (MediaQuery.orientationOf(context) ==
                        Orientation.portrait) ...[
                           const SizedBox(height: 8),
                    Row(
                      children: [
                        _LegendDot(color: const Color(0xFFFF8A65), label: 'Max'),
                        const SizedBox(width: 16),
                        _LegendDot(color: const Color(0xFF64B5F6), label: 'Min'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    WeeklyMinMaxChart(data: weather),
                        ]
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: days,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final code = weather.dailyWeatherCodeDescription[index];
                  return SizedBox(
                    width: 124,
                    child: FrostedPanel(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            dayFmt.format(
                              weather.dailyTime[index].toLocal(),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Icon(
                            weatherIconForCode(code),
                            color: Colors.white,
                            size: 28,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            weather.getWeatherDescription(code),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 11,
                              height: 1.2,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${weather.dailyTemperatureMax[index].toStringAsFixed(0)}° max',
                            style: const TextStyle(
                              color: Color(0xFFFFAB91),
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${weather.dailyTemperatureMin[index].toStringAsFixed(0)}° min',
                            style: const TextStyle(
                              color: Color(0xFF90CAF9),
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class WeatherBlock extends StatelessWidget {
  const WeatherBlock({
    super.key,
    required this.type,
    required this.location,
  });

  final String type;
  final Location location;

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
        return const Center(
          child: Text('Invalid weather type', style: TextStyle(color: Colors.white)),
        );
    }
  }
}
