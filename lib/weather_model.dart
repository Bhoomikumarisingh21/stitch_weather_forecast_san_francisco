import 'package:flutter/material.dart';

class HourlyForecast {
  final String hour;
  final String icon; // e.g. "rainy", "thunderstorm", "cloud", "wb_sunny"
  final int temp;
  final String pop; // probability of precipitation

  HourlyForecast({
    required this.hour,
    required this.icon,
    required this.temp,
    required this.pop,
  });
}

class DailyForecast {
  final String day;
  final String icon;
  final int minTemp;
  final int maxTemp;
  final double rangeStart; // 0.0 to 1.0 fraction
  final double rangeEnd;   // 0.0 to 1.0 fraction

  DailyForecast({
    required this.day,
    required this.icon,
    required this.minTemp,
    required this.maxTemp,
    required this.rangeStart,
    required this.rangeEnd,
  });
}

class WeatherData {
  final String cityName;
  final int temp;
  final String condition;
  final int feelsLike;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;
  final int aqi;
  final String aqiDesc;
  final String aqiLongDesc;
  final double windSpeed;
  final String windDir;
  final double windAngle; // in degrees, e.g. 270 for West
  final int humidity;
  final String humidityDesc;
  final int visibility;
  final String visibilityDesc;
  final String sunrise;
  final String sunset;
  final String moonrise;
  final String moonPhase;
  final String imageUrl;

  WeatherData({
    required this.cityName,
    required this.temp,
    required this.condition,
    required this.feelsLike,
    required this.hourly,
    required this.daily,
    required this.aqi,
    required this.aqiDesc,
    required this.aqiLongDesc,
    required this.windSpeed,
    required this.windDir,
    required this.windAngle,
    required this.humidity,
    required this.humidityDesc,
    required this.visibility,
    required this.visibilityDesc,
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonPhase,
    required this.imageUrl,
  });
}

class WeatherStore extends ChangeNotifier {
  // Unit settings
  bool _useFahrenheit = false;
  bool get useFahrenheit => _useFahrenheit;
  set useFahrenheit(bool val) {
    _useFahrenheit = val;
    notifyListeners();
  }

  bool _useMph = false;
  bool get useMph => _useMph;
  set useMph(bool val) {
    _useMph = val;
    notifyListeners();
  }

  // Active theme: 0 = Rainy Gray, 1 = Sunset Gold, 2 = Deep Dark
  int _activeThemeIndex = 0;
  int get activeThemeIndex => _activeThemeIndex;
  set activeThemeIndex(int val) {
    _activeThemeIndex = val;
    notifyListeners();
  }

  // City list
  final List<WeatherData> _cities = [];
  List<WeatherData> get cities => _cities;

  // Selected city
  int _selectedCityIndex = 0;
  WeatherData get current => _cities[_selectedCityIndex];
  int get selectedCityIndex => _selectedCityIndex;

  void selectCity(int index) {
    if (index >= 0 && index < _cities.length) {
      _selectedCityIndex = index;
      notifyListeners();
    }
  }

  void addCity(WeatherData data) {
    // Avoid duplicates
    final existingIndex = _cities.indexWhere(
      (c) => c.cityName.toLowerCase() == data.cityName.toLowerCase()
    );
    if (existingIndex != -1) {
      _selectedCityIndex = existingIndex;
    } else {
      _cities.add(data);
      _selectedCityIndex = _cities.length - 1;
    }
    notifyListeners();
  }

  WeatherStore() {
    // Initialize with mock data
    _cities.addAll([
      _createSanFranciscoData(),
      _createLondonData(),
      _createNewYorkData(),
      _createTokyoData(),
      _createParisData(),
    ]);
  }

  // Unit conversion helpers
  int convertTemp(int celsius) {
    if (_useFahrenheit) {
      return (celsius * 9 / 5 + 32).round();
    }
    return celsius;
  }

  String get tempUnitSymbol => _useFahrenheit ? '°F' : '°C';

  double convertWind(double kmh) {
    if (_useMph) {
      return kmh * 0.621371;
    }
    return kmh;
  }

  String get windUnitSymbol => _useMph ? 'mph' : 'km/h';

  // Mock data creators
  WeatherData _createSanFranciscoData() {
    return WeatherData(
      cityName: 'San Francisco',
      temp: 14,
      condition: 'Rainy',
      feelsLike: 12,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCT5TMNaRKBKxG4SRlILpymE451s1kHPM_-34s3L3cXFA1WM3YX5qgdhqB40SxX0tl_INo_m0wEntCC2M4mAiIAiOKO9CLzx6tU5AIWX3t7zhdG3E_ixyemxiB4F6_0apZyJoruIl0amCMhRXbfPlvHazLKnfEHzc65g5oS2voW0VEpcGIxCyV8UR371DEbtS_hUZsRMZt57PSj42Y5GXtaya-j3BYM6yxDqRybyEyOWuL18_4Gdwcnlr526HX4GkehlnhjXn2FYFA',
      hourly: [
        HourlyForecast(hour: 'Now', icon: 'rainy', temp: 14, pop: '90%'),
        HourlyForecast(hour: '2PM', icon: 'rainy', temp: 14, pop: '85%'),
        HourlyForecast(hour: '3PM', icon: 'thunderstorm', temp: 13, pop: '100%'),
        HourlyForecast(hour: '4PM', icon: 'rainy', temp: 13, pop: '95%'),
        HourlyForecast(hour: '5PM', icon: 'rainy', temp: 12, pop: '70%'),
        HourlyForecast(hour: '6PM', icon: 'cloud', temp: 12, pop: '40%'),
        HourlyForecast(hour: '7PM', icon: 'cloud', temp: 11, pop: '20%'),
        HourlyForecast(hour: '8PM', icon: 'cloud', temp: 10, pop: '15%'),
      ],
      daily: [
        DailyForecast(day: 'Today', icon: 'rainy', minTemp: 10, maxTemp: 15, rangeStart: 0.1, rangeEnd: 0.4),
        DailyForecast(day: 'Mon', icon: 'rainy', minTemp: 11, maxTemp: 16, rangeStart: 0.2, rangeEnd: 0.5),
        DailyForecast(day: 'Tue', icon: 'cloud', minTemp: 12, maxTemp: 17, rangeStart: 0.3, rangeEnd: 0.6),
        DailyForecast(day: 'Wed', icon: 'thunderstorm', minTemp: 13, maxTemp: 18, rangeStart: 0.4, rangeEnd: 0.7),
        DailyForecast(day: 'Thu', icon: 'partly_cloudy_day', minTemp: 14, maxTemp: 19, rangeStart: 0.5, rangeEnd: 0.8),
        DailyForecast(day: 'Fri', icon: 'wb_sunny', minTemp: 15, maxTemp: 20, rangeStart: 0.6, rangeEnd: 0.9),
        DailyForecast(day: 'Sat', icon: 'wb_sunny', minTemp: 16, maxTemp: 21, rangeStart: 0.7, rangeEnd: 1.0),
      ],
      aqi: 18,
      aqiDesc: 'Good',
      aqiLongDesc: 'Rain is clearing the air. Ideal quality.',
      windSpeed: 24.0,
      windDir: 'West',
      windAngle: 270.0,
      humidity: 88,
      humidityDesc: 'High humidity due to active rainfall.',
      visibility: 4,
      visibilityDesc: 'Reduced visibility in rain and fog.',
      sunrise: '6:12 AM',
      sunset: '8:05 PM',
      moonrise: '9:44 PM',
      moonPhase: 'Waning Crescent',
    );
  }

  WeatherData _createLondonData() {
    return WeatherData(
      cityName: 'London',
      temp: 11,
      condition: 'Overcast',
      feelsLike: 9,
      imageUrl: 'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?q=80&w=1000',
      hourly: [
        HourlyForecast(hour: 'Now', icon: 'cloud', temp: 11, pop: '30%'),
        HourlyForecast(hour: '2PM', icon: 'cloud', temp: 11, pop: '40%'),
        HourlyForecast(hour: '3PM', icon: 'rainy', temp: 10, pop: '80%'),
        HourlyForecast(hour: '4PM', icon: 'rainy', temp: 10, pop: '90%'),
        HourlyForecast(hour: '5PM', icon: 'cloud', temp: 9, pop: '50%'),
        HourlyForecast(hour: '6PM', icon: 'cloud', temp: 9, pop: '30%'),
        HourlyForecast(hour: '7PM', icon: 'cloud', temp: 8, pop: '15%'),
        HourlyForecast(hour: '8PM', icon: 'cloud', temp: 8, pop: '10%'),
      ],
      daily: [
        DailyForecast(day: 'Today', icon: 'cloud', minTemp: 8, maxTemp: 12, rangeStart: 0.2, rangeEnd: 0.5),
        DailyForecast(day: 'Mon', icon: 'rainy', minTemp: 7, maxTemp: 11, rangeStart: 0.1, rangeEnd: 0.4),
        DailyForecast(day: 'Tue', icon: 'rainy', minTemp: 8, maxTemp: 13, rangeStart: 0.2, rangeEnd: 0.5),
        DailyForecast(day: 'Wed', icon: 'cloud', minTemp: 9, maxTemp: 14, rangeStart: 0.3, rangeEnd: 0.6),
        DailyForecast(day: 'Thu', icon: 'partly_cloudy_day', minTemp: 10, maxTemp: 15, rangeStart: 0.4, rangeEnd: 0.7),
        DailyForecast(day: 'Fri', icon: 'wb_sunny', minTemp: 11, maxTemp: 17, rangeStart: 0.5, rangeEnd: 0.9),
        DailyForecast(day: 'Sat', icon: 'wb_sunny', minTemp: 11, maxTemp: 18, rangeStart: 0.5, rangeEnd: 1.0),
      ],
      aqi: 32,
      aqiDesc: 'Good',
      aqiLongDesc: 'Low pollution levels. Enjoy outdoor activities.',
      windSpeed: 18.0,
      windDir: 'Southwest',
      windAngle: 225.0,
      humidity: 78,
      humidityDesc: 'Comfortable relative humidity.',
      visibility: 8,
      visibilityDesc: 'Good visibility. Slight haze.',
      sunrise: '4:43 AM',
      sunset: '9:21 PM',
      moonrise: '10:15 PM',
      moonPhase: 'Last Quarter',
    );
  }

  WeatherData _createNewYorkData() {
    return WeatherData(
      cityName: 'New York',
      temp: 22,
      condition: 'Partly Cloudy',
      feelsLike: 23,
      imageUrl: 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?q=80&w=1000',
      hourly: [
        HourlyForecast(hour: 'Now', icon: 'partly_cloudy_day', temp: 22, pop: '10%'),
        HourlyForecast(hour: '2PM', icon: 'partly_cloudy_day', temp: 23, pop: '10%'),
        HourlyForecast(hour: '3PM', icon: 'wb_sunny', temp: 24, pop: '5%'),
        HourlyForecast(hour: '4PM', icon: 'wb_sunny', temp: 24, pop: '5%'),
        HourlyForecast(hour: '5PM', icon: 'partly_cloudy_day', temp: 23, pop: '15%'),
        HourlyForecast(hour: '6PM', icon: 'cloud', temp: 21, pop: '25%'),
        HourlyForecast(hour: '7PM', icon: 'cloud', temp: 19, pop: '30%'),
        HourlyForecast(hour: '8PM', icon: 'rainy', temp: 18, pop: '60%'),
      ],
      daily: [
        DailyForecast(day: 'Today', icon: 'partly_cloudy_day', minTemp: 18, maxTemp: 24, rangeStart: 0.4, rangeEnd: 0.8),
        DailyForecast(day: 'Mon', icon: 'rainy', minTemp: 16, maxTemp: 22, rangeStart: 0.3, rangeEnd: 0.7),
        DailyForecast(day: 'Tue', icon: 'wb_sunny', minTemp: 17, maxTemp: 25, rangeStart: 0.4, rangeEnd: 0.9),
        DailyForecast(day: 'Wed', icon: 'wb_sunny', minTemp: 19, maxTemp: 27, rangeStart: 0.5, rangeEnd: 1.0),
        DailyForecast(day: 'Thu', icon: 'cloud', minTemp: 18, maxTemp: 24, rangeStart: 0.4, rangeEnd: 0.8),
        DailyForecast(day: 'Fri', icon: 'thunderstorm', minTemp: 15, maxTemp: 21, rangeStart: 0.2, rangeEnd: 0.6),
        DailyForecast(day: 'Sat', icon: 'partly_cloudy_day', minTemp: 16, maxTemp: 23, rangeStart: 0.3, rangeEnd: 0.7),
      ],
      aqi: 54,
      aqiDesc: 'Moderate',
      aqiLongDesc: 'Acceptable air quality. Some sensitivity for groups.',
      windSpeed: 12.0,
      windDir: 'Southeast',
      windAngle: 135.0,
      humidity: 62,
      humidityDesc: 'Slightly sticky but manageable.',
      visibility: 10,
      visibilityDesc: 'Excellent clear visibility.',
      sunrise: '5:24 AM',
      sunset: '8:30 PM',
      moonrise: '11:02 PM',
      moonPhase: 'Waxing Gibbous',
    );
  }

  WeatherData _createTokyoData() {
    return WeatherData(
      cityName: 'Tokyo',
      temp: 28,
      condition: 'Sunny',
      feelsLike: 31,
      imageUrl: 'https://images.unsplash.com/photo-1540959733332-eab4deceeaf7?q=80&w=1000',
      hourly: [
        HourlyForecast(hour: 'Now', icon: 'wb_sunny', temp: 28, pop: '0%'),
        HourlyForecast(hour: '2PM', icon: 'wb_sunny', temp: 29, pop: '0%'),
        HourlyForecast(hour: '3PM', icon: 'wb_sunny', temp: 29, pop: '0%'),
        HourlyForecast(hour: '4PM', icon: 'wb_sunny', temp: 28, pop: '0%'),
        HourlyForecast(hour: '5PM', icon: 'partly_cloudy_day', temp: 27, pop: '5%'),
        HourlyForecast(hour: '6PM', icon: 'partly_cloudy_day', temp: 25, pop: '10%'),
        HourlyForecast(hour: '7PM', icon: 'cloud', temp: 24, pop: '15%'),
        HourlyForecast(hour: '8PM', icon: 'cloud', temp: 23, pop: '20%'),
      ],
      daily: [
        DailyForecast(day: 'Today', icon: 'wb_sunny', minTemp: 23, maxTemp: 29, rangeStart: 0.5, rangeEnd: 0.9),
        DailyForecast(day: 'Mon', icon: 'wb_sunny', minTemp: 24, maxTemp: 30, rangeStart: 0.6, rangeEnd: 1.0),
        DailyForecast(day: 'Tue', icon: 'partly_cloudy_day', minTemp: 22, maxTemp: 28, rangeStart: 0.4, rangeEnd: 0.8),
        DailyForecast(day: 'Wed', icon: 'cloud', minTemp: 21, maxTemp: 26, rangeStart: 0.3, rangeEnd: 0.7),
        DailyForecast(day: 'Thu', icon: 'rainy', minTemp: 20, maxTemp: 25, rangeStart: 0.2, rangeEnd: 0.6),
        DailyForecast(day: 'Fri', icon: 'rainy', minTemp: 19, maxTemp: 24, rangeStart: 0.1, rangeEnd: 0.5),
        DailyForecast(day: 'Sat', icon: 'cloud', minTemp: 21, maxTemp: 27, rangeStart: 0.3, rangeEnd: 0.7),
      ],
      aqi: 45,
      aqiDesc: 'Good',
      aqiLongDesc: 'Air quality is satisfactory.',
      windSpeed: 8.0,
      windDir: 'North',
      windAngle: 0.0,
      humidity: 50,
      humidityDesc: 'Comfortable dry air.',
      visibility: 12,
      visibilityDesc: 'Crystal clear view.',
      sunrise: '4:26 AM',
      sunset: '6:57 PM',
      moonrise: '8:50 PM',
      moonPhase: 'Full Moon',
    );
  }

  WeatherData _createParisData() {
    return WeatherData(
      cityName: 'Paris',
      temp: 18,
      condition: 'Thunderstorm',
      feelsLike: 18,
      imageUrl: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=1000',
      hourly: [
        HourlyForecast(hour: 'Now', icon: 'thunderstorm', temp: 18, pop: '95%'),
        HourlyForecast(hour: '2PM', icon: 'thunderstorm', temp: 18, pop: '90%'),
        HourlyForecast(hour: '3PM', icon: 'rainy', temp: 17, pop: '80%'),
        HourlyForecast(hour: '4PM', icon: 'rainy', temp: 17, pop: '70%'),
        HourlyForecast(hour: '5PM', icon: 'cloud', temp: 16, pop: '40%'),
        HourlyForecast(hour: '6PM', icon: 'partly_cloudy_day', temp: 16, pop: '20%'),
        HourlyForecast(hour: '7PM', icon: 'wb_sunny', temp: 15, pop: '10%'),
        HourlyForecast(hour: '8PM', icon: 'wb_sunny', temp: 14, pop: '0%'),
      ],
      daily: [
        DailyForecast(day: 'Today', icon: 'thunderstorm', minTemp: 14, maxTemp: 18, rangeStart: 0.2, rangeEnd: 0.5),
        DailyForecast(day: 'Mon', icon: 'rainy', minTemp: 13, maxTemp: 17, rangeStart: 0.1, rangeEnd: 0.4),
        DailyForecast(day: 'Tue', icon: 'cloud', minTemp: 12, maxTemp: 18, rangeStart: 0.1, rangeEnd: 0.5),
        DailyForecast(day: 'Wed', icon: 'partly_cloudy_day', minTemp: 14, maxTemp: 20, rangeStart: 0.2, rangeEnd: 0.7),
        DailyForecast(day: 'Thu', icon: 'wb_sunny', minTemp: 15, maxTemp: 22, rangeStart: 0.3, rangeEnd: 0.8),
        DailyForecast(day: 'Fri', icon: 'wb_sunny', minTemp: 16, maxTemp: 24, rangeStart: 0.4, rangeEnd: 0.9),
        DailyForecast(day: 'Sat', icon: 'wb_sunny', minTemp: 17, maxTemp: 26, rangeStart: 0.5, rangeEnd: 1.0),
      ],
      aqi: 22,
      aqiDesc: 'Good',
      aqiLongDesc: 'Storm winds cleared pollutants.',
      windSpeed: 30.0,
      windDir: 'Northeast',
      windAngle: 45.0,
      humidity: 82,
      humidityDesc: 'High dampness in the air.',
      visibility: 6,
      visibilityDesc: 'Hazy during storm downpours.',
      sunrise: '5:47 AM',
      sunset: '9:52 PM',
      moonrise: '11:30 PM',
      moonPhase: 'Waning Gibbous',
    );
  }
}
