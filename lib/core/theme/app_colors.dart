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

  /// `olive/150` — supporting copy on the dark header.
  static const olive150 = Color(0xFFE7EADF);

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

  /// `neutral text/300` — the knob of a switch that is off.
  static const neutralText300 = Color(0xFFC2C7B8);

  /// `neutral text/500` — secondary / meta text.
  static const neutralText500 = Color(0xFF737A6C);

  /// `neutral text/600` — the quietest supporting line on a screen.
  static const neutralText600 = Color(0xFF565C50);

  /// `neutral text/900` — headings on light surfaces.
  static const neutralText900 = Color(0xFF11140D);

  /// `icon/muted` — an idle tab in the tab bar.
  static const tabIcon = Color(0xFF6D7268);

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

  /// A ranked row's fill: the design's 50% white over the olive/50 page,
  /// flattened. Left translucent, the row's own shadow shows through it and
  /// turns it grey-green.
  static const rowFill = Color(0xFFFCFDFA);

  // --- empty states -----------------------------------------------------

  /// The pale disc behind an empty state's icon.
  static const emptyDisc = Color(0xFFEAF2DF);

  /// An empty state's heading.
  static const emptyTitle = Color(0xFF1F281B);

  /// An empty state's explanation.
  static const emptyBody = Color(0xFF778071);

  // --- profile page ------------------------------------------------------

  /// `olive/300` — the Elderly bar in the impact summary.
  static const olive300 = Color(0xFFABBE6B);

  /// `olive/400` — the First Responder bar.
  static const olive400 = Color(0xFF7E9A52);

  /// `green/emerald/800` — the Active Duty bar.
  static const emerald800 = Color(0xFF0F4F36);

  /// `legacy/text-green` — the knob on the Active Duty bar.
  static const legacyGreen = Color(0xFF2F7F33);

  /// The Disabled bar. Not yet a Figma variable.
  static const impactLime = Color(0xFF9EC258);

  /// The Veteran bar. Not yet a Figma variable.
  static const impactFern = Color(0xFF5E763D);

  /// The ground of a ranking tile.
  static const rankTile = Color(0xFFF0F4E8);

  /// "National" / "State" on a ranking tile.
  static const rankLabel = Color(0xFF7A8274);

  /// The position on a ranking tile, and the ranking card's heading.
  static const rankValue = Color(0xFF1D2718);

  /// The ink on a shirt tile.
  static const shirtInk = Color(0xFF21232A);

  /// The frosted disc behind the settings gear.
  static const gearDisc = Color(0xCCFAFBF6);

  // --- submit lawn ------------------------------------------------------
  /// `color/brand/primary` — the big step titles ("My Lawn").
  static const brandPrimary = Color(0xFF2F7F33);

  /// `accent/fresh-cut` — the chosen "Yes" on the safety check.
  static const freshCut = Color(0xFF5E8C1F);

  /// `red/500` — the "No" answer's ink and border, and a rejected lawn's
  /// status chip.
  static const red500 = Color(0xFFC0392B);

  /// The "No" answer's pale ground.
  static const redTint = Color(0xFFFBF5F4);

  // --- level washes -----------------------------------------------------
  // The "lawn logged" screen takes the colour of the child's shirt: none yet,
  // then orange, green, blue, red and black. Top, middle, bottom stops.

  /// Rookie Mower — the orange shirt.
  static const levelOrange = [Color(0xFFD3764D), Color(0xFFCC3E00), Color(0xFFD3764D)];

  /// Junior Mower — the green shirt.
  static const levelGreen = [Color(0xFF4A7B64), Color(0xFF005A31), Color(0xFF4A7B64)];

  /// Super Mower — `tier/tier-shirt/4-blue`.
  static const levelBlue = [Color(0xFF4169A8), Color(0xFF0E4091), Color(0xFF4169A8)];

  /// Pro Cutter — `tier/tier-shirt/5-red`.
  static const levelRed = [Color(0xFFCA5D61), Color(0xFF9F191D), Color(0xFFAE4347)];

  /// Master Cutter — `tier/tier-shirt/6-black`.
  static const levelBlack = [Color(0xFF322F2F), Color(0xFF312D2D), Color(0xFF373434)];

  /// The gold number and bar on the black screen.
  static const levelGold = Color(0xFFFFC000);

  /// `neutral/100` — the small caps line on a coloured screen, and the
  /// track of the badge progress bar.
  static const neutral100 = Color(0xFFEDF1E4);

  /// `neutral/50` — the level line on a coloured screen.
  static const neutral50 = Color(0xFFF8FBF5);

  /// The passport card's second line.
  static const passportInk = Color(0xFF3E5745);

  // --- badges -----------------------------------------------------------

  /// `color/brand/accent-subtle` — the track under a badge card's footer.
  static const accentSubtle = Color(0xFFDBEFDD);

  /// The knob riding the end of the badge progress bar.
  static const badgeKnob = Color(0x263A6618);

  // --- status -----------------------------------------------------------
  /// `amber/500` — "Pending".
  static const amber500 = Color(0xFFFFC107);

  /// `status/Danger/danger`
  static const danger = Color(0xFFDB3B3B);

  /// The ground of a status chip. Figma lays each tint over the card at
  /// half strength, and its border is the matching ink at the same. The
  /// design publishes these two only — a lawn still awaiting review never
  /// reaches the achievement page.
  static const statusApprovedFill = Color(0x80DBEFDD);
  static const statusRejectedFill = Color(0x80F7DDD9);

  /// Not yet a Figma variable — introduced for the mid password-strength
  /// step. Replace with the token once design publishes one.
  static const warning = Color(0xFFE0A52E);

  /// Not yet a Figma variable — the strong password-strength step.
  static const success = olive500;

  // --- achievement page --------------------------------------------------

  /// A card's ground: half-opacity white over the olive page.
  static const cardGlass = Color(0x80FFFFFF);

  /// The hairline around a submitted photo. `legacy/text-green` at half.
  static const photoBorder = Color(0x802F7F33);

  // --- contact admin ----------------------------------------------------

  /// `amber/100` — the edge of the "Replies are disabled" banner, and the
  /// tag on a message nobody has opened yet.
  static const amber100 = Color(0xFFFFF2CC);

  /// `color/feedback/success-bg` — the "Viewed" tag.
  static const successBg = Color(0xFFDBEFDD);

  /// `color/feedback/danger-bg` — the "Deleted" tag.
  static const dangerBg = Color(0xFFF7DDD9);

  // --- gradients --------------------------------------------------------
  /// `Customer/gradient/brand-fill` — primary button fill.
  static const brandFill = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [olive500, olive700],
  );

  /// A button that leads nowhere, as on a rejected lawn. Figma's two greys,
  /// each at half.
  static const disabledFill = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x80A6A6A6), Color(0x80737373)],
  );
}
