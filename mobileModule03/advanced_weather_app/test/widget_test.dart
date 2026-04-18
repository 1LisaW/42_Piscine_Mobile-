import 'package:flutter_test/flutter_test.dart';

import 'package:advanced_weather_app/main.dart';

void main() {
  testWidgets('App loads', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Weather'), findsOneWidget);
  });
}
