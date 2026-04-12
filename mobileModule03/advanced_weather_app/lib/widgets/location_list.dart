import 'package:advanced_weather_app/constants/text_constants.dart';
import 'package:advanced_weather_app/models/location.dart';
import 'package:advanced_weather_app/services/weather_api_service.dart';
import 'package:flutter/material.dart';

class LocationListWidget extends StatefulWidget {
  const LocationListWidget({
    super.key,
    required this.query,
    required this.onTapLocation,
  });

  final String query;
  final void Function(Location) onTapLocation;

  @override
  State<LocationListWidget> createState() => _LocationListWidgetState();
}

class _LocationListWidgetState extends State<LocationListWidget> {
  late Future<List<Location>> locations;

  @override
  void initState() {
    super.initState();
    locations = WeatherApiService.fetchLocations(widget.query);
  }

  @override
  void didUpdateWidget(covariant LocationListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      setState(() {
        locations = WeatherApiService.fetchLocations(widget.query);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Location>>(
      future: locations,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                TextConstants.errorConnectionLost,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.95)),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No matches',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
            ),
          );
        }

        final list = snapshot.data!.take(5).toList();

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: list.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: Colors.white.withValues(alpha: 0.12),
          ),
          itemBuilder: (context, index) {
            final location = list[index];
            final secondary = location.admin1.trim().isNotEmpty
                ? '${location.admin1}, ${location.country}'
                : location.country;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => widget.onTapLocation(location),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: Colors.white.withValues(alpha: 0.85),
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              location.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 17,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              secondary,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.75),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.north_east_rounded,
                        size: 18,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
