import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_weather_forecast_san_francisco/main.dart';

void main() {
  testWidgets('Weather App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WeatherApp());

    // Verify that the title of the app bar (defaulting to San Francisco) is displayed
    expect(find.text('San Francisco'), findsWidgets);
  });
}
