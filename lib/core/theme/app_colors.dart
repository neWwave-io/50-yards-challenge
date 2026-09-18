import 'package:flutter/material.dart';

/// Colour tokens for the v2 design system.
///
/// Every value here maps 1:1 to a Figma variable. Feature code must never
/// hardcode a colour — add the token here and reference it instead.
abstract final class AppColors {
  // --- olive ------------------------------------------------------------
  /// `olive/50` — app background.
  static const olive50 = Color(0xFFFAFBF6);

  /// `olive/100` — dropdown dividers and hairline.
  static const olive100 = Color(0xFFF4F7E9);

  /// `olive/500` — primary brand.
  static const olive500 = Color(0xFF628041);

  /// `olive/600` — active field label.
  static const olive600 = Color(0xFF577E3D);

  /// `olive/700` — primary gradient end.
  static const olive700 = Color(0xFF496B34);

  /// `olive/900` — text inside dropdowns and summary rows.
  static const olive900 = Color(0xFF1F2E14);

  /// `green/moss/50` — the add-a-child card's ground.
  static const moss50 = Color(0xFFF3F8EC);

  // --- neutrals ---------------------------------------------------------
  /// `neutral text/100` — text on brand fills.
  static const neutralText100 = Color(0xFFEDEFE9);

  /// `neutral text/500` — secondary / meta text.
  static const neutralText500 = Color(0xFF737A6C);

  /// `neutral text/900` — headings on light surfaces.
  static const neutralText900 = Color(0xFF11140D);

  /// `neutral/500`
  static const neutral500 = Color(0xFF6B7263);

  // --- semantic surfaces ------------------------------------------------
  /// `color/surface/default`
  static const surface = Color(0xFFFFFFFF);

  /// `color/text/default` — value text inside inputs.
  static const textDefault = Color(0xFF1A1F14);

  /// `color/text/muted` — placeholders and resting field labels.
  static const textMuted = Color(0xFF6B7263);

  /// `color/border/default` — resting input border.
  static const borderDefault = Color(0xFFDCE3D0);

  /// Input border while the field has focus.
  static const borderFocused = Color(0x80628041);

  /// `OldColors/Neutral/Primary Text` — the Material date picker's ink. Kept
  /// only where that component's own palette applies.
  static const calendarInk = Color(0xFF212121);

  // --- status -----------------------------------------------------------
  /// `status/Danger/danger`
  static const danger = Color(0xFFDB3B3B);

  /// Not yet a Figma variable — introduced for the mid password-strength
  /// step. Replace with the token once design publishes one.
  static const warning = Color(0xFFE0A52E);

  /// Not yet a Figma variable — the strong password-strength step.
  static const success = olive500;

  // --- gradients --------------------------------------------------------
  /// `Customer/gradient/brand-fill` — primary button fill.
  static const brandFill = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [olive500, olive700],
  );
}
