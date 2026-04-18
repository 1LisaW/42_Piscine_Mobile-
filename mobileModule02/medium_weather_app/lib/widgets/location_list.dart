import 'package:flutter/material.dart';
import 'package:medium_weather_app/constants/text_constants.dart';
import 'package:medium_weather_app/models/location.dart';
import 'package:medium_weather_app/services/weather_api_service.dart';

class LocationListWidget extends StatefulWidget {
  final String query;
  final Function(Location) onTapLocation;

  const LocationListWidget({
    super.key,
    required this.query,
    required this.onTapLocation,
  });

  @override
  State<LocationListWidget> createState() => _LocationListWidgetState();
}

class _LocationListWidgetState extends State<LocationListWidget> {
  late Future<List<Location>> locations;

  @override
  void initState() {
    super.initState();
    setState(() {
      try {
        locations = WeatherApiService.fetchLocations(widget.query);
      } catch (e) {
        locations = Future.error('Failed to load locations: $e');
      }
      // locations = WeatherApiService.fetchLocations(widget.query);
    });
  }

  @override
  void didUpdateWidget(covariant LocationListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      setState(() {
        try {
          locations = WeatherApiService.fetchLocations(widget.query);
        } catch (e) {
          locations = Future.error('Failed to load locations: $e');
        }
        // locations = WeatherApiService.fetchLocations(widget.query);
      });
    }
  }

  double responsiveHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (height < 700) {
      return height - 175; // For small screens, use 30% of the height
    } // if (height < 900) {
    return 500; // For medium screens, use 40% of the height
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Location>>(
      future: locations,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            heightFactor: 20,
            child: Text(TextConstants.errorConnectionLost),
          );
        } else if (snapshot.hasData) {
          final locations = snapshot.data!;
          return ListView.builder(
            itemCount: locations.length,
            itemBuilder: (context, index) {
              final location = locations[index];
              return Material(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 5,
                    bottom: 5,
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: 15.0),
                    shape: Border(
                      bottom: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    onTap: () => widget.onTapLocation(location),
                    title: Row(
                      children: [
                        Text(
                          location.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        location.admin1.isNotEmpty == true
                            ? Text(
                                ' ${location.admin1}',
                                style: TextStyle(color: Colors.grey.shade600),
                              )
                            : Container(),
                        Text(
                          ', ${location.country}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    // subtitle: Text('Lat: ${location.latitude}, Lon: ${location.longitude}'),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
