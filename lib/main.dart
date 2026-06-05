import 'package:flutter/material.dart';
import 'theme.dart';
import 'weather_model.dart';
import 'weather_home_screen.dart';
import 'weather_map_screen.dart';
import 'city_list_screen.dart';
import 'settings_screen.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final WeatherStore _store = WeatherStore();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _store,
      builder: (context, child) {
        // Dynamic theme customization based on active theme index
        ThemeData themeData;
        if (_store.activeThemeIndex == 0) {
          // Rainy Gray
          themeData = ThemeData.dark().copyWith(
            scaffoldBackgroundColor: AppColors.background,
            primaryColor: AppColors.primary,
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: AppColors.onPrimary,
              surface: AppColors.surface,
              onSurface: AppColors.onSurface,
            ),
          );
        } else if (_store.activeThemeIndex == 1) {
          // Sunset Gold
          themeData = ThemeData.dark().copyWith(
            scaffoldBackgroundColor: const Color(0xFF161113),
            primaryColor: Colors.amberAccent,
            colorScheme: const ColorScheme.dark(
              primary: Colors.amber,
              onPrimary: Colors.black,
              surface: Color(0xFF1E1A23),
              onSurface: Color(0xFFFBE9E7),
            ),
          );
        } else {
          // Deep Dark
          themeData = ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
            primaryColor: Colors.white,
            colorScheme: const ColorScheme.dark(
              primary: Colors.white,
              onPrimary: Colors.black,
              surface: Color(0xFF0F0F0F),
              onSurface: Colors.white,
            ),
          );
        }

        return MaterialApp(
          title: 'Atmospheric Precision',
          debugShowCheckedModeBanner: false,
          theme: themeData,
          home: MainNavigationScaffold(store: _store),
        );
      },
    );
  }
}

class MainNavigationScaffold extends StatefulWidget {
  final WeatherStore store;

  const MainNavigationScaffold({
    super.key,
    required this.store,
  });

  @override
  State<MainNavigationScaffold> createState() => _MainNavigationScaffoldState();
}

class _MainNavigationScaffoldState extends State<MainNavigationScaffold> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Get dynamic background image based on selected theme and city weather
  String _getBackgroundImage() {
    if (widget.store.activeThemeIndex == 1) {
      // Sunset Gold
      return 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?q=80&w=1000';
    } else if (widget.store.activeThemeIndex == 2) {
      // Deep Dark
      return 'https://images.unsplash.com/photo-1506318137071-a8e063b4bec0?q=80&w=1000';
    } else {
      // Rainy Gray (Default) -> Load dynamic images based on active city
      return widget.store.current.imageUrl;
    }
  }

  // Helper to resolve title of the screen
  String _getScreenTitle() {
    switch (_currentIndex) {
      case 0:
        return widget.store.current.cityName;
      case 1:
        return 'Radar Map';
      case 2:
        return 'Locations';
      case 3:
        return 'Settings';
      default:
        return 'Weather';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      WeatherHomeScreen(store: widget.store),
      WeatherMapScreen(store: widget.store),
      CityListScreen(
        store: widget.store,
        onCitySelected: (index) {
          setState(() {
            _currentIndex = 0;
          });
        },
      ),
      SettingsScreen(store: widget.store),
    ];

    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, child) {
        return Scaffold(
          key: _scaffoldKey,
          drawer: _buildDrawer(),
          body: Stack(
            children: [
              // 1. Fixed Hero Background Image Layer
              Positioned.fill(
                child: Image.network(
                  _getBackgroundImage(),
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.55),
                  colorBlendMode: BlendMode.darken,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    // Fallback gradient while loading
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.surfaceContainerLowest,
                            AppColors.background,
                          ],
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback gradient on error
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.surfaceContainerLowest,
                            AppColors.background,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        AppColors.background.withOpacity(0.6),
                        AppColors.background,
                      ],
                    ),
                  ),
                ),
              ),

              // 2. Active Screen Content
              Positioned.fill(
                child: SafeArea(
                  top: false, // Top app bar handles safety
                  bottom: false,
                  child: IndexedStack(
                    index: _currentIndex,
                    children: screens,
                  ),
                ),
              ),

              // 3. Top App Bar (Floating Glassmorphism)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildTopAppBar(),
              ),

              // 4. Bottom Navigation Bar (Floating Glassmorphism)
              Positioned(
                bottom: 16.0,
                left: 16.0,
                right: 16.0,
                child: _buildBottomNavigationBar(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      height: 70.0 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: AppSpacing.marginMobile,
        right: AppSpacing.marginMobile,
      ),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.15),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF8C9195).withOpacity(0.1),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: AppColors.primary),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              const SizedBox(width: 8.0),
              Text(
                _getScreenTitle(),
                style: AppTypography.headlineLargeMobile.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.onSurfaceVariant),
            onPressed: () {
              // Quick jump to Locations list screen
              setState(() {
                _currentIndex = 2;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return GlassContainer(
      borderRadius: BorderRadius.circular(24.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.umbrella, 'Weather'),
          _buildNavItem(1, Icons.map_outlined, 'Radar'),
          _buildNavItem(2, Icons.list, 'Cities'),
          _buildNavItem(3, Icons.settings_outlined, 'Settings'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String tooltip) {
    final isSelected = _currentIndex == index;
    final primaryColor = widget.store.activeThemeIndex == 1
        ? Colors.amberAccent
        : (widget.store.activeThemeIndex == 2 ? Colors.white : AppColors.primary);

    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Icon(
            icon,
            color: isSelected ? primaryColor : AppColors.onSurfaceVariant,
            size: 26.0,
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.background.withOpacity(0.95),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: AppColors.outline.withOpacity(0.2),
              width: 1.0,
            ),
          ),
        ),
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest.withOpacity(0.5),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloudy_snowing,
                      size: 48.0,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      'Atmospheric Precision',
                      style: AppTypography.headlineLargeMobile.copyWith(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.umbrella, color: AppColors.primary),
              title: const Text('Weather Forecast'),
              selected: _currentIndex == 0,
              onTap: () {
                setState(() => _currentIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.map_outlined, color: AppColors.primary),
              title: const Text('Weather Radar Map'),
              selected: _currentIndex == 1,
              onTap: () {
                setState(() => _currentIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list, color: AppColors.primary),
              title: const Text('City Management'),
              selected: _currentIndex == 2,
              onTap: () {
                setState(() => _currentIndex = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined, color: AppColors.primary),
              title: const Text('System Settings'),
              selected: _currentIndex == 3,
              onTap: () {
                setState(() => _currentIndex = 3);
                Navigator.pop(context);
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                'v1.0.0 • Google DeepMind Antigravity',
                style: AppTypography.labelSmall.copyWith(fontSize: 9.0, color: AppColors.outline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
