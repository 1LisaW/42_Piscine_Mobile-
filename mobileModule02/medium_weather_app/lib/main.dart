import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:medium_weather_app/constants/text_constants.dart';
import 'package:medium_weather_app/models/location.dart';
import 'package:medium_weather_app/services/weather_api_service.dart';
import 'package:medium_weather_app/widgets/screen_body.dart';
import 'package:medium_weather_app/services/location_service.dart';
import 'package:medium_weather_app/widgets/location_list.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'medium weather app',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: const MyHomePage(title: 'Medium Weather App'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Location currentLocation = Location(
    name: '',
    admin1: '',
    country: '',
    latitude: 0.0,
    longitude: 0.0,
    isActualLocation: false,
  );

  void _setCurrentLocation(
    String name,
    String admin1,
    String country,
    double latitude,
    double longitude,
    bool? isActualLocation,
  ) {
    setState(() {
      currentLocation = currentLocation.update(
        name,
        admin1,
        country,
        latitude,
        longitude,
        isActualLocation ?? true,
      );

      searchGeolocation = '';
    });
    textController.text = '';
  }

  void onTapLocation(Location location) {
    _setCurrentLocation(
      location.name,
      location.admin1,
      location.country,
      location.latitude,
      location.longitude,
      true,
    );
    _setError(false, '');
  }

  void _setError(bool hasError, String? message) {
    setState(() {
      this.hasError = hasError;
      errorMessage = message ?? '';
    });
  }

  late TabController tabController;

  bool hasError = false;
  String errorMessage = '';


  Future<void> _getLocation() async {
    try {
      final Position position = await LocationService.determinePosition();
      _setError(false, '');
      _setCurrentLocation(
      //TODO: commented out for ex00 to show the coordinates only, uncomment for ex01 to show the location name
        '','','',
        // locationInfo?['city'] ?? '',
        // locationInfo?['admin1'] ?? '',
        // locationInfo?['country'] ?? '',
        position.latitude,
        position.longitude,
        true,
      );
    } on ClientException catch (_) {
        _setCurrentLocation('No results', '', '', 0.0, 0.0, false);
        _setError(true, TextConstants.errorConnectionLost);
    } catch (e) {
       _setCurrentLocation('No results', '', '', 0.0, 0.0, false);
        _setError(true, TextConstants.errorConnectionLost);
    }
  }

  void onSubmitSearch(String text) async {
    if (text.isNotEmpty) {
      try {
        final locations = await WeatherApiService.fetchLocations(text);
        if (locations.isNotEmpty) {
          final location = locations.first;
          _setCurrentLocation(
            location.name,
            location.admin1,
            location.country,
            location.latitude,
            location.longitude,
            true,
          );
          _setError(false, '');
        } else {
          _setCurrentLocation('No results', '', '', 0.0, 0.0, false);
          _setError(true, TextConstants.errorNoResults);
        }
      } on ClientException catch (_) {
        _setCurrentLocation('Error', '', '', 0.0, 0.0, false);
        _setError(true, TextConstants.errorConnectionLost);
      } catch (e) {
        _setCurrentLocation('Error', '', '', 0.0, 0.0, false);
        _setError(true, TextConstants.errorConnectionLost);

      }
    }
  }

  String searchGeolocation = '';

  void onSearchChanged(String text) {
    if (textController.text.length > 2) {
      setState(() {
        searchGeolocation = textController.text;
      });
    } else if (searchGeolocation.isNotEmpty) {
      setState(() {
        searchGeolocation = '';
      });
    }
  }

  final textController = TextEditingController();

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    tabController.dispose();
    super.dispose();
  }

  double responsiveHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (height < 700) {
      return height - 175;
    }
    return 500;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: Colors.grey,
        foregroundColor: Colors.grey.shade300,
        title: Container(
          decoration: BoxDecoration(
            border: Border(right: BorderSide(width: 1.5, color: Colors.white)),
          ),
          child: TextField(
            controller: textController,
            style: TextStyle(
              color: Colors.grey.shade300,
              decoration: TextDecoration.none,
              decorationThickness: 0,
            ),
            decoration: InputDecoration(
              border: UnderlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
              fillColor: Colors.grey.shade300,
              hintText: 'Search location...',
              hintStyle: TextStyle(color: Colors.grey.shade300),
              prefixIcon: const Icon(
                Icons.search,
                color: Color.fromARGB(255, 228, 224, 224),
              ),
            ),
            onChanged: onSearchChanged,
            onSubmitted: onSubmitSearch,
          ),
        ),
        actions: <Widget>[
          IconButton(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 10),
            icon: const Icon(Icons.near_me, color: Colors.white),
            onPressed: _getLocation,
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 100,
        surfaceTintColor: Colors.white,

        child: TabBar(
          labelColor: Color.fromARGB(255, 101, 92, 163),
          unselectedLabelColor: Colors.grey.shade500,
          padding: EdgeInsets.all(0),
          tabs: [
            Tab(
              text: TextConstants.titleTab_1,
              icon: Icon(
                Icons.brightness_5_sharp,
                color: tabController.index == 0
                    ? Colors.indigo.shade500
                    : Colors.grey.shade500,
              ),
            ),
            Tab(
              text: TextConstants.titleTab_2,
              icon: Icon(
                Icons.today,
                color: tabController.index == 1
                    ? Colors.indigo.shade500
                    : Colors.grey.shade500,
              ),
            ),
            Tab(
              text: TextConstants.titleTab_3,
              icon: Icon(
                Icons.date_range_sharp,
                color: tabController.index == 2
                    ? Colors.indigo.shade500
                    : Colors.grey.shade500,
              ),
            ),
          ],
          controller: tabController,
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: tabController,
            children: [
              ScreenBody(
                tabBarTitle: TextConstants.titleTab_1,
                tabBarGeoposition: currentLocation,
                tabController: tabController,
                hasError: hasError,
                errorMessage: errorMessage,
              ),
              ScreenBody(
                tabBarTitle: TextConstants.titleTab_2,
                tabBarGeoposition: currentLocation,
                tabController: tabController,
                hasError: hasError,
                errorMessage: errorMessage,
              ),
              ScreenBody(
                tabBarTitle: TextConstants.titleTab_3,
                tabBarGeoposition: currentLocation,
                tabController: tabController,
                hasError: hasError,
                errorMessage: errorMessage,
              ),
            ],
          ),

          if (searchGeolocation.isNotEmpty) //&& _focusNode.hasFocus)
            Positioned(
              top: 0,
              left: 0,

              // right: 0,
              child: SizedBox(
                height: responsiveHeight(context),
                width: min<double>(MediaQuery.of(context).size.width, 500),
                child: LocationListWidget(
                  query: searchGeolocation,
                  onTapLocation: onTapLocation,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
