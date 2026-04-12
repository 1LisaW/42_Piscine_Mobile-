import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, String>?> getLocationInfo(
  double latitude,
  double longitude,
) async {
  final url = Uri.parse(
    'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude',
  );

  final response = await http.get(
    url,
    headers: {
      'User-Agent': 'advanced-weather-app',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    final address = data['address'];
    return {
      'country': address['country'] ?? '',
      'admin1': address['state'] ?? '',
      'city': address['city'] ??
          address['town'] ??
          address['village'] ??
          '',
    };
  } else {
    return null;
  }
}
