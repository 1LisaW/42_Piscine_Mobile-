class Location {
  final String name;
  final String admin1;
  final String country;
  final double latitude;
  final double longitude;
  final bool isActualLocation;

  Location({
    required this.name,
    required this.admin1,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.isActualLocation = true,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      admin1: json['admin1'] ?? '',
      country: json['country'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      isActualLocation: true,
    );
  }

  Location update(
    String name,
    String admin1,
    String country,
    double latitude,
    double longitude,
    bool? isActualLocation,
  ) {
    return Location(
      name: name,
      admin1: admin1,
      country: country,
      latitude: latitude,
      longitude: longitude,
      isActualLocation: isActualLocation ?? true,
    );
  }

  String get displayLocationInfo {
    if (name.isEmpty) {
      return 'Unknown Location';
    }
    return '$name $admin1, $country';
  }
}
