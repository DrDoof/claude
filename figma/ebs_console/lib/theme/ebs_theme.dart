import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ebs_colors.dart';

class EbsTheme {
  EbsTheme._();

  static TextStyle get _inter => GoogleFonts.inter();
  static TextStyle get mono => GoogleFonts.jetBrainsMono();

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: EbsColors.bgPrimary,
      colorScheme: const ColorScheme.dark(
        surface: EbsColors.bgPrimary,
        primary: EbsColors.accentGold,
        secondary: EbsColors.accentBlue,
        error: EbsColors.danger,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(EbsColors.textMuted),
        thickness: WidgetStateProperty.all(4),
        radius: const Radius.circular(2),
      ),
    );
  }

  // Text styles
  static TextStyle get labelXs => _inter.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    color: EbsColors.textMuted,
  );

  static TextStyle get labelSm => _inter.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: EbsColors.textSecondary,
  );

  static TextStyle get bodySm => _inter.copyWith(
    fontSize: 12,
    color: EbsColors.textSecondary,
  );

  static TextStyle get bodyBase => _inter.copyWith(
    fontSize: 13,
    color: EbsColors.textPrimary,
  );

  static TextStyle get monoSm => mono.copyWith(
    fontSize: 11,
    color: EbsColors.textSecondary,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static TextStyle get monoBase => mono.copyWith(
    fontSize: 12,
    color: EbsColors.textPrimary,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static TextStyle get monoLg => mono.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    color: EbsColors.textPrimary,
  );

  static TextStyle get sectionTitle => _inter.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.0,
    color: EbsColors.textMuted,
  );
}
