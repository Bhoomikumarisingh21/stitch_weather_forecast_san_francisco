import 'dart:ui';
import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF111316);
  static const Color surface = Color(0xFF111316);
  static const Color surfaceDim = Color(0xFF111316);
  static const Color surfaceBright = Color(0xFF37393D);
  static const Color surfaceContainerLowest = Color(0xFF0C0E11);
  static const Color surfaceContainerLow = Color(0xFF1A1C1F);
  static const Color surfaceContainer = Color(0xFF1E2023);
  static const Color surfaceContainerHigh = Color(0xFF282A2D);
  static const Color surfaceContainerHighest = Color(0xFF333538);
  static const Color onSurface = Color(0xFFE2E2E6);
  static const Color onSurfaceVariant = Color(0xFFC2C7CB);
  static const Color primary = Color(0xFFB1CAD7);
  static const Color onPrimary = Color(0xFF1C333E);
  static const Color secondary = Color(0xFFB4CAD6);
  static const Color onSecondary = Color(0xFF1E333C);
  static const Color secondaryContainer = Color(0xFF374C56);
  static const Color onSecondaryContainer = Color(0xFFA6BCC7);
  static const Color outline = Color(0xFF8C9195);
  static const Color outlineVariant = Color(0xFF42484B);
  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onError = Color(0xFF690005);
}

class AppSpacing {
  static const double xs = 4.0;
  static const double base = 8.0;
  static const double sm = 12.0;
  static const double md = 24.0;
  static const double lg = 48.0;
  static const double xl = 80.0;
  static const double gutter = 24.0;
  static const double marginMobile = 16.0;
  static const double marginDesktop = 64.0;
}

class AppTypography {
  static const String hanken = 'HankenGrotesk';
  static const String inter = 'Inter';
  static const String jetbrains = 'JetBrainsMono';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: hanken,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 56 / 48,
    letterSpacing: -0.02 * 48,
    color: AppColors.onSurface,
  );

  static const TextStyle displayTemp = TextStyle(
    fontFamily: hanken,
    fontSize: 96,
    fontWeight: FontWeight.w700,
    height: 100 / 96,
    letterSpacing: -0.04 * 96,
    color: AppColors.onSurface,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: hanken,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 40 / 32,
    color: AppColors.onSurface,
  );

  static const TextStyle headlineLargeMobile = TextStyle(
    fontFamily: hanken,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 36 / 28,
    color: AppColors.onSurface,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: inter,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.onSurfaceVariant,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: jetbrains,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    letterSpacing: 0.05 * 12,
    color: AppColors.onSurfaceVariant,
  );
}

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final bool highElevation;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.highElevation = false,
  });

  @override
  Widget build(BuildContext context) {
    final double blurSigma = highElevation ? 24.0 : 16.0;
    final Color backgroundColor = highElevation 
        ? const Color(0xFF333538).withOpacity(0.6) 
        : const Color(0xFF1E2023).withOpacity(0.4);
    
    final Color borderColor = highElevation 
        ? const Color(0xFF8C9195).withOpacity(0.25) 
        : const Color(0xFF8C9195).withOpacity(0.15);

    final resolvedBorderRadius = borderRadius ?? BorderRadius.circular(12.0);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: resolvedBorderRadius,
        boxShadow: highElevation ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ] : null,
      ),
      child: ClipRRect(
        borderRadius: resolvedBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: resolvedBorderRadius,
              border: Border.all(
                color: borderColor,
                width: 1.0,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
