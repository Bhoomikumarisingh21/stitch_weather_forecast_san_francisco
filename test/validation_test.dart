import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_weather_forecast_san_francisco/weather_model.dart';

void main() {
  group('Comprehensive Location Validation Tests', () {
    test('All Indian states and union territories should be accepted', () {
      final states = [
        'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh',
        'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand', 'Karnataka',
        'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur', 'Meghalaya', 'Mizoram',
        'Nagaland', 'Odisha', 'Punjab', 'Rajasthan', 'Sikkim', 'Tamil Nadu',
        'Telangana', 'Tripura', 'Uttarakhand', 'Uttar Pradesh', 'West Bengal',
        'Delhi', 'Jammu and Kashmir', 'Ladakh', 'Chandigarh'
      ];
      for (var state in states) {
        expect(LocationService.isValid(state), isTrue, reason: 'Failed for state: $state');
      }
    });

    test('Major Indian cities should be accepted', () {
      final cities = [
        'Mumbai', 'Pune', 'Nagpur', 'Nashik', 'Kolkata', 'Howrah', 'Chennai',
        'Coimbatore', 'Bengaluru', 'Bangalore', 'Mysore', 'Hyderabad', 'Visakhapatnam',
        'Vijayawada', 'Ahmedabad', 'Surat', 'Jaipur', 'Jodhpur', 'Bhopal', 'Indore',
        'Patna', 'Ranchi', 'Bhubaneswar', 'Lucknow', 'Kanpur', 'Noida', 'Gurugram'
      ];
      for (var city in cities) {
        expect(LocationService.isValid(city), isTrue, reason: 'Failed for Indian city: $city');
      }
    });

    test('Major world cities should be accepted', () {
      final worldCities = [
        'Berlin', 'Madrid', 'Rome', 'Vienna', 'Amsterdam', 'Brussels', 'Geneva',
        'Zurich', 'Copenhagen', 'Oslo', 'Stockholm', 'Helsinki', 'Lisbon', 'Dublin',
        'Shanghai', 'Hong Kong', 'Taipei', 'Singapore', 'Bangkok', 'Kuala Lumpur',
        'Manila', 'Hanoi', 'Dubai', 'Abu Dhabi', 'Riyadh', 'Doha', 'Tel Aviv',
        'Johannesburg', 'Cape Town', 'Nairobi', 'Lagos', 'Sydney', 'Melbourne',
        'Auckland', 'Sao Paulo', 'Rio de Janeiro', 'Santiago', 'Lima', 'Bogota',
        'Toronto', 'Vancouver', 'Montreal', 'Havana'
      ];
      for (var city in worldCities) {
        expect(LocationService.isValid(city), isTrue, reason: 'Failed for world city: $city');
      }
    });

    test('Countries should be accepted', () {
      final countries = [
        'United States', 'USA', 'United Kingdom', 'UK', 'Canada', 'Australia',
        'India', 'China', 'Japan', 'Germany', 'France', 'Italy', 'Spain', 'Brazil',
        'Russia', 'South Africa', 'Mexico', 'Egypt', 'Saudi Arabia', 'UAE',
        'New Zealand', 'Switzerland', 'Netherlands', 'Sweden', 'Turkey', 'Argentina'
      ];
      for (var country in countries) {
        expect(LocationService.isValid(country), isTrue, reason: 'Failed for country: $country');
      }
    });

    test('Capitals should be accepted', () {
      final capitals = [
        'Kabul', 'London', 'Paris', 'Berlin', 'Rome', 'Washington', 'Tokyo',
        'New Delhi', 'Beijing', 'Ottawa', 'Canberra', 'Cairo', 'Brasilia',
        'Moscow', 'Riyadh', 'Madrid', 'Stockholm', 'Bern', 'Bangkok', 'Athens'
      ];
      for (var capital in capitals) {
        expect(LocationService.isValid(capital), isTrue, reason: 'Failed for capital: $capital');
      }
    });

    test('International city names with special characters and Unicode should be accepted', () {
      final internationalNames = [
        'New Delhi',       // Space
        'St. Louis',        // Period, space
        "Xi'an",            // Apostrophe
        'São Paulo',        // Unicode accent
        'Abu Dhabi',        // Space
        'Ho Chi Minh City', // Spaces
        "Côte d'Ivoire",    // Accent, space, apostrophe
        'Mexico City',      // Space
        'Los Angeles'       // Space
      ];
      for (var name in internationalNames) {
        expect(LocationService.isValid(name), isTrue, reason: 'Failed for international name: $name');
      }
    });

    test('Normalization should format names correctly', () {
      expect(LocationService.normalizeLocationName('   mumbai   '), equals('Mumbai'));
      expect(LocationService.normalizeLocationName('new    delhi'), equals('New Delhi'));
      expect(LocationService.normalizeLocationName('usa'), equals('USA'));
      expect(LocationService.normalizeLocationName('uk'), equals('UK'));
      expect(LocationService.normalizeLocationName('são paulo'), equals('São Paulo'));
      expect(LocationService.normalizeLocationName("côte d'ivoire"), equals("Côte D'ivoire"));
    });

    test('Human names should be blocked', () {
      final names = ['Rahul', 'John', 'Priya', 'Amit', 'Smith', 'Johnson', 'Rohan', 'Sneha', 'Bhoomi', 'Kumari', 'Singh'];
      for (var name in names) {
        expect(LocationService.isValid(name), isFalse, reason: 'Failed to block human name: $name');
      }
    });

    test('Numbers and special-character-only inputs should be rejected', () {
      final invalidInputs = ['12345', 'Mumbai 123', '!!!!@', '#\$%', '12.34', '   ', 'A'];
      for (var input in invalidInputs) {
        expect(LocationService.isValid(input), isFalse, reason: 'Failed to reject input: $input');
      }
    });

    test('Keyboard gibberish should be rejected', () {
      final gibberish = ['qwerty', 'asdfgh', 'zxcvbn', 'aaaaaa', 'qwertyuiop', 'asdfghjkl'];
      for (var input in gibberish) {
        expect(LocationService.isValid(input), isFalse, reason: 'Failed to reject gibberish: $input');
      }
    });

    test('WeatherStore.fetchWeather validates and detects duplicate cities case-insensitively', () async {
      final store = WeatherStore();

      // Clear standard cities to keep test predictable or keep it and verify duplicates against defaults
      // The store initializes with San Francisco, London, New York, Tokyo, Paris.
      
      // 1. Valid input
      final data = await store.fetchWeather('Seattle', temp: 25.0, condition: 'Sunny');
      expect(data.cityName, equals('Seattle'));
      store.addCity(data);

      // 2. Duplicate entries should throw exception
      expect(
        () => store.fetchWeather('seattle', temp: 20.0, condition: 'Cloud'),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('This location has already been added.'))),
      );

      expect(
        () => store.fetchWeather('   Seattle   ', temp: 20.0, condition: 'Cloud'),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('This location has already been added.'))),
      );

      expect(
        () => store.fetchWeather('seAttLe', temp: 20.0, condition: 'Cloud'),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('This location has already been added.'))),
      );

      // 3. Invalid inputs should throw validation error
      expect(
        () => store.fetchWeather('Rahul', temp: 25.0, condition: 'Sunny'),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Please enter a valid city or location.'))),
      );
    });
  });
}
