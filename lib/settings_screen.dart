import 'package:flutter/material.dart';
import 'theme.dart';
import 'weather_model.dart';

class SettingsScreen extends StatefulWidget {
  final WeatherStore store;

  const SettingsScreen({
    super.key,
    required this.store,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _refreshFrequency = 'Hourly';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SETTINGS',
                style: AppTypography.labelSmall.copyWith(letterSpacing: 2.0),
              ),
              const SizedBox(height: 4.0),
              Text(
                'Preferences',
                style: AppTypography.headlineLargeMobile,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // 1. Weather Units Settings Card
          _buildCardTitle('WEATHER UNITS'),
          GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                // Temperature unit
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Temperature Unit', style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface)),
                    Row(
                      children: [
                        _buildToggleButton(
                          label: '°C',
                          isSelected: !widget.store.useFahrenheit,
                          onPressed: () => widget.store.useFahrenheit = false,
                        ),
                        const SizedBox(width: 8.0),
                        _buildToggleButton(
                          label: '°F',
                          isSelected: widget.store.useFahrenheit,
                          onPressed: () => widget.store.useFahrenheit = true,
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(color: AppColors.outlineVariant, thickness: 0.5, height: 24.0),
                // Wind unit
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Wind Speed Unit', style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface)),
                    Row(
                      children: [
                        _buildToggleButton(
                          label: 'km/h',
                          isSelected: !widget.store.useMph,
                          onPressed: () => widget.store.useMph = false,
                        ),
                        const SizedBox(width: 8.0),
                        _buildToggleButton(
                          label: 'mph',
                          isSelected: widget.store.useMph,
                          onPressed: () => widget.store.useMph = true,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // 2. Custom Aesthetic Theme Selector
          _buildCardTitle('VISUAL SCHEME'),
          GlassContainer(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select interface color palette:',
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    Expanded(child: _buildThemeChoice(0, 'Rainy Gray', const Color(0xFF1E2023), AppColors.primary)),
                    const SizedBox(width: 8.0),
                    Expanded(child: _buildThemeChoice(1, 'Sunset Gold', const Color(0xFF1E1A23), Colors.amberAccent)),
                    const SizedBox(width: 8.0),
                    Expanded(child: _buildThemeChoice(2, 'Deep Dark', Colors.black, AppColors.outline)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // 3. System Preferences Card
          _buildCardTitle('SYSTEM PREFERENCES'),
          GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                // Notifications switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Severe Weather Alerts', style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface)),
                    Switch(
                      value: _notificationsEnabled,
                      activeColor: AppColors.primary,
                      activeTrackColor: AppColors.primary.withOpacity(0.3),
                      inactiveThumbColor: AppColors.outline,
                      inactiveTrackColor: AppColors.surfaceContainerHighest,
                      onChanged: (val) {
                        setState(() {
                          _notificationsEnabled = val;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(color: AppColors.outlineVariant, thickness: 0.5, height: 24.0),
                // Background refresh frequency
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Background Refresh', style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface)),
                    DropdownButton<String>(
                      value: _refreshFrequency,
                      dropdownColor: AppColors.surfaceContainerHigh,
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
                      underline: Container(),
                      items: <String>[
                        'Every 15 mins',
                        'Every 30 mins',
                        'Hourly',
                        'Manual'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(fontSize: 14.0)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _refreshFrequency = newValue;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // 4. About Info
          _buildCardTitle('ABOUT APPLICATION'),
          GlassContainer(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Atmospheric Precision',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.onSurface),
                    ),
                    Text(
                      'v1.0.0',
                      style: TextStyle(fontFamily: AppTypography.jetbrains, fontSize: 12.0, color: AppColors.outline),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Inspired by the moody overcast look of a rainy afternoon in San Francisco. Uses Hanken Grotesk and Inter fonts with custom glassmorphism overlays.',
                  style: TextStyle(fontSize: 12.0, height: 1.5, color: AppColors.onSurfaceVariant.withOpacity(0.8)),
                ),
                const SizedBox(height: 12.0),
                const Divider(color: AppColors.outlineVariant, thickness: 0.5),
                const SizedBox(height: 8.0),
                Text(
                  'Developed for Antigravity verification.',
                  style: TextStyle(fontFamily: AppTypography.jetbrains, fontSize: 10.0, color: AppColors.primary.withOpacity(0.7)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        title,
        style: AppTypography.labelSmall.copyWith(
          fontSize: 10.0,
          color: AppColors.outline,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isSelected ? AppColors.primary.withOpacity(0.4) : AppColors.outlineVariant.withOpacity(0.4),
            width: 1.0,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildThemeChoice(int index, String label, Color bgColor, Color accentColor) {
    final bool isSelected = widget.store.activeThemeIndex == index;
    return GestureDetector(
      onTap: () {
        widget.store.activeThemeIndex = index;
      },
      child: Container(
        height: 70.0,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline.withOpacity(0.15),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Theme preview icon
            Container(
              width: 20.0,
              height: 20.0,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
                border: Border.all(color: accentColor, width: 2.0),
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 10.0, color: accentColor)
                  : null,
            ),
            const SizedBox(height: 6.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.0,
                color: isSelected ? AppColors.onSurface : AppColors.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
