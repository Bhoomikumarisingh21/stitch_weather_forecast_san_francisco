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

class LocationService {
  static final Set<String> _validLocations = {
    // 195 countries
    'afghanistan', 'albania', 'algeria', 'andorra', 'angola', 'antigua and barbuda', 'argentina', 'armenia', 'australia', 'austria', 'azerbaijan', 'bahamas', 'bahrain', 'bangladesh', 'barbados', 'belarus', 'belgium', 'belize', 'benin', 'bhutan', 'bolivia', 'bosnia and herzegovina', 'botswana', 'brazil', 'brunei', 'bulgaria', 'burkina faso', 'burundi', 'cabo verde', 'cambodia', 'cameroon', 'canada', 'central african republic', 'chad', 'chile', 'china', 'colombia', 'comoros', 'congo', 'costa rica', 'croatia', 'cuba', 'cyprus', 'czechia', 'czech republic', 'denmark', 'djibouti', 'dominica', 'dominican republic', 'east timor', 'timor-leste', 'ecuador', 'egypt', 'el salvador', 'equatorial guinea', 'eritrea', 'estonia', 'eswatini', 'swaziland', 'ethiopia', 'fiji', 'finland', 'france', 'gabon', 'gambia', 'georgia', 'germany', 'ghana', 'greece', 'grenada', 'guatemala', 'guinea', 'guinea-bissau', 'guyana', 'haiti', 'honduras', 'hungary', 'iceland', 'india', 'indonesia', 'iran', 'iraq', 'ireland', 'israel', 'italy', 'ivory coast', "côte d'ivoire", 'jamaica', 'japan', 'jordan', 'kazakhstan', 'kenya', 'kiribati', 'north korea', 'south korea', 'kosovo', 'kuwait', 'kyrgyzstan', 'laos', 'latvia', 'lebanon', 'lesotho', 'liberia', 'libya', 'liechtenstein', 'lithuania', 'luxembourg', 'madagascar', 'malawi', 'malaysia', 'maldives', 'mali', 'malta', 'marshall islands', 'mauritania', 'mauritius', 'mexico', 'micronesia', 'moldova', 'monaco', 'mongolia', 'montenegro', 'morocco', 'mozambique', 'myanmar', 'namibia', 'nauru', 'nepal', 'netherlands', 'new zealand', 'nicaragua', 'niger', 'nigeria', 'north macedonia', 'norway', 'oman', 'pakistan', 'palau', 'palestine', 'panama', 'papua new guinea', 'paraguay', 'peru', 'philippines', 'poland', 'portugal', 'qatar', 'romania', 'russia', 'rwanda', 'saint kitts and nevis', 'saint lucia', 'saint vincent and the grenadines', 'samoa', 'san marino', 'sao tome and principe', 'saudi arabia', 'senegal', 'serbia', 'seychelles', 'sierra leone', 'singapore', 'slovakia', 'slovenia', 'solomon islands', 'somalia', 'south africa', 'south sudan', 'spain', 'sri lanka', 'sudan', 'suriname', 'sweden', 'switzerland', 'syria', 'taiwan', 'tajikistan', 'tanzania', 'thailand', 'togo', 'tonga', 'trinidad and tobago', 'tunisia', 'turkey', 'turkmenistan', 'tuvalu', 'uganda', 'ukraine', 'united arab emirates', 'uae', 'united kingdom', 'uk', 'united states', 'usa', 'uruguay', 'uzbekistan', 'vanuatu', 'vatican city', 'venezuela', 'vietnam', 'yemen', 'zambia', 'zimbabwe',

    // Capitals
    'kabul', 'tirana', 'algiers', 'andorra la vella', 'luanda', "st. john's", 'buenos aires', 'yerevan', 'canberra', 'vienna', 'baku', 'nassau', 'manama', 'dhaka', 'bridgetown', 'minsk', 'brussels', 'belmopan', 'porto-novo', 'thimphu', 'sucre', 'sarajevo', 'gaborone', 'brasilia', 'bandar seri begawan', 'sofia', 'ouagadougou', 'gitega', 'praia', 'phnom penh', 'yaounde', 'ottawa', 'bangui', "n'djamena", 'santiago', 'beijing', 'bogota', 'moroni', 'brazzaville', 'kinshasa', 'san jose', 'zagreb', 'havana', 'nicosia', 'prague', 'copenhagen', 'djibouti', 'roseau', 'santo domingo', 'dili', 'quito', 'cairo', 'san salvador', 'malabo', 'asmara', 'tallinn', 'mbabane', 'addis ababa', 'suva', 'helsinki', 'paris', 'libreville', 'banjul', 'tbilisi', 'berlin', 'accra', 'athens', "st. george's", 'guatemala city', 'conakry', 'bissau', 'georgetown', 'port-au-prince', 'tegucigalpa', 'budapest', 'reykjavik', 'new delhi', 'jakarta', 'tehran', 'baghdad', 'dublin', 'jerusalem', 'rome', 'yamoussoukro', 'kingston', 'tokyo', 'amman', 'astana', 'nairobi', 'tarawa', 'pyongyang', 'seoul', 'pristina', 'kuwait city', 'bishkek', 'vientiane', 'riga', 'beirut', 'maseru', 'monrovia', 'tripoli', 'vaduz', 'vilnius', 'luxembourg', 'antananarivo', 'lilongwe', 'kuala lumpur', 'male', 'bamako', 'valletta', 'majuro', 'nouakchott', 'port louis', 'mexico city', 'palikir', 'chisinau', 'monaco', 'ulaanbaatar', 'podgorica', 'rabat', 'maputo', 'naypyidaw', 'windhoek', 'yaren', 'kathmandu', 'amsterdam', 'wellington', 'managua', 'niamey', 'abuja', 'skopje', 'oslo', 'muscat', 'islamabad', 'ngerulmud', 'east jerusalem', 'panama city', 'port moresby', 'asuncion', 'lima', 'manila', 'warsaw', 'lisbon', 'doha', 'bucharest', 'moscow', 'kigali', 'basseterre', 'castries', 'kingstown', 'apia', 'san marino', 'sao tome', 'riyadh', 'dakar', 'belgrade', 'victoria', 'freetown', 'singapore', 'bratislava', 'ljubljana', 'honiara', 'mogadishu', 'pretoria', 'bloemfontein', 'cape town', 'juba', 'madrid', 'sri jayawardenepura kotte', 'colombo', 'khartoum', 'paramaribo', 'stockholm', 'bern', 'damascus', 'taipei', 'dushanbe', 'dodoma', 'bangkok', 'lome', "nuku'alofa", 'port of spain', 'tunis', 'ankara', 'ashgabat', 'funafuti', 'kampala', 'kyiv', 'abu dhabi', 'london', 'washington', 'montevideo', 'tashkent', 'port vila', 'vatican city', 'caracas', 'hanoi', "sana'a", 'lusaka', 'harare',

    // Indian States & Union Territories
    'andhra pradesh', 'arunachal pradesh', 'assam', 'bihar', 'chhattisgarh', 'goa', 'gujarat', 'haryana', 'himachal pradesh', 'jharkhand', 'karnataka', 'kerala', 'madhya pradesh', 'maharashtra', 'manipur', 'meghalaya', 'mizoram', 'nagaland', 'odisha', 'punjab', 'rajasthan', 'sikkim', 'tamil nadu', 'telangana', 'tripura', 'uttarakhand', 'uttar pradesh', 'west bengal', 'andaman and nicobar islands', 'chandigarh', 'dadra and nagar haveli and daman and diu', 'lakshadweep', 'delhi', 'puducherry', 'jammu and kashmir', 'ladakh',

    // Major Indian Cities
    'mumbai', 'pune', 'nagpur', 'nashik', 'aurangabad', 'navi mumbai', 'thane', 'kalyan', 'dombivli', 'vasai', 'virar', 'kolkata', 'howrah', 'durgapur', 'asansol', 'siliguri', 'chennai', 'coimbatore', 'madurai', 'tiruchirappalli', 'salem', 'bengaluru', 'bangalore', 'mysore', 'hubli', 'dharwad', 'mangalore', 'belgaum', 'hyderabad', 'warangal', 'nizamabad', 'karimnagar', 'visakhapatnam', 'vijayawada', 'guntur', 'nellore', 'kurnool', 'tirupati', 'ahmedabad', 'surat', 'vadodara', 'rajkot', 'bhavnagar', 'jamnagar', 'jaipur', 'jodhpur', 'kota', 'bikaner', 'ajmer', 'udaipur', 'bhopal', 'indore', 'jabalpur', 'gwalior', 'ujjain', 'raipur', 'bilaspur', 'durg', 'patna', 'gaya', 'bhagalpur', 'muzaffarpur', 'ranchi', 'jamshedpur', 'dhanbad', 'bokaro', 'bhubaneswar', 'cuttack', 'rourkela', 'puri', 'lucknow', 'kanpur', 'ghaziabad', 'agra', 'meerut', 'varanasi', 'prayagraj', 'allahabad', 'noida', 'greater noida', 'bareilly', 'aligarh', 'moradabad', 'gorakhpur', 'jhansi', 'dehradun', 'haridwar', 'rishikesh', 'haldwani', 'shimla', 'dharamshala', 'solan', 'amritsar', 'ludhiana', 'jalandhar', 'patiala', 'bathinda', 'srinagar', 'jammu', 'leh', 'kargil', 'guwahati', 'silchar', 'dibrugarh', 'jorhat', 'itanagar', 'shillong', 'tura', 'imphal', 'kohima', 'dimapur', 'aizawl', 'agartala', 'gangtok', 'panaji', 'margao', 'vasco da gama', 'port blair', 'kavaratti', 'daman', 'diu', 'silvassa', 'karaikal', 'mahe', 'yanam',

    // US States
    'alabama', 'alaska', 'arizona', 'arkansas', 'california', 'colorado', 'connecticut', 'delaware', 'florida', 'georgia', 'hawaii', 'idaho', 'illinois', 'indiana', 'iowa', 'kansas', 'kentucky', 'louisiana', 'maine', 'maryland', 'massachusetts', 'michigan', 'minnesota', 'mississippi', 'missouri', 'montana', 'nebraska', 'nevada', 'new hampshire', 'new jersey', 'new mexico', 'new york', 'north carolina', 'north dakota', 'ohio', 'oklahoma', 'oregon', 'pennsylvania', 'rhode island', 'south carolina', 'south dakota', 'tennessee', 'texas', 'utah', 'vermont', 'virginia', 'washington', 'west virginia', 'wisconsin', 'wyoming',

    // US Cities
    'los angeles', 'chicago', 'houston', 'phoenix', 'philadelphia', 'san antonio', 'san diego', 'dallas', 'san jose', 'austin', 'jacksonville', 'fort worth', 'columbus', 'charlotte', 'indianapolis', 'san francisco', 'seattle', 'denver', 'boston', 'el paso', 'nashville', 'detroit', 'oklahoma city', 'portland', 'las vegas', 'memphis', 'louisville', 'baltimore', 'milwaukee', 'albuquerque', 'tucson', 'fresno', 'sacramento', 'mesa', 'atlanta', 'kansas city', 'colorado springs', 'miami', 'raleigh', 'omaha', 'oakland', 'minneapolis', 'tulsa', 'wichita', 'new orleans', 'arlington', 'cleveland', 'bakersfield', 'tampa', 'honolulu', 'aurora', 'anaheim', 'santa ana', 'riverside', 'corpus christi', 'lexington', 'stockton', 'henderson', 'saint paul', "st. louis", 'st louis', 'cincinnati', 'pittsburgh', 'anchorage', 'greensboro', 'plano', 'newark', 'lincoln', 'orlando', 'irvine', 'toledo', 'jersey city', 'chula vista', 'durham', 'fort wayne', 'st. petersburg', 'st petersburg', 'laredo', 'lubbock', 'madison', 'chandler', 'buffalo', 'norfolk', 'glendale', 'reno', 'winston-salem', 'winston salem', 'hialeah', 'garland', 'chesapeake', 'irving', 'north las vegas', 'scottsdale', 'baton rouge', 'fremont', 'gilbert', 'san bernardino', 'boise', 'birmingham', 'chelsea', 'charlotte',

    // Europe Major Cities
    'berlin', 'madrid', 'rome', 'vienna', 'amsterdam', 'brussels', 'geneva', 'zurich', 'copenhagen', 'oslo', 'stockholm', 'helsinki', 'lisbon', 'dublin', 'athens', 'istanbul', 'warsaw', 'prague', 'budapest', 'munich', 'frankfurt', 'milan', 'barcelona', 'venice', 'florence', 'sofia', 'hamburg', 'lyon', 'marseille', 'birmingham', 'manchester', 'glasgow', 'seville', 'valencia', 'st. petersburg', 'kiev', 'bucharest',

    // Asia Major Cities
    'shanghai', 'shenzhen', 'guangzhou', 'hong kong', 'taipei', 'singapore', 'bangkok', 'kuala lumpur', 'manila', 'hanoi', 'ho chi minh city', 'dubai', 'abu dhabi', 'riyadh', 'jeddah', 'doha', 'tel aviv', 'jerusalem', 'colombo', 'kathmandu', 'karachi', 'lahore', 'dhaka', 'osaka', 'nagoya', 'kyoto', 'yokohama', 'incheon', 'busan', 'almaty', 'tashkent', "xi'an",

    // Africa Major Cities
    'johannesburg', 'cape town', 'nairobi', 'lagos', 'casablanca', 'marrakech', 'addis ababa', 'accra', 'dakar', 'luanda', 'algiers', 'tunis', 'alexandria', 'giza', 'khartoum', 'dar es salaam', 'abidjan', 'kampala',

    // Australia and Oceania Major Cities
    'melbourne', 'brisbane', 'perth', 'adelaide', 'hobart', 'darwin', 'auckland', 'wellington', 'christchurch', 'suva', 'port moresby', 'noumea', 'sydney',

    // South America Major Cities
    'sao paulo', 'são paulo', 'rio de janeiro', 'santiago', 'lima', 'bogota', 'bogotá', 'caracas', 'quito', 'montevideo', 'asuncion', 'asunción', 'la paz', 'medellin', 'medellín', 'cali',

    // North America Major Cities
    'toronto', 'vancouver', 'montreal', 'havana', 'san jose', 'guatemala city', 'tegucigalpa', 'san salvador', 'kingston', 'santo domingo'
  };

  static final Set<String> _commonNames = {
    // First names & surnames (common Indian & Western)
    'bhoomi', 'kumari', 'singh',
    'rahul', 'john', 'priya', 'amit', 'alex', 'david', 'sarah', 'emily', 'james', 'michael', 'robert', 'mary', 'jennifer', 'linda', 'elizabeth', 'william', 'joseph', 'thomas', 'charles', 'christopher', 'daniel', 'matthew', 'anthony', 'mark', 'donald', 'steven', 'paul', 'andrew', 'joshua', 'kenneth', 'kevin', 'brian', 'george', 'edward', 'ronald', 'timothy', 'jason', 'jeffrey', 'ryan', 'jacob', 'gary', 'nicholas', 'eric', 'jonathan', 'stephen', 'larry', 'justin', 'scott', 'brandon', 'benjamin', 'samuel', 'gregory', 'frank', 'alexander', 'raymond', 'patrick', 'jack', 'dennis', 'jerry', 'tyler', 'aaron', 'jose', 'adam', 'nathan', 'henry', 'douglas', 'zachary', 'peter', 'kyle', 'walter', 'harold', 'jeremy', 'ethan', 'carl', 'keith', 'roger', 'gerald', 'christian', 'terry', 'sean', 'arthur', 'austin', 'noah', 'lawrence', 'jesse', 'rohan', 'sunita', 'anil', 'geeta', 'sanjay', 'vijay', 'deepak', 'rajesh', 'karan', 'sneha', 'kriti', 'pooja', 'vikram', 'aditya', 'neha', 'divya', 'ravi', 'aarav', 'kabir', 'vihaan', 'reyansh', 'sai', 'arjun', 'ananya', 'aishwarya', 'siddharth', 'varun', 'isha', 'riya', 'alia', 'sara', 'riyah', 'diya', 'abhishek', 'sandeep', 'manish', 'vivek', 'shalini', 'rashmi', 'preeti', 'kiran', 'meena', 'anjali', 'swati', 'tanvi', 'kavita', 'babita', 'nisha', 'ritesh', 'ashish', 'sumit', 'sunil', 'harish', 'manoj', 'ajay', 'ramesh', 'suresh', 'mahesh', 'dinesh', 'naresh', 'vinod', 'pramod', 'pradeep', 'pankaj', 'atul', 'deepika', 'priyanka', 'katrina', 'kareena', 'ranbir', 'ranveer', 'salman', 'shahrukh', 'aamir', 'hrithik', 'akshay', 'sidharth', 'raj', 'tina', 'simran', 'smith', 'johnson', 'williams', 'brown', 'jones', 'miller', 'davis', 'garcia', 'rodriguez', 'wilson', 'martinez', 'anderson', 'taylor', 'hernandez', 'moore', 'martin', 'jackson', 'thompson', 'white', 'lopez', 'lee', 'gonzalez', 'harris', 'clark', 'lewis', 'robinson', 'walker', 'perez', 'hall', 'young', 'allen', 'sanchez', 'wright', 'king', 'green', 'baker', 'adams', 'nelson', 'hill', 'ramirez', 'campbell', 'mitchell', 'roberts', 'carter', 'phillips', 'evans', 'turner', 'torres', 'parker', 'collins', 'edwards', 'stewart', 'flores', 'morris', 'nguyen', 'murphy', 'rivera', 'cook', 'rogers', 'morgan', 'peterson', 'cooper', 'reed', 'bailey', 'bell', 'gomez', 'kelly', 'howard', 'ward', 'cox', 'diaz', 'richardson', 'wood', 'watson', 'brooks', 'bennett', 'gray', 'reyes', 'cruz', 'hughes', 'price', 'myers', 'long', 'foster', 'sanders', 'ross', 'morales', 'powell', 'sullivan', 'russell', 'ortiz', 'jenkins', 'gutierrez', 'perry', 'butler', 'barnes', 'fisher'
  };

  static String normalizeLocationName(String location) {
    final cleaned = location.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (cleaned.isEmpty) return '';
    return cleaned.split(' ').map((word) {
      if (word.isEmpty) return '';
      final lower = word.toLowerCase();
      if (lower == 'usa' || lower == 'uk' || lower == 'uae') {
        return word.toUpperCase();
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  static bool isValid(String location) {
    // 1. Normalize the input
    final trimmed = location.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (trimmed.isEmpty) return false;
    final lower = trimmed.toLowerCase();

    // 2. Check allow list
    if (_validLocations.contains(lower)) {
      return true;
    }

    // 3. Check block list
    if (_commonNames.contains(lower)) {
      return false;
    }
    final words = lower.split(RegExp(r"[\s,\-\.\'\(\)]+")).where((w) => w.isNotEmpty).toList();
    for (var word in words) {
      if (_commonNames.contains(word)) {
        return false;
      }
    }

    // 4. Perform character validation (using exclusion strategy)
    if (RegExp(r'\d').hasMatch(trimmed)) return false;
    final disallowedPattern = RegExp(r'[0-9@!#\$%^&\*_+=\[\]{}|\\\/;:"<>?`~]');
    if (disallowedPattern.hasMatch(trimmed)) return false;

    if (trimmed.length < 2 || trimmed.length > 50) return false;

    // 5. Detect obvious keyboard patterns and gibberish
    final gibberishPatterns = ['qwerty', 'asdfgh', 'zxcvbn', 'qwert', 'asdf', 'yuiop', 'hjkl', 'bnm'];
    for (var pat in gibberishPatterns) {
      if (lower.contains(pat)) {
        return false;
      }
    }

    if (RegExp(r'(.)\1{4,}').hasMatch(trimmed)) return false;

    // Must contain some letters (not purely punctuation symbols)
    final onlyPunctuation = RegExp(r"^[\s,\-\.\'\(\)]+$");
    if (onlyPunctuation.hasMatch(trimmed)) return false;

    return true;
  }
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
      (c) => LocationService.normalizeLocationName(c.cityName).toLowerCase() == 
             LocationService.normalizeLocationName(data.cityName).toLowerCase()
    );
    if (existingIndex != -1) {
      _selectedCityIndex = existingIndex;
    } else {
      _cities.add(data);
      _selectedCityIndex = _cities.length - 1;
    }
    notifyListeners();
  }

  Future<WeatherData> fetchWeather(
    String cityName, {
    required double temp,
    required String condition,
  }) async {
    // 1. Normalize input
    final trimmedCity = cityName.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (trimmedCity.isEmpty) {
      throw Exception("Please enter a valid city or location.");
    }
    final normalizedName = LocationService.normalizeLocationName(trimmedCity);

    // 2. Check duplicate locations
    final alreadyExists = _cities.any((c) =>
      LocationService.normalizeLocationName(c.cityName).toLowerCase() == normalizedName.toLowerCase()
    );
    if (alreadyExists) {
      throw Exception("This location has already been added.");
    }

    // 3. Perform other validation (allow list, block list, etc.)
    if (!LocationService.isValid(trimmedCity)) {
      throw Exception("Please enter a valid city or location.");
    }

    // Simulate network call latency
    await Future.delayed(const Duration(milliseconds: 600));

    // 4. Validate API response
    if (normalizedName.isEmpty || !LocationService.isValid(normalizedName)) {
      throw Exception("Please enter a valid city or location.");
    }

    return WeatherData(
      cityName: normalizedName,
      temp: temp.toInt(),
      condition: condition,
      feelsLike: temp.toInt() - 2,
      imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?q=80&w=1000',
      hourly: [
        HourlyForecast(hour: 'Now', icon: condition.toLowerCase(), temp: temp.toInt(), pop: '80%'),
        HourlyForecast(hour: '3PM', icon: condition.toLowerCase(), temp: temp.toInt() - 1, pop: '60%'),
        HourlyForecast(hour: '6PM', icon: 'cloud', temp: temp.toInt() - 2, pop: '40%'),
        HourlyForecast(hour: '9PM', icon: 'cloud', temp: temp.toInt() - 3, pop: '20%'),
      ],
      daily: [
        DailyForecast(day: 'Today', icon: condition.toLowerCase(), minTemp: temp.toInt() - 4, maxTemp: temp.toInt() + 2, rangeStart: 0.2, rangeEnd: 0.6),
        DailyForecast(day: 'Mon', icon: 'cloud', minTemp: temp.toInt() - 5, maxTemp: temp.toInt() + 1, rangeStart: 0.1, rangeEnd: 0.5),
        DailyForecast(day: 'Tue', icon: 'wb_sunny', minTemp: temp.toInt() - 3, maxTemp: temp.toInt() + 3, rangeStart: 0.3, rangeEnd: 0.8),
      ],
      aqi: 25,
      aqiDesc: 'Good',
      aqiLongDesc: 'Air quality index is safe.',
      windSpeed: 15.0,
      windDir: 'West',
      windAngle: 270.0,
      humidity: 70,
      humidityDesc: 'Moderate humidity.',
      visibility: 10,
      visibilityDesc: 'Normal clear visibility.',
      sunrise: '6:00 AM',
      sunset: '8:00 PM',
      moonrise: '9:00 PM',
      moonPhase: 'Waxing Crescent',
    );
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
