import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_format.dart';
import '../data/admin_message.dart';

/// One message the family sent: the text in a bubble, its status in the
/// corner and the date underneath. Closed, the text is a single line; the
/// chevron opens it in full.
class PastMessageCard extends StatefulWidget {
  const PastMessageCard({super.key, required this.message});

  final AdminMessage message;

  @override
  State<PastMessageCard> createState() => _PastMessageCardState();
}

class _PastMessageCardState extends State<PastMessageCard> {
  var _open = false;

  @override
  Widget build(BuildContext context) {
    final message = widget.message;

    return Semantics(
      button: true,
      expanded: _open,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _open = !_open),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.row),
            boxShadow: AppShadows.field,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: AppSizes.messageTagInset,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.olive100,
                        borderRadius: BorderRadius.circular(AppRadii.row),
                      ),
                      child: Text(
                        message.body,
                        maxLines: _open ? null : 1,
                        overflow: _open ? null : TextOverflow.ellipsis,
                        style: AppTypography.messageBody,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: _StatusTag(status: message.status),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxs),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dayMonthYear(message.sentAt),
                    style: AppTypography.messageDate,
                  ),
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: SvgPicture.asset(
                      'assets/icons/contact_chevron.svg',
                      width: AppSizes.chevron,
                      height: AppSizes.chevron,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  const _StatusTag({required this.status});

  final AdminMessageStatus status;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: switch (status) {
            AdminMessageStatus.sent => AppColors.amber100,
            AdminMessageStatus.viewed => AppColors.successBg,
            AdminMessageStatus.deleted => AppColors.dangerBg,
          },
          borderRadius: BorderRadius.circular(AppRadii.tag),
        ),
        child: Text(status.label, style: AppTypography.badgeMeta),
      );
}
