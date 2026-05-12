import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppColors {
  // Primária — marrom escuro (top bars e botão principal)
  static const Color primary = Color(0xFF3C3333);

  // Acento verde — "Adotar", "Adotado", "Esqueceu sua senha?"
  static const Color accent = Color(0xFF2EAF6B);

  // Superfície de cards e inputs
  static const Color surface = Color(0xFFF3F5F5);

  // Fundo branco
  static const Color background = Color(0xFFFFFFFF);

  // Texto principal
  static const Color textPrimary = Color(0xFF181D2D);

  // Texto subtítulo
  static const Color textSecondary = Color(0xFFAAAAAA);

  // Placeholder de inputs
  static const Color textPlaceholder = Color(0xFFC1C7D0);

  // Texto terciário
  static const Color textTertiary = Color(0xFF888888);

  // Divisor e bordas
  static const Color divider = Color(0xFFE0E0E0);

  // Ícone de busca — violeta
  static const Color searchIcon = Color(0xFF6C63FF);

  // Status de adoção
  static const Color statusAdopted = Color(0xFF2EAF6B);
  static const Color statusCancelled = Color(0xFFE53935);
  static const Color statusOpen = Color(0xFFFF8C00);

  // Botão sair — vermelho
  static const Color logoutRed = Color(0xFFE53935);

  // Sombra do botão primário
  static const Color buttonShadow = Color(0x4D95ADFE);

  // Sombra de social buttons
  static const Color cardShadow = Color(0xFFC1C7D0);

  // Texto dos cards de navegação
  static const Color cardNavText = Color(0xE33C3333);
}

abstract final class AppRadius {
  static const double button = 26;
  static const double buttonSocial = 99;
  static const double card = 16;
  static const double input = 10;
  static const double avatar = 1000;
}

abstract final class AppShadows {
  static List<BoxShadow> get primaryButton => [
        BoxShadow(
          color: AppColors.buttonShadow,
          offset: const Offset(0, 10),
          blurRadius: 22,
        ),
      ];

  static List<BoxShadow> get socialButton => [
        BoxShadow(
          color: AppColors.cardShadow,
          offset: const Offset(0, 2),
          blurRadius: 20,
        ),
      ];

  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.25),
          offset: const Offset(0, 4),
          blurRadius: 4,
        ),
      ];
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.background,
    ),
    scaffoldBackgroundColor: AppColors.background,
  );

  return base.copyWith(
    textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
      headlineMedium: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 8,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        minimumSize: const Size(double.infinity, 60),
        textStyle: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      hintStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textPlaceholder,
        letterSpacing: -0.2,
      ),
    ),
  );
}
