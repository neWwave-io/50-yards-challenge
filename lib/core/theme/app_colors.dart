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

  /// `green/moss/500` — progress accents on the home page.
  static const moss500 = Color(0xFF7CB342);

  /// `green/moss/700` — "See More" links.
  static const moss700 = Color(0xFF4F6529);

  /// `green/moss/900` — the big numbers on the progress cards.
  static const moss900 = Color(0xFF1F2A0F);

  /// `olive/200` — the knob of an active toggle.
  static const olive200 = Color(0xFFCED8B6);

  /// The darkest stop of the home header's gradient.
  static const olive800 = Color(0xFF344D24);

  // --- neutrals ---------------------------------------------------------
  /// `neutral text/100` — text on brand fills.
  static const neutralText100 = Color(0xFFEDEFE9);

  /// `neutral text/500` — secondary / meta text.
  static const neutralText500 = Color(0xFF737A6C);

  /// `neutral text/600` — the quietest supporting line on a screen.
  static const neutralText600 = Color(0xFF565C50);

  /// `neutral text/900` — headings on light surfaces.
  static const neutralText900 = Color(0xFF11140D);

  /// `neutral/500`
  static const neutral500 = Color(0xFF6B7263);

  /// `neutral/400` — the "20 days ago" pill.
  static const neutral400 = Color(0xFF9AA48C);

  /// `neutral/700` — a card's heading.
  static const neutral700 = Color(0xFF3D4337);

  /// `neutral/800`
  static const neutral800 = Color(0xFF2A2F24);

  /// `text/secondary` — supporting copy inside a card.
  static const textSecondary = Color(0xFF45483F);

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

  /// `OldColors/Neutral/Secondary Text` — announcement body and dates.
  static const inkMuted = Color(0xFF757575);

  // --- home page ---------------------------------------------------------

  /// A day of the week that was mowed.
  static const dayDone = Color(0xFF5A9E2F);

  /// Today, still in progress.
  static const dayToday = Color(0xFFFFC107);

  /// The ground of a day tile.
  static const dayTile = Color(0x80F4F9EC);

  /// The hairline around a day tile.
  static const dayTileBorder = Color(0xFFE2EBD4);

  /// The pulsing dot on the requested-lawn card.
  static const requestPulse = Color(0xFF42A645);

  /// The wash behind the challenge card, one per badge level in order.
  ///
  /// Each is the average colour of that level's shirt photo in the design,
  /// which the card blurs out to a tint. Laid over white at [badgeGlowOpacity]
  /// they read as the peach / green / violet / red / grey of the mock-ups.
  static const badgeGlows = [
    Color(0xFF6C290F),
    Color(0xFF0D3711),
    Color(0xFF1C0F6C),
    Color(0xFF5C1B1B),
    Color(0xFF141510),
  ];

  static const badgeGlowOpacity = 0.16;

  /// The home header's radial wash, lightest at the top left.
  static const headerWash = [olive500, olive700, olive800, olive900];

  /// The disc behind the avatar.
  static const avatarDisc = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF7DC142), Color(0xFF2D5A1B)],
  );

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
