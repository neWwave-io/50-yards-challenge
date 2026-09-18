import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Type tokens for the v2 design system. The whole app is set in Onest.
abstract final class AppTypography {
  static TextStyle _onest({
    required double size,
    required FontWeight weight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) =>
      GoogleFonts.onest(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );

  /// 32 / SemiBold — screen title ("Sign Up").
  static TextStyle get displayLarge =>
      _onest(size: 32, weight: FontWeight.w600, height: 1, color: AppColors.olive500);

  /// 20 / SemiBold — section heading ("Personal Information").
  static TextStyle get titleMedium =>
      _onest(size: 20, weight: FontWeight.w600, height: 1, color: AppColors.neutralText900);

  /// 14 / Regular — input values and list options.
  static TextStyle get bodyMedium =>
      _onest(size: 14, weight: FontWeight.w400, color: AppColors.textDefault);

  /// 12 / Regular — buttons and supporting copy.
  static TextStyle get bodySmall =>
      _onest(size: 12, weight: FontWeight.w400, color: AppColors.neutralText900);

  /// 12 / SemiBold — step counter.
  static TextStyle get labelMedium =>
      _onest(size: 12, weight: FontWeight.w600, color: AppColors.neutralText500);

  /// 10 / Light — floating field label.
  static TextStyle get labelSmall =>
      _onest(size: 10, weight: FontWeight.w300, color: AppColors.textMuted);

  /// 10 / Regular — helper text under a field.
  static TextStyle get caption =>
      _onest(size: 10, weight: FontWeight.w400, color: AppColors.neutralText500);

  /// 14 / Regular — the line under a screen title.
  static TextStyle get subtitle =>
      _onest(size: 14, weight: FontWeight.w400, color: AppColors.neutralText500);

  /// 10 / Regular — the quietest supporting line on a screen.
  static TextStyle get footnote =>
      _onest(size: 10, weight: FontWeight.w400, color: AppColors.neutralText600);

  /// 16 / Regular — the "Back" affordance in the top bar.
  static TextStyle get navAction =>
      _onest(size: 16, weight: FontWeight.w400, color: AppColors.textMuted);

  /// 12 / Bold, upper-cased by the caller — "CHILD 1".
  static TextStyle get groupLabel =>
      _onest(size: 12, weight: FontWeight.w700, color: AppColors.olive700);

  /// 11 / Medium — the "Remove" affordance on a group card.
  static TextStyle get groupAction =>
      _onest(size: 11, weight: FontWeight.w500, color: AppColors.neutralText500);

  /// 12 / Regular — a value in a child's summary row.
  static TextStyle get summaryValue =>
      _onest(size: 12, weight: FontWeight.w400, color: AppColors.olive900);

  /// 12 / Medium — the key half of a summary row. The design dims it to 70%.
  static TextStyle get summaryKey => _onest(
        size: 12,
        weight: FontWeight.w500,
        color: AppColors.olive900.withValues(alpha: 0.7),
      );

  // --- date picker ------------------------------------------------------
  // The calendar comes from the Material kit and keeps that palette.

  /// 16 / SemiBold — "Set Date".
  static TextStyle get calendarTitle =>
      _onest(size: 16, weight: FontWeight.w600, color: AppColors.calendarInk);

  /// 12 / Medium — "August 2025".
  static TextStyle get calendarMonth => _onest(
        size: 12,
        weight: FontWeight.w500,
        color: AppColors.calendarInk,
        height: 20 / 12,
        letterSpacing: 0.1,
      );

  /// 12 / Regular — weekday initials and day numbers.
  static TextStyle get calendarDay => _onest(
        size: 12,
        weight: FontWeight.w400,
        color: AppColors.calendarInk,
        height: 24 / 12,
        letterSpacing: 0.5,
      );
}
