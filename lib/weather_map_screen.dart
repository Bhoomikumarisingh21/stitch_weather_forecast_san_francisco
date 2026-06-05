import 'dart:math';
import 'package:flutter/material.dart';
import 'theme.dart';
import 'weather_model.dart';

class WeatherMapScreen extends StatefulWidget {
  final WeatherStore store;

  const WeatherMapScreen({
    super.key,
    required this.store,
  });

  @override
  State<WeatherMapScreen> createState() => _WeatherMapScreenState();
}

class _WeatherMapScreenState extends State<WeatherMapScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPlaying = true;
  double _opacity = 0.6;
  String _activeLayer = 'Rain'; // 'Rain', 'Wind', 'Temp'
  double _zoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    if (_isPlaying) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cityName = widget.store.current.cityName;

    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.marginMobile,
        right: AppSpacing.marginMobile,
        top: 80.0,
        bottom: 110.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WEATHER RADAR',
                    style: AppTypography.labelSmall.copyWith(letterSpacing: 2.0),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '$cityName Area',
                    style: AppTypography.headlineLargeMobile,
                  ),
                ],
              ),
              // Layer Indicators / Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6.0,
                      height: 6.0,
                      decoration: const BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      'Live Feed',
                      style: AppTypography.labelSmall.copyWith(
                        fontSize: 10.0,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Radar Display Container
          Expanded(
            child: GlassContainer(
              padding: EdgeInsets.zero,
              child: Stack(
                children: [
                  // 1. Grid, shoreline, and radar animation Canvas
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: RadarMapPainter(
                            sweepProgress: _controller.value,
                            opacity: _opacity,
                            layer: _activeLayer,
                            zoom: _zoomLevel,
                            cityName: cityName,
                          ),
                        );
                      },
                    ),
                  ),

                  // 2. Compass Direction indicators inside map
                  const Positioned(
                    top: 12.0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text('N', style: TextStyle(fontFamily: AppTypography.jetbrains, fontSize: 10.0, color: AppColors.outline, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const Positioned(
                    bottom: 12.0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text('S', style: TextStyle(fontFamily: AppTypography.jetbrains, fontSize: 10.0, color: AppColors.outline, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const Positioned(
                    left: 12.0,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Text('W', style: TextStyle(fontFamily: AppTypography.jetbrains, fontSize: 10.0, color: AppColors.outline, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const Positioned(
                    right: 12.0,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Text('E', style: TextStyle(fontFamily: AppTypography.jetbrains, fontSize: 10.0, color: AppColors.outline, fontWeight: FontWeight.bold)),
                    ),
                  ),

                  // 3. Zoom Controls (floating)
                  Positioned(
                    right: 12.0,
                    bottom: 12.0,
                    child: Column(
                      children: [
                        FloatingActionButton.small(
                          heroTag: 'zoom_in',
                          backgroundColor: AppColors.surfaceContainerHigh.withOpacity(0.8),
                          foregroundColor: AppColors.primary,
                          onPressed: () {
                            setState(() {
                              _zoomLevel = min(2.0, _zoomLevel + 0.2);
                            });
                          },
                          child: const Icon(Icons.add),
                        ),
                        const SizedBox(height: 8.0),
                        FloatingActionButton.small(
                          heroTag: 'zoom_out',
                          backgroundColor: AppColors.surfaceContainerHigh.withOpacity(0.8),
                          foregroundColor: AppColors.primary,
                          onPressed: () {
                            setState(() {
                              _zoomLevel = max(0.5, _zoomLevel - 0.2);
                            });
                          },
                          child: const Icon(Icons.remove),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Radar Controller Bar
          GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              children: [
                // Layer Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildLayerButton('Rain', Icons.grain),
                    _buildLayerButton('Wind', Icons.waves),
                    _buildLayerButton('Temp', Icons.thermostat),
                  ],
                ),
                const SizedBox(height: 12.0),
                const Divider(color: AppColors.outlineVariant, thickness: 0.5),
                const SizedBox(height: 12.0),

                // Playback and Opacity
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                        color: AppColors.primary,
                        size: 36.0,
                      ),
                      onPressed: _togglePlay,
                    ),
                    const SizedBox(width: 8.0),
                    const Icon(Icons.opacity, color: AppColors.onSurfaceVariant, size: 18.0),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.primary,
                          inactiveTrackColor: AppColors.surfaceContainerHighest,
                          thumbColor: AppColors.primary,
                          overlayColor: AppColors.primary.withOpacity(0.2),
                          trackHeight: 2.0,
                        ),
                        child: Slider(
                          value: _opacity,
                          min: 0.1,
                          max: 1.0,
                          onChanged: (val) {
                            setState(() {
                              _opacity = val;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 35.0,
                      child: Text(
                        '${(_opacity * 100).toInt()}%',
                        textAlign: TextAlign.right,
                        style: AppTypography.labelSmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayerButton(String label, IconData icon) {
    final bool isActive = _activeLayer == label;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _activeLayer = label;
          });
        },
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: isActive ? AppColors.primary.withOpacity(0.4) : Colors.transparent,
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16.0,
                color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 8.0),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RadarMapPainter extends CustomPainter {
  final double sweepProgress;
  final double opacity;
  final String layer;
  final double zoom;
  final String cityName;

  RadarMapPainter({
    required this.sweepProgress,
    required this.opacity,
    required this.layer,
    required this.zoom,
    required this.cityName,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double maxRadius = max(size.width, size.height) * 0.8;

    // 1. Draw Grid Rings & Lines
    final Paint gridPaint = Paint()
      ..color = AppColors.outline.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Drawing concentric circles
    for (double r = 40; r <= maxRadius; r += 40) {
      canvas.drawCircle(Offset(cx, cy), r * zoom, gridPaint);
    }

    // Cross grid lines
    canvas.drawLine(Offset(0, cy), Offset(size.width, cy), gridPaint);
    canvas.drawLine(Offset(cx, 0), Offset(cx, size.height), gridPaint);

    // 2. Draw Shoreline / Map Contours (Stylized custom paths)
    final Paint mapPaint = Paint()
      ..color = AppColors.outlineVariant.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final Path shorelinePath = Path();
    
    // Draw based on selected city. If San Francisco, draw SF Bay / Peninsula.
    // Otherwise draw generic beautiful topography curves.
    if (cityName == 'San Francisco') {
      // Coastline scale & position shifted by zoom
      // Left Coast (Pacific Ocean) -> top tip (Presidio) -> Bay curve on right
      shorelinePath.moveTo(cx - 150 * zoom, cy + 200 * zoom);
      shorelinePath.quadraticBezierTo(cx - 160 * zoom, cy + 50 * zoom, cx - 140 * zoom, cy - 20 * zoom);
      shorelinePath.quadraticBezierTo(cx - 120 * zoom, cy - 80 * zoom, cx - 70 * zoom, cy - 90 * zoom); // Presidio / Golden Gate tip
      shorelinePath.quadraticBezierTo(cx - 20 * zoom, cy - 90 * zoom, cx - 10 * zoom, cy - 50 * zoom); // Embarcadero
      shorelinePath.lineTo(cx - 10 * zoom, cy + 150 * zoom); // Bay shore going South
      
      // Draw Marin County (north)
      shorelinePath.moveTo(cx - 120 * zoom, cy - 180 * zoom);
      shorelinePath.quadraticBezierTo(cx - 85 * zoom, cy - 130 * zoom, cx - 75 * zoom, cy - 110 * zoom); // Horseshoe Cove
      shorelinePath.lineTo(cx - 140 * zoom, cy - 110 * zoom);
      
      // Golden Gate Bridge line (dashed or thin representation)
      final Paint bridgePaint = Paint()
        ..color = AppColors.primary.withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawLine(Offset(cx - 75 * zoom, cy - 110 * zoom), Offset(cx - 70 * zoom, cy - 90 * zoom), bridgePaint);
      
      // East Bay shoreline
      shorelinePath.moveTo(cx + 80 * zoom, cy - 180 * zoom);
      shorelinePath.quadraticBezierTo(cx + 100 * zoom, cy - 80 * zoom, cx + 90 * zoom, cy + 200 * zoom);
    } else {
      // Generic topographic curves for other cities
      shorelinePath.moveTo(0, cy + 50 * zoom);
      shorelinePath.cubicTo(cx - 100 * zoom, cy - 100 * zoom, cx + 50 * zoom, cy + 100 * zoom, size.width, cy - 50 * zoom);
      
      shorelinePath.moveTo(0, cy + 120 * zoom);
      shorelinePath.cubicTo(cx - 50 * zoom, cy + 20 * zoom, cx + 100 * zoom, cy + 150 * zoom, size.width, cy + 50 * zoom);
    }

    canvas.drawPath(shorelinePath, mapPaint);

    // 3. Draw Radar Echoes (Clouds / Heat)
    // We create static storm cells that pulse and drift with sweepProgress
    final Paint echoPaint = Paint()..style = PaintingStyle.fill;
    
    // Define 3 storm cells
    final cells = [
      {'x': cx - 40 * zoom, 'y': cy - 30 * zoom, 'size': 35.0, 'rainIntensity': 0.8},
      {'x': cx + 60 * zoom, 'y': cy + 20 * zoom, 'size': 45.0, 'rainIntensity': 0.5},
      {'x': cx - 80 * zoom, 'y': cy + 80 * zoom, 'size': 25.0, 'rainIntensity': 0.9},
    ];

    for (var cell in cells) {
      final double cellX = cell['x'] as double;
      final double cellY = cell['y'] as double;
      final double baseSize = cell['size'] as double;
      final double intensity = cell['rainIntensity'] as double;

      // Pulse cell size slightly using trigonometry based on sweepProgress
      final double sizePulse = baseSize * (0.9 + 0.15 * sin(sweepProgress * 2 * pi));

      // Drift cells slightly
      final double driftX = 10.0 * sin(sweepProgress * pi);
      final double driftY = -5.0 * cos(sweepProgress * pi);
      final cellCenter = Offset(cellX + driftX, cellY + driftY);

      // Colors depend on selected layer
      Color coreColor;
      Color midColor;
      Color outerColor;

      if (layer == 'Rain') {
        coreColor = Colors.redAccent.withOpacity(opacity * intensity);
        midColor = Colors.orangeAccent.withOpacity(opacity * intensity * 0.7);
        outerColor = Colors.greenAccent.withOpacity(opacity * intensity * 0.4);
      } else if (layer == 'Wind') {
        coreColor = Colors.purpleAccent.withOpacity(opacity * intensity);
        midColor = Colors.cyanAccent.withOpacity(opacity * intensity * 0.7);
        outerColor = Colors.blueAccent.withOpacity(opacity * intensity * 0.3);
      } else { // Temp
        coreColor = Colors.deepOrange.withOpacity(opacity * intensity);
        midColor = Colors.orange.withOpacity(opacity * intensity * 0.8);
        outerColor = Colors.yellow.withOpacity(opacity * intensity * 0.4);
      }

      // Draw concentric blurred circles for the echo cell
      // Outer region
      echoPaint.color = outerColor;
      canvas.drawCircle(cellCenter, sizePulse * 1.5 * zoom, echoPaint);

      // Middle region
      echoPaint.color = midColor;
      canvas.drawCircle(cellCenter, sizePulse * 0.9 * zoom, echoPaint);

      // Core region
      echoPaint.color = coreColor;
      canvas.drawCircle(cellCenter, sizePulse * 0.4 * zoom, echoPaint);
    }

    // 4. Draw Rotating Radar Sweep Line & Glowing Fade
    final double sweepAngle = sweepProgress * 2 * pi - pi / 2; // start from top
    
    // Draw fading sweep wedge
    final Paint sweepWedgePaint = Paint()
      ..style = PaintingStyle.fill;

    final Path sweepWedgePath = Path();
    sweepWedgePath.moveTo(cx, cy);
    
    // Draw 30 degree wedge trailing the sweep line
    const int segments = 20;
    const double wedgeAngle = 40 * pi / 180; // 40 degrees trailing
    
    for (int i = 0; i <= segments; i++) {
      final double angle = sweepAngle - (wedgeAngle * (i / segments));
      final double radius = maxRadius * zoom;
      final double x = cx + radius * cos(angle);
      final double y = cy + radius * sin(angle);
      
      if (i == 0) {
        sweepWedgePath.lineTo(x, y);
      } else {
        sweepWedgePath.lineTo(x, y);
      }
    }
    sweepWedgePath.close();

    // Create a sweep sweep gradient shader matching the rotation
    final sweepShader = SweepGradient(
      center: Alignment.center,
      startAngle: sweepAngle - wedgeAngle,
      endAngle: sweepAngle,
      colors: [
        AppColors.primary.withOpacity(0.0),
        AppColors.primary.withOpacity(opacity * 0.3),
      ],
      stops: const [0.0, 1.0],
    ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: maxRadius * zoom));

    sweepWedgePaint.shader = sweepShader;
    canvas.drawPath(sweepWedgePath, sweepWedgePaint);

    // Draw active sweep line
    final Paint sweepLinePaint = Paint()
      ..color = AppColors.primary.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final double sweepX = cx + (maxRadius * zoom) * cos(sweepAngle);
    final double sweepY = cy + (maxRadius * zoom) * sin(sweepAngle);
    canvas.drawLine(Offset(cx, cy), Offset(sweepX, sweepY), sweepLinePaint);
  }

  @override
  bool shouldRepaint(covariant RadarMapPainter oldDelegate) {
    return oldDelegate.sweepProgress != sweepProgress ||
        oldDelegate.opacity != opacity ||
        oldDelegate.layer != layer ||
        oldDelegate.zoom != zoom ||
        oldDelegate.cityName != cityName;
  }
}
