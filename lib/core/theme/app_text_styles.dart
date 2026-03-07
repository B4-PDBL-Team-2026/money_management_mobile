import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';

class AppTextStyles {
  static final String? fontFamily = GoogleFonts.plusJakartaSans().fontFamily;

  static final TextStyle display = GoogleFonts.plusJakartaSans(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 40 * -0.03,
    color: AppColors.bulma,
  );

  static final TextStyle h1 = GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: 24 * -0.01,
    color: AppColors.bulma,
  );

  static final TextStyle h2 = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 18 * 0,
    color: AppColors.bulma,
  );

  static final TextStyle subtitle = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 16 * 0,
    color: AppColors.bulma,
  );

  static final TextStyle bodyLarge = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 16 * 0,
    color: AppColors.bulma,
  );

  static final TextStyle bodyMain = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 14 * 0.01,
    color: AppColors.bulma,
  );

  static final TextStyle caption = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 12 * 0.02,
    color: AppColors.trunks,
  );

  static final TextStyle overline = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 12 * 0.05,
    color: AppColors.bulma,
  );
}
