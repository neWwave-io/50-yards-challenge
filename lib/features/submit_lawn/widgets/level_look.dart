import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// How the "lawn logged" screen looks at each level: the colour of the
/// shirt the child has earned, or the plain page before the first one.
class LevelLook {
  const LevelLook._({
    required this.shirt,
    this.wash,
    this.washStop = 0.5,
    this.shirtOpacity = 0.3,
    this.caption = AppColors.neutral100,
    this.number = AppColors.olive100,
    this.track = const Color(0x33F4F7E9),
    this.fill = AppColors.olive100,
    this.levelLine = AppColors.neutral50,
  });

  /// Before the first level: the ordinary light page and a white shirt.
  static const starter = LevelLook._(
    shirt: 'assets/images/submit_lawn/shirt_starter.png',
    // The design dims the white shirt twice: 70% on the layer, 30% on the
    // image.
    shirtOpacity: 0.21,
    caption: AppColors.neutral500,
    number: AppColors.olive500,
    track: AppColors.olive150,
    fill: AppColors.olive500,
    levelLine: AppColors.neutral500,
  );

  /// Indexed by level rank: 1 Rookie (orange) … 5 Master (black).
  static const _levels = [
    LevelLook._(
      shirt: 'assets/images/submit_lawn/shirt_rookie.png',
      wash: AppColors.levelOrange,
      washStop: 0.625,
    ),
    LevelLook._(
      shirt: 'assets/images/submit_lawn/shirt_junior.png',
      wash: AppColors.levelGreen,
      washStop: 0.625,
    ),
    LevelLook._(
      shirt: 'assets/images/submit_lawn/shirt_super.png',
      wash: AppColors.levelBlue,
    ),
    LevelLook._(
      shirt: 'assets/images/submit_lawn/shirt_pro.png',
      wash: AppColors.levelRed,
    ),
    LevelLook._(
      shirt: 'assets/images/submit_lawn/shirt_master.png',
      wash: AppColors.levelBlack,
      washStop: 0.495,
      caption: AppColors.surface,
      number: AppColors.levelGold,
      track: AppColors.olive150,
      fill: AppColors.levelGold,
    ),
  ];

  /// The look for a level [rank]; null or 0 is [starter]. Ranks past the
  /// designed five keep the last one.
  static LevelLook forRank(int? rank) {
    if (rank == null || rank < 1) return starter;
    return _levels[(rank - 1).clamp(0, _levels.length - 1)];
  }

  final String shirt;

  /// Top, middle and bottom of the background; null is the plain page.
  final List<Color>? wash;

  /// Where the middle colour sits.
  final double washStop;

  final double shirtOpacity;
  final Color caption;
  final Color number;
  final Color track;
  final Color fill;
  final Color levelLine;

  bool get isColoured => wash != null;

  /// Light status-bar icons and Back on the coloured screens.
  Color? get chrome => isColoured ? AppColors.neutralText100 : null;

  Decoration get background => wash == null
      ? const BoxDecoration(color: AppColors.olive50)
      : BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: wash!,
            stops: [0, washStop, 1],
          ),
        );
}
