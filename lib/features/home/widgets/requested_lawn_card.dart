import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_primary_button.dart';

/// Neighbours nearby who asked for help.
///
/// The design's note: with the toggle on, requests are taken from the map;
/// with it off, a lawn is submitted by hand. There is no table of requests
/// yet, so the count is honest about having nothing to show and the toggle
/// only holds its position for the session.
class RequestedLawnCard extends StatelessWidget {
  const RequestedLawnCard({
    super.key,
    required this.accepting,
    required this.onToggle,
    this.requestCount,
    this.onStartMowing,
  });

  final bool accepting;
  final VoidCallback onToggle;

  /// Null while there is no source of requests.
  final int? requestCount;

  final VoidCallback? onStartMowing;

  @override
  Widget build(BuildContext context) {
    final count = requestCount;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const _PulsingPin(),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Requested Lawn',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.neutralText900,
                      ),
                    ),
                    Text(
                      count == null
                          ? 'No nearby requests yet'
                          : '$count nearby requests',
                      style: AppTypography.caption
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              _Toggle(value: accepting, onTap: onToggle),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Neighbors in your state who need a hand with their lawn.',
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          AppPrimaryButton(label: 'Start Mowing', onPressed: onStartMowing),
        ],
      ),
    );
  }
}

class _PulsingPin extends StatelessWidget {
  const _PulsingPin();

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: 29,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7DDE50).withValues(alpha: 0.3),
              ),
            ),
            SvgPicture.asset(
              'assets/icons/home_request_icon.svg',
              width: 20,
              height: 20,
            ),
          ],
        ),
      );
}

class _Toggle extends StatelessWidget {
  const _Toggle({required this.value, required this.onTap});

  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      label: 'Take lawn requests from the map',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 42,
          height: 24,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: value ? AppColors.olive500 : AppColors.borderDefault,
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value ? AppColors.olive200 : AppColors.surface,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x26000000),
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
