import 'package:flutter/material.dart';
import 'package:medium_weather_app/models/location.dart';
import 'package:medium_weather_app/widgets/weather_block.dart';

class ScreenBody extends StatefulWidget {
  final String tabBarTitle;
  final Location tabBarGeoposition;
  final TabController tabController;
  final bool hasError;
  final String errorMessage;

  const ScreenBody({
    super.key,
    required this.tabBarTitle,
    required this.tabBarGeoposition,
    required this.tabController,
    required this.hasError,
    required this.errorMessage,
  });

  @override
  State<ScreenBody> createState() => _ScreenBodyState();
}

class _ScreenBodyState extends State<ScreenBody> {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      backgroundColor: Colors.white,
      body: (widget.hasError)
          ? Center(
            child: Text(
              widget.errorMessage,
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          )
          : (widget.tabBarGeoposition.isActualLocation == false)
          ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.tabBarTitle,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'No location selected',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          )
          : WeatherBlock(
              type: widget.tabBarTitle,
              location: widget.tabBarGeoposition,
            ),
    ));
  }
}
