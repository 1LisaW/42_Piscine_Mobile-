import 'package:advanced_weather_app/constants/text_constants.dart';
import 'package:advanced_weather_app/models/location.dart';
import 'package:advanced_weather_app/services/get_location_info.dart';
import 'package:advanced_weather_app/services/location_service.dart';
import 'package:advanced_weather_app/services/weather_api_service.dart';
import 'package:advanced_weather_app/widgets/location_list.dart';
import 'package:advanced_weather_app/widgets/screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:geolocator/geolocator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Weather',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Advanced Weather App'),
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
    textController.clear();
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
      final locationInfo = await getLocationInfo(
        position.latitude,
        position.longitude,
      );
      _setError(false, '');
      _setCurrentLocation(
        locationInfo?['city'] ?? '',
        locationInfo?['admin1'] ?? '',
        locationInfo?['country'] ?? '',
        position.latitude,
        position.longitude,
        true,
      );
    } on ClientException catch (_) {
      _setCurrentLocation('Error', '', '', 0.0, 0.0, false);
      _setError(true, TextConstants.errorConnectionLost);
    } catch (e) {
      _setCurrentLocation('Error', '', '', 0.0, 0.0, false);
      _setError(true, e.toString());
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
        _setError(true, e.toString());
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
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    textController.dispose();
    tabController.dispose();
    super.dispose();
  }

  double responsiveOverlayHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (height < 700) {
      return height * 0.45;
    }
    return 360;
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/weather_background.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1565C0),
                      Color(0xFF0D47A1),
                      Color(0xFF263238),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.25),
                    Colors.black.withValues(alpha: 0.45),
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: topInset + 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   'Weather',
                          //   style: TextStyle(
                          //     color: Colors.white.withValues(alpha: 0.85),
                          //     fontSize: 13,
                          //     fontWeight: FontWeight.w600,
                          //     letterSpacing: 0.4,
                          //   ),
                          // ),
                          const SizedBox(height: 16),
                          Material(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(16),
                            clipBehavior: Clip.antiAlias,
                            child: TextField(
                              controller: textController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: TextConstants.searchHint,
                                hintStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.45),
                                ),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: Colors.white.withValues(alpha: 0.75),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 14,
                                ),
                              ),
                              onChanged: onSearchChanged,
                              onSubmitted: onSubmitSearch,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 4, right: 4),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Container(
                          width: 1.5,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Tooltip(
                        message: 'Use my current location',
                        child: Material(
                          type: MaterialType.transparency,
                          color: Colors.transparent,
                          elevation: 0,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            splashColor: Colors.white24,
                            highlightColor: Colors.white10,
                            onTap: _getLocation,
                            child: const Padding(
                              padding: EdgeInsets.all(14),
                              child: Icon(
                                Icons.near_me_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    ScreenBody(
                      tabBarTitle: TextConstants.titleTab_1,
                      tabBarGeoposition: currentLocation,
                      hasError: hasError,
                      errorMessage: errorMessage,
                    ),
                    ScreenBody(
                      tabBarTitle: TextConstants.titleTab_2,
                      tabBarGeoposition: currentLocation,
                      hasError: hasError,
                      errorMessage: errorMessage,
                    ),
                    ScreenBody(
                      tabBarTitle: TextConstants.titleTab_3,
                      tabBarGeoposition: currentLocation,
                      hasError: hasError,
                      errorMessage: errorMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (searchGeolocation.isNotEmpty)
            Positioned(
              top: topInset + 88,
              left: 16,
              right: 16,
              child: Material(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAlias,
                elevation: 12,
                shadowColor: Colors.black54,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: responsiveOverlayHeight(context),
                  ),
                  child: LocationListWidget(
                    query: searchGeolocation,
                    onTapLocation: onTapLocation,
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
          ),
        ),
        child: SafeArea(
          top: false,
          child: TabBar(
            controller: tabController,
            indicatorColor: Colors.orange,
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.white.withValues(alpha: 0.55),
            tabs: [
              Tab(
                text: TextConstants.titleTab_1,
                icon: Icon(
                  Icons.brightness_5_rounded,
                  color: tabController.index == 0
                      ? Colors.orange
                      : Colors.white.withValues(alpha: 0.55),
                ),
              ),
              Tab(
                text: TextConstants.titleTab_2,
                icon: Icon(
                  Icons.today_rounded,
                  color: tabController.index == 1
                      ? Colors.orange
                      : Colors.white.withValues(alpha: 0.55),
                ),
              ),
              Tab(
                text: TextConstants.titleTab_3,
                icon: Icon(
                  Icons.date_range_rounded,
                  color: tabController.index == 2
                      ? Colors.orange
                      : Colors.white.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
