import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// F3F7F8
class AppTheme {
  static const _primary = Color(0xFF0A5C75);
  static const _onPrimary = Color(0xFFFFFFFF);
  static const _secondary = Color(0xFFA8DF8E);
  static const _onSecondary = Color(0xFF0A3D2E);
  static const _backgroundLight = Color(0xFFF3F7F8);
  static const _backgroundDark = Color(0xFF121A1F);
  static const _textPrimaryLight = Color(0xFF102A33);
  static const _textSecondaryLight = Color(0xFF37474F);
  static const _textTertiary = Color(0xFF607D8B);
  static const _outline = Color(0xFFD1DDE1);
  static const _error = Color(0xFFD32F2F);

  static double getResponsiveSize(double webSize, double mobileSize) {
    if (kIsWeb) return webSize;
    return ScreenUtil().screenWidth > 600 ? webSize : mobileSize.sp;
  }

  static TextTheme _buildTextTheme(ColorScheme colorScheme, Color textTertiary) {
    const base = TextStyle(fontFamily: 'Inter');
    return TextTheme(
      displayLarge: base.copyWith(
        fontSize: getResponsiveSize(32, 28),
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      displayMedium: base.copyWith(
        fontSize: getResponsiveSize(28, 24),
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      displaySmall: base.copyWith(
        fontSize: getResponsiveSize(24, 20),
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      headlineLarge: base.copyWith(
        fontSize: getResponsiveSize(22, 18),
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      headlineMedium: base.copyWith(
        fontSize: getResponsiveSize(20, 16),
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      headlineSmall: base.copyWith(
        fontSize: getResponsiveSize(18, 14),
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      titleLarge: base.copyWith(
        fontSize: getResponsiveSize(18, 16),
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      titleMedium: base.copyWith(
        fontSize: getResponsiveSize(16, 14),
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      titleSmall: base.copyWith(
        fontSize: getResponsiveSize(14, 12),
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      bodyLarge: base.copyWith(
        fontSize: getResponsiveSize(16, 14),
        fontWeight: FontWeight.normal,
        color: colorScheme.onSurface,
      ),
      bodyMedium: base.copyWith(
        fontSize: getResponsiveSize(14, 12),
        fontWeight: FontWeight.normal,
        color: colorScheme.onSurfaceVariant,
      ),
      bodySmall: base.copyWith(
        fontSize: getResponsiveSize(12, 11),
        fontWeight: FontWeight.normal,
        color: textTertiary,
      ),
      labelLarge: base.copyWith(
        fontSize: getResponsiveSize(14, 12),
        fontWeight: FontWeight.w500,
        color: colorScheme.onPrimary,
      ),
      labelMedium: base.copyWith(
        fontSize: getResponsiveSize(12, 11),
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurfaceVariant,
      ),
      labelSmall: base.copyWith(
        fontSize: getResponsiveSize(11, 10),
        fontWeight: FontWeight.w500,
        color: colorScheme.primary,
      ),
    );
  }

  static ThemeData get lightTheme {
    final colorScheme = const ColorScheme.light(
      primary: _primary,
      onPrimary: _onPrimary,
      secondary: _secondary,
      onSecondary: _onSecondary,
      background: _backgroundLight,
      onSurface: _textPrimaryLight,
      surface: Colors.white,
      surfaceVariant: Color(0xFFd1dde1),
      onSurfaceVariant: _textSecondaryLight,
      error: _error,
      outline: _outline,
    );

    return _buildTheme(colorScheme, Brightness.light);
  }

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      primary: Color(0xFF1A8FAD),
      onPrimary: Colors.white,
      background: _backgroundDark,
      secondary: _secondary,
      onSecondary: _onSecondary,
      onSurface: Color(0xFFE0E7EB),
      surface: Color(0xFF1A242B),
      surfaceContainerHighest: Color(0xFF121A1F),
      onSurfaceVariant: Color(0xFFB0BEC5),
      error: Color(0xFFEF5350),
      onError: Colors.white,
      outline: Color(0xFF2C3A40),
    );

    return _buildTheme(colorScheme, Brightness.dark);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final textTertiaryColor = isDark ? const Color(0xFF90A4AE) : _textTertiary;
    final disabledBtnBg = isDark ? const Color(0xFF2C3A40) : const Color(0xFFB0BEC5);
    final disabledBtnFg = isDark ? const Color(0xFF607D8B) : const Color(0xFF78909C);
    final primaryHoverColor = isDark ? const Color(0xFF157791) : const Color(0xFF084C61);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(colorScheme, textTertiaryColor),
      scaffoldBackgroundColor: isDark ? _backgroundDark : colorScheme.background,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? _backgroundDark : colorScheme.surface,
        hintStyle: TextStyle(color: textTertiaryColor),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: disabledBtnBg,
          disabledForegroundColor: disabledBtnFg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(
            fontSize: getResponsiveSize(16, 14),
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
      ),
      // outlined theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: TextStyle(
            fontSize: getResponsiveSize(16, 14),
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
      ),

      extensions: [
        CustomColors(
          primaryHover: primaryHoverColor,
          secondaryHover: const Color(0xFF8FCC72),
          textTertiary: textTertiaryColor,
          divider: colorScheme.outline,
        ),
      ],
    );
  }
}

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color? primaryHover;
  final Color? secondaryHover;
  final Color? textTertiary;
  final Color? divider;

  const CustomColors({
    this.primaryHover,
    this.secondaryHover,
    this.textTertiary,
    this.divider,
  });

  @override
  CustomColors copyWith({
    Color? primaryHover,
    Color? secondaryHover,
    Color? textTertiary,
    Color? divider,
  }) {
    return CustomColors(
      primaryHover: primaryHover ?? this.primaryHover,
      secondaryHover: secondaryHover ?? this.secondaryHover,
      textTertiary: textTertiary ?? this.textTertiary,
      divider: divider ?? this.divider,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      primaryHover: Color.lerp(primaryHover, other.primaryHover, t),
      secondaryHover: Color.lerp(secondaryHover, other.secondaryHover, t),
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t),
      divider: Color.lerp(divider, other.divider, t),
    );
  }
}
