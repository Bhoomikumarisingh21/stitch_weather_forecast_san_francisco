import 'dart:math';
import 'package:flutter/material.dart';
import 'theme.dart';
import 'weather_model.dart';

class WeatherHomeScreen extends StatelessWidget {
  final WeatherStore store;

  const WeatherHomeScreen({
    super.key,
    required this.store,
  });

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'rainy':
        return Icons.umbrella;
      case 'thunderstorm':
        return Icons.thunderstorm;
      case 'cloud':
        return Icons.cloud;
      case 'partly_cloudy_day':
        return Icons.wb_cloudy_outlined;
      case 'wb_sunny':
        return Icons.wb_sunny;
      default:
        return Icons.cloud;
    }
  }

  @override
  Widget build(BuildContext context) {
    final weather = store.current;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: AppSpacing.marginMobile,
        right: AppSpacing.marginMobile,
        top: 80.0, // top spacing for status bar + logo/top-bar space
        bottom: 110.0, // bottom padding to clear the navigation bar
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Primary Condition Block
          _buildPrimaryConditionBlock(weather),
          const SizedBox(height: AppSpacing.md),

          // 2. Hourly Forecast List
          _buildHourlyForecastSection(weather),
          const SizedBox(height: AppSpacing.md),

          // 3. Daily Forecast (Next 7 Days)
          _buildDailyForecastSection(weather),
          const SizedBox(height: AppSpacing.md),

          // 4. Details Grid (2x2)
          _buildDetailsGrid(weather),
          const SizedBox(height: AppSpacing.md),

          // 5. Sun & Moon Visualization
          _buildSunMoonSection(weather),
        ],
      ),
    );
  }

  Widget _buildPrimaryConditionBlock(WeatherData weather) {
    return Column(
      children: [
        const SizedBox(height: 20.0),
        Icon(
          _getIconData(weather.condition),
          size: 96,
          color: AppColors.primary,
        ),
        const SizedBox(height: 12.0),
        Text(
          '${store.convertTemp(weather.temp)}${store.tempUnitSymbol}',
          style: AppTypography.displayTemp,
        ),
        Text(
          weather.condition,
          style: AppTypography.headlineLarge,
        ),
        const SizedBox(height: 4.0),
        Text(
          'Feels like ${store.convertTemp(weather.feelsLike)}${store.tempUnitSymbol}',
          style: AppTypography.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildHourlyForecastSection(WeatherData weather) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'HOURLY FORECAST',
                style: AppTypography.labelSmall.copyWith(
                  letterSpacing: 2.0,
                ),
              ),
              Text(
                '24 Hours',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          height: 120.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: weather.hourly.length,
            itemBuilder: (context, index) {
              final hourly = weather.hourly[index];
              final isNow = index == 0;

              return Container(
                margin: const EdgeInsets.only(right: 12.0),
                child: GlassContainer(
                  width: 80.0,
                  borderRadius: BorderRadius.circular(16.0),
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  highElevation: isNow,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        hourly.hour,
                        style: isNow 
                            ? AppTypography.labelSmall.copyWith(color: AppColors.onSurface)
                            : AppTypography.labelSmall,
                      ),
                      Icon(
                        _getIconData(hourly.icon),
                        color: isNow ? AppColors.primary : AppColors.onSurfaceVariant,
                        size: 24.0,
                      ),
                      Text(
                        '${store.convertTemp(hourly.temp)}°',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      Text(
                        hourly.pop,
                        style: TextStyle(
                          fontFamily: AppTypography.jetbrains,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                          color: isNow ? AppColors.primary : AppColors.outlineVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDailyForecastSection(WeatherData weather) {
    return GlassContainer(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NEXT 7 DAYS',
            style: AppTypography.labelSmall.copyWith(
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 16.0),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: weather.daily.length,
            itemBuilder: (context, index) {
              final daily = weather.daily[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 60.0,
                      child: Text(
                        daily.day,
                        style: AppTypography.bodyMedium.copyWith(
                          color: index == 0 ? AppColors.onSurface : AppColors.onSurfaceVariant,
                          fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    Icon(
                      _getIconData(daily.icon),
                      color: (index == 0 || daily.icon == 'thunderstorm') ? AppColors.primary : AppColors.onSurfaceVariant,
                      size: 20.0,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: _buildRangeBar(daily.rangeStart, daily.rangeEnd),
                    ),
                    const SizedBox(width: 8.0),
                    SizedBox(
                      width: 65.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${store.convertTemp(daily.maxTemp)}°',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            '${store.convertTemp(daily.minTemp)}°',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.onSurfaceVariant.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRangeBar(double startFraction, double endFraction) {
    return Container(
      height: 4.0,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final leftOffset = startFraction * width;
          final barWidth = max(4.0, (endFraction - startFraction) * width);

          return Stack(
            children: [
              Positioned(
                left: leftOffset,
                width: barWidth,
                top: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                    ),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailsGrid(WeatherData weather) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.gutter,
      mainAxisSpacing: AppSpacing.gutter,
      childAspectRatio: 1.25,
      children: [
        // AQI Card
        GlassContainer(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.air, size: 16.0, color: AppColors.onSurfaceVariant),
                  SizedBox(width: 8.0),
                  Text('AQI', style: AppTypography.labelSmall),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${weather.aqi} - ${weather.aqiDesc}',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Container(
                    height: 4.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: min(1.0, weather.aqi / 100.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                weather.aqiLongDesc,
                style: const TextStyle(fontSize: 10.0, color: AppColors.outline),
              ),
            ],
          ),
        ),

        // Wind Card
        GlassContainer(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.wind_power, size: 16.0, color: AppColors.onSurfaceVariant),
                  SizedBox(width: 8.0),
                  Text('WIND', style: AppTypography.labelSmall),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${store.convertWind(weather.windSpeed).toStringAsFixed(0)} ${store.windUnitSymbol}',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    weather.windDir,
                    style: AppTypography.labelSmall,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Transform.rotate(
                  angle: weather.windAngle * pi / 180,
                  child: const Icon(
                    Icons.explore_outlined,
                    color: AppColors.primary,
                    size: 28.0,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Humidity Card
        GlassContainer(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.water_drop, size: 16.0, color: AppColors.onSurfaceVariant),
                  SizedBox(width: 8.0),
                  Text('HUMIDITY', style: AppTypography.labelSmall),
                ],
              ),
              Text(
                '${weather.humidity}%',
                style: AppTypography.displayLarge.copyWith(
                  fontSize: 32.0,
                ),
              ),
              Text(
                weather.humidityDesc,
                style: const TextStyle(fontSize: 10.0, color: AppColors.outline),
              ),
            ],
          ),
        ),

        // Visibility Card
        GlassContainer(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.visibility, size: 16.0, color: AppColors.onSurfaceVariant),
                  SizedBox(width: 8.0),
                  Text('VISIBILITY', style: AppTypography.labelSmall),
                ],
              ),
              Text(
                '${weather.visibility} km',
                style: AppTypography.headlineLarge,
              ),
              Text(
                weather.visibilityDesc,
                style: const TextStyle(fontSize: 10.0, color: AppColors.outline),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSunMoonSection(WeatherData weather) {
    return GlassContainer(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.wb_twilight, size: 16.0, color: AppColors.onSurfaceVariant),
              SizedBox(width: 8.0),
              Text('SUNSET & SUNRISE', style: AppTypography.labelSmall),
            ],
          ),
          const SizedBox(height: 16.0),

          // Custom sunrise sunset curve
          SizedBox(
            height: 100.0,
            width: double.infinity,
            child: CustomPaint(
              painter: SunriseSunsetPainter(0.65), // simulated position: 65% through day
            ),
          ),
          const SizedBox(height: 8.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sunrise', style: TextStyle(fontSize: 10.0, color: AppColors.outline)),
                  Text(weather.sunrise, style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Sunset', style: TextStyle(fontSize: 10.0, color: AppColors.outline)),
                  Text(weather.sunset, style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16.0),
          const Divider(color: AppColors.outlineVariant, thickness: 0.5),
          const SizedBox(height: 8.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.dark_mode, size: 16.0, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: 8.0),
                  Text('Moonrise ${weather.moonrise}', style: const TextStyle(fontSize: 12.0, color: AppColors.onSurfaceVariant)),
                ],
              ),
              Text(
                weather.moonPhase,
                style: const TextStyle(fontSize: 12.0, color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SunriseSunsetPainter extends CustomPainter {
  final double progress;

  SunriseSunsetPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw dashed arc
    final Paint arcPaint = Paint()
      ..color = AppColors.onSurface.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Path path = Path();
    path.moveTo(10, size.height);
    path.quadraticBezierTo(size.width / 2, -10, size.width - 10, size.height);

    // Draw background arc
    canvas.drawPath(path, arcPaint);

    // 2. Draw progress active gradient arc
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    final Paint activePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppColors.outlineVariant.withOpacity(0.5),
          AppColors.primary,
          AppColors.surfaceContainerHighest.withOpacity(0.2)
        ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    canvas.drawPath(path, activePaint);

    // 3. Draw sun circle along path
    final double t = progress;
    // Bezier curve points: P0 = (10, H), P1 = (W/2, -10), P2 = (W - 10, H)
    final double p0x = 10.0;
    final double p0y = size.height;
    final double p1x = size.width / 2;
    final double p1y = -10.0;
    final double p2x = size.width - 10.0;
    final double p2y = size.height;

    final double x = (1 - t) * (1 - t) * p0x + 2 * (1 - t) * t * p1x + t * t * p2x;
    final double y = (1 - t) * (1 - t) * p0y + 2 * (1 - t) * t * p1y + t * t * p2y;

    // Glow
    final Paint glowPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), 12.0, glowPaint);

    // Sun core
    final Paint sunPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), 6.0, sunPaint);
  }

  @override
  bool shouldRepaint(covariant SunriseSunsetPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
