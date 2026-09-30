import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand
  static const purple = Color(0xFF7B2CBF);
  static const purpleMid = Color(0xFF4A148C);
  static const darkPurple = Color(0xFF16052B);

  // General
  static const background = Color(0xFFF8F5FC);

  // Inputs
  static const inputBackground = Colors.white;
  static const inputText = Color(0xFF1A1A1A);
  static const inputHint = Color(0xFF777777);

  // Transaction
  static const income = Color(0xFF2ECC71);
  static const expense = Color(0xFFE84393);

  // Text
  static const textPrimary = Colors.white;
  static const textSecondary = Colors.white70;

  // Dark mode input colors
  static const darkInputBackground = Color(0xFF241039);
  static const darkInputText = Colors.white;
  static const darkInputHint = Colors.white60;
}

class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color surfaceCard;
  final Color textPrimary;
  final Color mutedText;
  final Color income;
  final Color expense;

  const AppThemeColors({
    required this.surfaceCard,
    required this.textPrimary,
    required this.mutedText,
    required this.income,
    required this.expense,
  });

  @override
  AppThemeColors copyWith({
    Color? surfaceCard,
    Color? textPrimary,
    Color? mutedText,
    Color? income,
    Color? expense,
  }) {
    return AppThemeColors(
      surfaceCard: surfaceCard ?? this.surfaceCard,
      textPrimary: textPrimary ?? this.textPrimary,
      mutedText: mutedText ?? this.mutedText,
      income: income ?? this.income,
      expense: expense ?? this.expense,
    );
  }

  @override
  AppThemeColors lerp(
      covariant AppThemeColors? other,
      double t,
      ) {
    if (other == null) {
      return this;
    }

    return AppThemeColors(
      surfaceCard: Color.lerp(
        surfaceCard,
        other.surfaceCard,
        t,
      )!,
      textPrimary: Color.lerp(
        textPrimary,
        other.textPrimary,
        t,
      )!,
      mutedText: Color.lerp(
        mutedText,
        other.mutedText,
        t,
      )!,
      income: Color.lerp(
        income,
        other.income,
        t,
      )!,
      expense: Color.lerp(
        expense,
        other.expense,
        t,
      )!,
    );
  }
}

class AppTheme {
  static TextTheme _textTheme() {
    return GoogleFonts.poppinsTextTheme(
      const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  static ThemeData get light {
    final textTheme = _textTheme();

    return ThemeData(
      useMaterial3: true,

      brightness: Brightness.light,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.purple,
        brightness: Brightness.light,
      ),

      extensions: const [
        AppThemeColors(
          surfaceCard: Color(0x1FFFFFFF),
          textPrimary: AppColors.textPrimary,
          mutedText: AppColors.textSecondary,
          income: AppColors.income,
          expense: AppColors.expense,
        ),
      ],

      textTheme: textTheme,

      scaffoldBackgroundColor: AppColors.background,

      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
      ),

      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.darkPurple,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        contentTextStyle: TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBackground,

        hintStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.inputHint,
        ),

        labelStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.inputHint,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.purple,
            width: 2,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          backgroundColor: AppColors.purple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  static ThemeData get dark {
    final textTheme = _textTheme();

    return ThemeData(
      useMaterial3: true,

      brightness: Brightness.dark,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.purple,
        brightness: Brightness.dark,
      ),

      extensions: const [
        AppThemeColors(
          surfaceCard: Color(0x24FFFFFF),
          textPrimary: AppColors.textPrimary,
          mutedText: AppColors.textSecondary,
          income: AppColors.income,
          expense: AppColors.expense,
        ),
      ],

      textTheme: textTheme,

      scaffoldBackgroundColor: AppColors.darkPurple,

      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
      ),

      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.darkPurple,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        contentTextStyle: TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkInputBackground,

        hintStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.darkInputHint,
        ),

        labelStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.darkInputHint,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.purple,
            width: 2,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          backgroundColor: AppColors.purple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}