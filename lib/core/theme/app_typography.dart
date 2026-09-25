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

  // --- home page --------------------------------------------------------

  /// 24 / Bold — "Hi, Marcus".
  static TextStyle get greeting => _onest(
        size: 24,
        weight: FontWeight.w700,
        color: const Color(0xFFF5F5F5),
      );

  /// 12 / Medium — the line above the greeting.
  static TextStyle get greetingMeta =>
      _onest(size: 12, weight: FontWeight.w500, color: AppColors.surface);

  /// 16 / Bold — a card's heading.
  static TextStyle get cardTitle =>
      _onest(size: 16, weight: FontWeight.w700, color: AppColors.neutral700);

  /// 16 / Bold — a section heading above a list.
  static TextStyle get sectionTitle =>
      _onest(size: 16, weight: FontWeight.w700, color: AppColors.textDefault);

  /// 14 / Regular — "See More".
  static TextStyle get link =>
      _onest(size: 14, weight: FontWeight.w400, color: AppColors.moss700);

  /// 64 / Bold — lawns done, on the challenge ring.
  static TextStyle get ringNumber =>
      _onest(size: 64, weight: FontWeight.w700, color: AppColors.moss900, height: 1);

  /// 40 / Black — the badge level.
  static TextStyle get levelNumber =>
      _onest(size: 40, weight: FontWeight.w900, color: AppColors.moss900, height: 1);

  /// 24 / Regular — a stat's value.
  static TextStyle get statValue =>
      _onest(size: 24, weight: FontWeight.w400, color: AppColors.textDefault);

  /// 12 / Regular — a stat's label.
  static TextStyle get statLabel =>
      _onest(size: 12, weight: FontWeight.w400, color: AppColors.textMuted);

  /// 9 / SemiBold — the weekday initials on the goal tracker.
  static TextStyle get dayLabel =>
      _onest(size: 9, weight: FontWeight.w600, color: AppColors.inkMuted);

  /// 11 / Bold — "THIS WEEK".
  static TextStyle get overline =>
      _onest(size: 11, weight: FontWeight.w700, color: AppColors.calendarInk, height: 1.4);

  /// 11 / SemiBold — "5 / 7 days".
  static TextStyle get overlineValue =>
      _onest(size: 11, weight: FontWeight.w600, color: AppColors.moss500);

  /// 16 / Bold — an announcement's title.
  static TextStyle get itemTitle =>
      _onest(size: 16, weight: FontWeight.w700, color: AppColors.calendarInk);

  /// 12 / Regular — an announcement's body.
  static TextStyle get itemBody =>
      _onest(size: 12, weight: FontWeight.w400, color: AppColors.inkMuted);

  /// 10 / Regular — an announcement's date.
  static TextStyle get itemMeta =>
      _onest(size: 10, weight: FontWeight.w400, color: AppColors.inkMuted, height: 1.5);

  // --- leaderboard ------------------------------------------------------

  /// 36 / SemiBold — "Leaderboard" on the dark header.
  static TextStyle get headerTitle =>
      _onest(size: 36, weight: FontWeight.w600, color: AppColors.surface);

  /// 16 / Bold — "National Top 5".
  static TextStyle get headerCardTitle =>
      _onest(size: 16, weight: FontWeight.w700, color: AppColors.surface);

  /// 12 / Regular — the line under "National Top 5".
  static TextStyle get headerCardSubtitle =>
      _onest(size: 12, weight: FontWeight.w400, color: AppColors.olive150);

  /// 10 / Bold — a name on the podium.
  static TextStyle get podiumName =>
      _onest(size: 10, weight: FontWeight.w700, color: AppColors.surface);

  /// 10 / Regular — "15 lawns" on the podium.
  static TextStyle get podiumTag => _onest(
        size: 10,
        weight: FontWeight.w400,
        color: AppColors.olive600,
        height: 1,
      );

  /// 20 / Bold — "Participants".
  static TextStyle get sectionHeading =>
      _onest(size: 20, weight: FontWeight.w700, color: AppColors.textDefault);

  /// 24 / Bold — the position number on a ranked row.
  static TextStyle get rankNumber => _onest(
        size: 24,
        weight: FontWeight.w700,
        color: AppColors.olive500,
        height: 1.2,
      );

  /// 16 / Bold — a name on a ranked row.
  static TextStyle get rankName =>
      _onest(size: 16, weight: FontWeight.w700, color: AppColors.olive500);

  /// 12 / Bold — "Mowed Lawn 9" on a ranked row.
  static TextStyle get rankDetail =>
      _onest(size: 12, weight: FontWeight.w700, color: AppColors.olive500);

  /// 20 / Bold — "Me" on the signed-in child's row.
  static TextStyle get rankNameMine => _onest(
        size: 20,
        weight: FontWeight.w700,
        color: AppColors.surface,
        height: 1.2,
      );

  /// 14 / Bold — the detail line on the signed-in child's row.
  static TextStyle get rankDetailMine => _onest(
        size: 14,
        weight: FontWeight.w700,
        color: AppColors.surface,
        height: 1.2,
      );

  // --- profile ----------------------------------------------------------

  /// 14 / SemiBold — the guardian's name.
  static TextStyle get profileValue =>
      _onest(size: 14, weight: FontWeight.w600, color: AppColors.neutralText900);

  /// 12 / Bold — the number on a child's row.
  static TextStyle get childIndex => _onest(
        size: 12,
        weight: FontWeight.w700,
        color: AppColors.olive600,
        height: 1.2,
      );

  /// 14 / Regular — the count riding the end of an impact bar.
  static TextStyle get impactCount => _onest(
        size: 14,
        weight: FontWeight.w400,
        color: AppColors.surface,
        height: 1.2,
      );

  /// 16 / SemiBold — the total in the impact summary's corner.
  static TextStyle get impactTotal => _onest(
        size: 16,
        weight: FontWeight.w600,
        color: AppColors.olive900,
        height: 1.2,
      );

  /// 12 / Bold — "Latest Badge".
  static TextStyle get badgeHeading =>
      _onest(size: 12, weight: FontWeight.w700, color: AppColors.textDefault);

  /// 10 / Bold — a badge's name.
  static TextStyle get badgeName =>
      _onest(size: 10, weight: FontWeight.w700, color: AppColors.textDefault);

  /// 8 / Regular — a badge's description and award date.
  static TextStyle get badgeMeta =>
      _onest(size: 8, weight: FontWeight.w400, color: AppColors.textMuted);

  /// 12 / Regular — "National" on a ranking tile.
  static TextStyle get rankTileLabel =>
      _onest(size: 12, weight: FontWeight.w400, color: AppColors.rankLabel);

  /// 14 / Bold — "# 10" on a ranking tile.
  static TextStyle get rankTileValue =>
      _onest(size: 14, weight: FontWeight.w700, color: AppColors.rankValue);

  /// 16 / Bold — "Shirt" on the current-shirt tile.
  static TextStyle get shirtTitle =>
      _onest(size: 16, weight: FontWeight.w700, color: AppColors.shirtInk);

  /// 12 / Medium — "10 lawns to next shirt".
  static TextStyle get shirtCaption =>
      _onest(size: 12, weight: FontWeight.w500, color: AppColors.shirtInk);

  // --- achievement page --------------------------------------------------

  /// 32 / SemiBold — "Achievement", the page's own heading.
  static TextStyle get screenTitle =>
      _onest(size: 32, weight: FontWeight.w600, color: AppColors.textDefault);

  /// 12 / Medium — the left half of a row on a lawn card.
  static TextStyle get detailLabel =>
      _onest(size: 12, weight: FontWeight.w500, color: AppColors.textMuted);

  /// 14 / SemiBold — the value half. Dimmed to `neutral/400` on a lawn that
  /// was turned down.
  static TextStyle get detailValue =>
      _onest(size: 14, weight: FontWeight.w600, color: AppColors.olive600);

  /// 10 / SemiBold — the notch label over a submitted photo.
  static TextStyle get photoLabel =>
      _onest(size: 10, weight: FontWeight.w600, color: AppColors.olive600);

  /// 12 / SemiBold — "Safety check".
  static TextStyle get safetyLabel =>
      _onest(size: 12, weight: FontWeight.w600, color: AppColors.textMuted);

  /// 10 / SemiBold — the "Yes" the child answered with.
  static TextStyle get safetyAnswer =>
      _onest(size: 10, weight: FontWeight.w600, color: AppColors.olive500);

  // --- badges -----------------------------------------------------------

  /// 12 / Bold — a badge's name on its card.
  static TextStyle get badgeCardName =>
      _onest(size: 12, weight: FontWeight.w700, color: AppColors.textDefault);

  /// 12 / Medium — "Completed" / "4 /9 completed" under a badge.
  static TextStyle get badgeFooter =>
      _onest(size: 12, weight: FontWeight.w500, color: AppColors.textMuted);

  /// 10 / Regular — the description on the back of a badge card.
  static TextStyle get badgeBack =>
      _onest(size: 10, weight: FontWeight.w400, color: AppColors.textMuted);

  /// 12 / SemiBold — "5/54" beside "Badges Earned".
  static TextStyle get badgeTally =>
      _onest(size: 12, weight: FontWeight.w600, color: AppColors.textMuted);

  /// 14 / SemiBold — the selected half of the Earned / Locked toggle.
  static TextStyle get segmentActive =>
      _onest(size: 14, weight: FontWeight.w600, color: AppColors.surface);

  /// 14 / Regular — the other half.
  static TextStyle get segmentIdle =>
      _onest(size: 14, weight: FontWeight.w400, color: AppColors.textDefault);

  /// 20 / SemiBold — a dialog's title ("Request a Badge").
  static TextStyle get dialogTitle =>
      _onest(size: 20, weight: FontWeight.w600, color: AppColors.textDefault);

  // --- empty states -----------------------------------------------------

  /// 12 / Medium — the amber "Pending" status.
  static TextStyle get statusPending =>
      _onest(size: 12, weight: FontWeight.w500, color: AppColors.amber500);

  /// 12 / Medium — the olive "Approved" status.
  static TextStyle get statusApproved =>
      _onest(size: 12, weight: FontWeight.w500, color: AppColors.olive500);

  /// 12 / Medium — the red "Rejected" status.
  static TextStyle get statusRejected =>
      _onest(size: 12, weight: FontWeight.w500, color: AppColors.red500);

  /// 16 / Bold — "No participants yet".
  static TextStyle get emptyTitle => _onest(
        size: 16,
        weight: FontWeight.w700,
        color: AppColors.emptyTitle,
        height: 1.15,
      );

  /// 13 / Regular — the line under an empty state's heading.
  static TextStyle get emptyBody => _onest(
        size: 13,
        weight: FontWeight.w400,
        color: AppColors.emptyBody,
        height: 1.4,
      );

  /// 12 / Regular — a card's supporting line inside an empty state.
  static TextStyle get emptyCaption => _onest(
        size: 12,
        weight: FontWeight.w400,
        color: AppColors.emptyBody,
        height: 1.4,
      );

  // --- submit lawn ------------------------------------------------------

  /// 36 / SemiBold — a submit step's title ("My Lawn").
  static TextStyle get stepTitle => _onest(
        size: 36,
        weight: FontWeight.w600,
        color: AppColors.brandPrimary,
        height: 1.27,
      );

  /// 16 / Regular — a question or section label on a form step.
  static TextStyle get prompt =>
      _onest(size: 16, weight: FontWeight.w400, color: AppColors.textDefault);

  /// 12 / Regular — a tile's caption ("Veteran").
  static TextStyle get tileLabel =>
      _onest(size: 12, weight: FontWeight.w400, color: AppColors.textDefault);

  /// 12 / SemiBold — "Yes" / "No".
  static TextStyle get answerLabel =>
      _onest(size: 12, weight: FontWeight.w600, color: AppColors.surface);

  /// 14 / Regular — the label of a large call to action ("Start Mowing").
  static TextStyle get buttonLarge => _onest(
        size: 14,
        weight: FontWeight.w400,
        color: AppColors.neutralText100,
      );

  /// 13 / Regular — "LAWN #18 LOGGED" and the level line.
  static TextStyle get loggedCaption =>
      _onest(size: 13, weight: FontWeight.w400, color: AppColors.neutral500);

  /// 132 / SemiBold — the lawn count on the logged screen.
  static TextStyle get loggedNumber => _onest(
        size: 132,
        weight: FontWeight.w600,
        color: AppColors.olive500,
        height: 1,
      );

  /// 24 / Bold — "Keep Going!".
  static TextStyle get loggedCheer =>
      _onest(size: 24, weight: FontWeight.w700, color: AppColors.olive500);

  /// 14 / Bold — "+1.5 hrs on your Passport".
  static TextStyle get passportTitle =>
      _onest(size: 14, weight: FontWeight.w700, color: AppColors.textDefault);

  /// 12 / Regular — "26.5 verified hours · pending".
  static TextStyle get passportBody =>
      _onest(size: 12, weight: FontWeight.w400, color: AppColors.passportInk);

  // --- contact admin ----------------------------------------------------

  /// 11 / SemiBold — "Replies are disabled".
  static TextStyle get bannerTitle =>
      _onest(size: 11, weight: FontWeight.w600, color: AppColors.textDefault);

  /// 12 / SemiBold — "Past Messages".
  static TextStyle get listHeading =>
      _onest(size: 12, weight: FontWeight.w600, color: AppColors.textDefault);

  /// 12 / Regular — a message's text, and the message box's placeholder.
  static TextStyle get messageBody =>
      _onest(size: 12, weight: FontWeight.w400, color: AppColors.textMuted);

  /// 8 / Regular — the date under a past message.
  static TextStyle get messageDate => _onest(
        size: 8,
        weight: FontWeight.w400,
        color: AppColors.textMuted,
        height: 1.5,
      );

  // --- tab bar ----------------------------------------------------------

  /// 12.5 / SemiBold — the active tab's label.
  static TextStyle get tabLabel =>
      _onest(size: 12.5, weight: FontWeight.w600, color: AppColors.surface);

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
