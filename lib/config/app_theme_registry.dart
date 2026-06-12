import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_color.dart';
import '../constants/app_text_style.dart';
import '../constants/app_radius.dart';

class AppThemeRegistry {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColor.bgDeep,
      fontFamily: 'Exo2',

      // Color scheme
      colorScheme: ColorScheme.dark(
        primary: AppColor.cyan,
        secondary: AppColor.violet,
        surface: AppColor.surface,
        error: AppColor.danger,
        onPrimary: AppColor.bgDeep,
        onSecondary: AppColor.fg,
        onSurface: AppColor.fg,
        onError: AppColor.fg,
        outline: AppColor.border,
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: AppTextStyle.display,
        displayMedium: AppTextStyle.h1,
        displaySmall: AppTextStyle.h2,
        headlineMedium: AppTextStyle.h3,
        titleLarge: AppTextStyle.h3,
        titleMedium: AppTextStyle.bodyBold,
        bodyLarge: AppTextStyle.body,
        bodyMedium: AppTextStyle.body,
        bodySmall: AppTextStyle.bodySmall,
        labelLarge: AppTextStyle.button,
        labelMedium: AppTextStyle.buttonSmall,
        labelSmall: AppTextStyle.label,
      ),

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColor.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyle.h3,
        iconTheme: IconThemeData(color: AppColor.fg, size: 24),
        actionsIconTheme: IconThemeData(color: AppColor.fg, size: 24),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: AppColor.transparent,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: AppColor.surface,
        elevation: 0,
        shadowColor: AppColor.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: AppColor.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColor.bgRaised,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: AppColor.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: AppColor.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: AppColor.cyan, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: AppColor.danger, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: AppColor.danger, width: 1),
        ),
        hintStyle: AppTextStyle.body.copyWith(color: AppColor.fgMuted),
        labelStyle: AppTextStyle.bodySmall.copyWith(color: AppColor.fgSecondary),
        errorStyle: AppTextStyle.caption.copyWith(color: AppColor.danger),
      ),

      // Bottom sheet theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColor.bgRaised,
        modalBackgroundColor: AppColor.bgRaised,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColor.bgRaised,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          side: BorderSide(color: AppColor.border, width: 1),
        ),
        titleTextStyle: AppTextStyle.h3,
        contentTextStyle: AppTextStyle.body,
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: AppColor.border,
        thickness: 1,
        space: 1,
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColor.surface,
        selectedColor: AppColor.cyanDim,
        disabledColor: AppColor.surface.withValues(alpha:0.5),
        labelStyle: AppTextStyle.caption,
        secondaryLabelStyle: AppTextStyle.caption,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          side: BorderSide(color: AppColor.border, width: 1),
        ),
      ),

      // Icon theme
      iconTheme: IconThemeData(
        color: AppColor.fg,
        size: 24,
      ),

      // Progress indicator theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColor.cyan,
        linearTrackColor: AppColor.surface,
        circularTrackColor: AppColor.surface,
      ),

      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColor.surface,
        contentTextStyle: AppTextStyle.body,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: AppColor.border, width: 1),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),

      useMaterial3: true,
    );
  }
}
