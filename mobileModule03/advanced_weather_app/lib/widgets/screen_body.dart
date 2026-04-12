import 'package:advanced_weather_app/models/location.dart';
import 'package:advanced_weather_app/widgets/weather_block.dart';
import 'package:flutter/material.dart';

class ScreenBody extends StatefulWidget {
  const ScreenBody({
    super.key,
    required this.tabBarTitle,
    required this.tabBarGeoposition,
    required this.hasError,
    required this.errorMessage,
  });

  final String tabBarTitle;
  final Location tabBarGeoposition;
  final bool hasError;
  final String errorMessage;

  @override
  State<ScreenBody> createState() => _ScreenBodyState();
}

class _ScreenBodyState extends State<ScreenBody> {
  @override
  Widget build(BuildContext context) {
    if (widget.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            widget.errorMessage,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (widget.tabBarGeoposition.isActualLocation == false) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.tabBarTitle,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white.withValues(alpha: 0.95),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No location selected',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      );
    }

    return WeatherBlock(
      type: widget.tabBarTitle,
      location: widget.tabBarGeoposition,
    );
  }
}
