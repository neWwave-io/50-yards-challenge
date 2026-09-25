/// Spacing and radius tokens for the v2 design system.
abstract final class AppSpacing {
  static const xxs = 4.0;
  static const xs = 6.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;
  static const huge = 40.0;

  /// 10 — the odd one out of the scale, and the only place the design uses
  /// it: the gap between the rows on a lawn card.
  static const rowGap = 10.0;
}

/// Corner radii.
abstract final class AppRadii {
  static const field = 16.0;
  static const summaryRow = 12.0;
  static const dropdown = 24.0;
  static const dialog = 32.0;
  static const card = 16.0;
  static const chip = 41.0;
  static const pill = 999.0;

  /// A ranked row on the leaderboard.
  static const row = 24.0;

  /// The small lawn-count tag on the podium.
  static const tag = 12.0;

  /// A tile inside a profile card — the badge and shirt tiles.
  static const tile = 24.0;

  /// A checkbox's corners.
  static const checkbox = 8.0;

  /// The footer pill on a badge card.
  static const badgeFooter = 28.0;

  /// The badge progress bar.
  static const progressTrack = 14.0;

  /// The selected half of a two-way toggle.
  static const segment = 20.0;

  /// A detail row and a status chip on a lawn card.
  static const detailRow = 10.0;

  /// The lawn card itself.
  static const lawnCard = 24.0;
}

/// Fixed control sizes taken from the design.
abstract final class AppSizes {
  static const fieldHeight = 52.0;
  static const buttonHeight = 42.0;
  static const icon = 16.0;
  static const photo = 100.0;
  static const calendarCell = 40.0;
  static const tabBarHeight = 64.0;
  static const photoSlotHeight = 180.0;
  static const answerHeight = 50.0;
  static const noteHeight = 100.0;
  static const progressBar = 12.0;
  static const tabIcon = 24.0;

  /// An unselected tab's icon, a step down so the current tab stands out.
  static const tabIconIdle = 20.0;

  /// A proof photo on a lawn card, two to a row.
  static const lawnPhotoHeight = 120.0;

  /// The safety photo, which runs the full width.
  static const safetyPhotoHeight = 140.0;

  /// The "View" pill that opens a lawn card.
  static const viewButtonHeight = 28.0;

  /// A square icon button — the sort toggle, the banner's icon disc.
  static const iconButton = 32.0;

  /// The contact-admin message box.
  static const messageBoxHeight = 120.0;

  /// How far a past message's bubble stops short of the card's edge, so its
  /// status tag can sit in the corner.
  static const messageTagInset = 30.0;

  /// The chevron that opens a past message.
  static const chevron = 14.0;

  /// The round floating button on the profile page.
  static const fab = 56.0;
  static const fabIcon = 24.0;
}
