import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/app_scroll_page.dart';
import '../data/submit_result.dart';
import 'level_look.dart';

/// "Lawn #18 logged" — shown straight after a submit, while the lawn is
/// still pending review. It takes the colour of the level the lawn reaches.
class LawnLoggedView extends StatelessWidget {
  const LawnLoggedView({super.key, required this.result, required this.onDone});

  final SubmitResult result;
  final VoidCallback onDone;

  /// What the child is called before the first level.
  static const starterName = 'Starter Baby';

  /// The shirt sits off to the right, as large as the design draws it.
  static const _shirtLeft = 127.0;
  static const _shirtSize = 433.0;

  @override
  Widget build(BuildContext context) {
    final look = LevelLook.forRank(result.level?.rank);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: look.isColoured
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: DecoratedBox(
        decoration: look.background,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBackButton(onTap: onDone, color: look.chrome),
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      left: _shirtLeft,
                      top: 0,
                      width: _shirtSize,
                      height: _shirtSize,
                      child: IgnorePointer(
                        child: Opacity(
                          opacity: look.shirtOpacity,
                          child: Image.asset(look.shirt, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    // Scrolls rather than overflowing on a small phone or at a
                    // large text size.
                    Positioned.fill(
                      child: AppScrollPage(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.xl,
                          0,
                          AppSpacing.xl,
                          AppSpacing.sm,
                        ),
                        body: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _Tally(result: result, look: look),
                            const SizedBox(height: AppSpacing.xl),
                            _PassportCard(result: result),
                            const SizedBox(height: AppSpacing.xl),
                          ],
                        ),
                        footer: look.isColoured
                            ? _WhiteButton(label: 'Done', onTap: onDone)
                            : AppPrimaryButton(
                                label: 'Done',
                                large: true,
                                onPressed: onDone,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The count, "Keep Going!", the bar and the level line.
class _Tally extends StatelessWidget {
  const _Tally({required this.result, required this.look});

  final SubmitResult result;
  final LevelLook look;

  @override
  Widget build(BuildContext context) {
    final level = result.level;
    final number = result.lawnNumber;
    final caption = AppTypography.loggedCaption.copyWith(color: look.levelLine);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          const SizedBox(height: 17),
          Text(
            number == null ? 'LAWN LOGGED' : 'LAWN #$number LOGGED',
            style: AppTypography.loggedCaption.copyWith(color: look.caption),
          ),
          const SizedBox(height: AppSpacing.md),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              number == null ? '✓' : '$number',
              style: AppTypography.loggedNumber.copyWith(color: look.number),
            ),
          ),
          Text(
            'Keep Going!',
            style: AppTypography.loggedCheer.copyWith(color: look.number),
          ),
          const SizedBox(height: AppSpacing.md),
          _ProgressBar(value: result.progress, look: look),
          const SizedBox(height: AppSpacing.md),
          Text.rich(
            TextSpan(
              style: caption,
              children: [
                TextSpan(
                  text: result.leveledUp
                      ? 'You have leveled up to a '
                      : 'You are currently a ',
                ),
                TextSpan(
                  text: level?.name ?? LawnLoggedView.starterName,
                  style: caption.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.value, required this.look});

  final double value;
  final LevelLook look;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${(value * 100).round()}% of the way to fifty lawns',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.pill),
        child: SizedBox(
          width: double.infinity,
          height: AppSizes.progressBar,
          child: Stack(
            children: [
              Positioned.fill(child: ColoredBox(color: look.track)),
              FractionallySizedBox(
                widthFactor: value,
                heightFactor: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: look.fill,
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PassportCard extends StatelessWidget {
  const _PassportCard({required this.result});

  final SubmitResult result;

  static const _bookletHeight = 40.0;
  static const _bookletWidth = _bookletHeight * 472 / 706;

  static String _hours(double h) =>
      h == h.roundToDouble() ? h.toStringAsFixed(0) : '$h';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xxl,
      ),
      decoration: BoxDecoration(
        color: AppColors.olive100.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // As tall as the two lines beside it, as in the design.
          Image.asset(
            'assets/images/submit_lawn/passport.png',
            width: _bookletWidth,
            height: _bookletHeight,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '+${_hours(result.hoursAdded)} hrs on your Passport',
                  style: AppTypography.passportTitle,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${_hours(result.verifiedHours)} verified hours · pending',
                  style: AppTypography.passportBody,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The white Done pill of the coloured screens.
class _WhiteButton extends StatelessWidget {
  const _WhiteButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: AppSizes.buttonHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.pill),
          boxShadow: AppShadows.buttonOnColour,
        ),
        child: Text(
          label,
          style: AppTypography.buttonLarge.copyWith(color: AppColors.olive600),
        ),
      ),
    );
  }
}
