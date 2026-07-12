import 'package:flutter/material.dart';
import 'theme.dart';
import 'weather_model.dart';

class CityListScreen extends StatefulWidget {
  final WeatherStore store;
  final Function(int) onCitySelected;

  const CityListScreen({
    super.key,
    required this.store,
    required this.onCitySelected,
  });

  @override
  State<CityListScreen> createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> {
  final TextEditingController _searchController = TextEditingController();

  IconData _getIconData(String condition) {
    switch (condition.toLowerCase()) {
      case 'rainy':
        return Icons.umbrella;
      case 'thunderstorm':
        return Icons.thunderstorm;
      case 'cloud':
      case 'overcast':
        return Icons.cloud;
      case 'partly cloudy':
      case 'partly_cloudy_day':
        return Icons.wb_cloudy_outlined;
      case 'sunny':
      case 'wb_sunny':
        return Icons.wb_sunny;
      default:
        return Icons.cloud;
    }
  }

  Color _getWeatherTint(String condition) {
    switch (condition.toLowerCase()) {
      case 'rainy':
      case 'thunderstorm':
        return AppColors.primary.withOpacity(0.08);
      case 'sunny':
        return Colors.orangeAccent.withOpacity(0.05);
      case 'partly cloudy':
      case 'overcast':
        return AppColors.secondary.withOpacity(0.05);
      default:
        return Colors.transparent;
    }
  }

  void _showAddCityDialog() {
    final nameController = TextEditingController();
    String selectedCondition = 'Rainy';
    double tempVal = 15.0;
    bool isSaving = false;
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: GlassContainer(
                highElevation: true,
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'ADD NEW LOCATION',
                      style: AppTypography.labelSmall.copyWith(letterSpacing: 2.0),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16.0),
                    // City Name input
                    TextField(
                      controller: nameController,
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
                      decoration: InputDecoration(
                        labelText: 'City Name',
                        errorText: errorMessage,
                        labelStyle: const TextStyle(color: AppColors.outline),
                        hintText: 'e.g. Seattle',
                        hintStyle: TextStyle(color: AppColors.outline.withOpacity(0.5)),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.outlineVariant),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    // Temperature Slider
                    Text(
                      'Temperature: ${tempVal.toInt()}°C',
                      style: AppTypography.bodyMedium,
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.primary,
                        inactiveTrackColor: AppColors.surfaceContainerHighest,
                        thumbColor: AppColors.primary,
                        trackHeight: 2.0,
                      ),
                      child: Slider(
                        value: tempVal,
                        min: -10,
                        max: 40,
                        onChanged: isSaving ? null : (val) {
                          setDialogState(() {
                            tempVal = val;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    // Condition Dropdown
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Condition:', style: AppTypography.bodyMedium),
                        DropdownButton<String>(
                          value: selectedCondition,
                          dropdownColor: AppColors.surfaceContainerHigh,
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
                          underline: Container(
                            height: 1.0,
                            color: AppColors.primary,
                          ),
                          items: <String>[
                            'Rainy',
                            'Thunderstorm',
                            'Cloud',
                            'Partly Cloudy',
                            'Sunny'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: isSaving ? null : (String? newValue) {
                            if (newValue != null) {
                              setDialogState(() {
                                selectedCondition = newValue;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: isSaving ? null : () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: isSaving 
                                  ? AppColors.onSurfaceVariant.withOpacity(0.3)
                                  : AppColors.onSurfaceVariant.withOpacity(0.7)
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        if (isSaving)
                          const SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                            ),
                          )
                        else
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.onPrimary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              elevation: 0,
                            ),
                            onPressed: () async {
                              final cityName = nameController.text.trim();
                              if (cityName.isEmpty) {
                                setDialogState(() {
                                  errorMessage = "Please enter a valid city or location.";
                                });
                                return;
                              }

                              final normalizedName = LocationService.normalizeLocationName(cityName);

                              // 1. Check duplicate locations
                              final alreadyExists = widget.store.cities.any((c) =>
                                LocationService.normalizeLocationName(c.cityName).toLowerCase() == normalizedName.toLowerCase()
                              );
                              if (alreadyExists) {
                                setDialogState(() {
                                  errorMessage = "This location has already been added.";
                                });
                                return;
                              }

                              // 2. Local validation before calling the API
                              if (!LocationService.isValid(cityName)) {
                                setDialogState(() {
                                  errorMessage = "Please enter a valid city or location.";
                                });
                                return;
                              }

                              setDialogState(() {
                                isSaving = true;
                                errorMessage = null;
                              });

                              try {
                                // 3. Call proper weather API simulation and validate the API response
                                final newCityData = await widget.store.fetchWeather(
                                  cityName,
                                  temp: tempVal,
                                  condition: selectedCondition,
                                );

                                widget.store.addCity(newCityData);
                                Navigator.pop(context);
                                // Auto switch to home screen to show the newly added city
                                widget.onCitySelected(widget.store.cities.length - 1);
                              } catch (e) {
                                setDialogState(() {
                                  isSaving = false;
                                  errorMessage = e.toString().replaceAll("Exception: ", "");
                                });
                              }
                            },
                            child: const Text('Add City'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
          // Header Row with Add Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LOCATIONS LIST',
                    style: AppTypography.labelSmall.copyWith(letterSpacing: 2.0),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Saved Cities',
                    style: AppTypography.headlineLargeMobile,
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(
                  Icons.add_location_alt_outlined,
                  color: AppColors.primary,
                  size: 28.0,
                ),
                onPressed: _showAddCityDialog,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Search Field
          TextField(
            controller: _searchController,
            onChanged: (val) {
              setState(() {}); // trigger rebuild to filter
            },
            style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceContainer.withOpacity(0.4),
              prefixIcon: const Icon(Icons.search, color: AppColors.outline),
              hintText: 'Search city...',
              hintStyle: TextStyle(color: AppColors.outline.withOpacity(0.5)),
              contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: AppColors.outline.withOpacity(0.15)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: AppColors.outline.withOpacity(0.15)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // City List View
          Expanded(
            child: AnimatedBuilder(
              animation: widget.store,
              builder: (context, child) {
                final query = _searchController.text.toLowerCase().trim();
                final filteredIndices = <int>[];
                
                for (int i = 0; i < widget.store.cities.length; i++) {
                  if (widget.store.cities[i].cityName.toLowerCase().contains(query)) {
                    filteredIndices.add(i);
                  }
                }

                if (filteredIndices.isEmpty) {
                  return Center(
                    child: Text(
                      'No cities found.',
                      style: AppTypography.bodyMedium,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredIndices.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final originalIndex = filteredIndices[index];
                    final city = widget.store.cities[originalIndex];
                    final isSelected = originalIndex == widget.store.selectedCityIndex;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          widget.store.selectCity(originalIndex);
                          widget.onCitySelected(originalIndex);
                        },
                        child: GlassContainer(
                          borderRadius: BorderRadius.circular(16.0),
                          padding: const EdgeInsets.all(16.0),
                          highElevation: isSelected,
                          child: Container(
                            decoration: BoxDecoration(
                              color: _getWeatherTint(city.condition),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              children: [
                                // Weather icon
                                Icon(
                                  _getIconData(city.condition),
                                  size: 40.0,
                                  color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                                ),
                                const SizedBox(width: 16.0),

                                // City Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        city.cityName,
                                        style: AppTypography.bodyMedium.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 2.0),
                                      Text(
                                        city.condition,
                                        style: AppTypography.labelSmall.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Temperature values
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${widget.store.convertTemp(city.temp)}${widget.store.tempUnitSymbol}',
                                      style: AppTypography.displayLarge.copyWith(
                                        fontSize: 24.0,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      'H:${widget.store.convertTemp(city.daily.first.maxTemp)}° L:${widget.store.convertTemp(city.daily.first.minTemp)}°',
                                      style: TextStyle(
                                        fontSize: 11.0,
                                        color: AppColors.onSurfaceVariant.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
