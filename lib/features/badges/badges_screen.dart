import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_back_button.dart';
import 'badges_controller.dart';
import 'data/badge_data.dart';
import 'data/badges_repository.dart';
import 'widgets/badge_card.dart';
import 'widgets/badge_progress_card.dart';
import 'widgets/badge_tab_toggle.dart';
import 'widgets/request_badge_dialog.dart';

/// "Earned Badges": every badge an admin has set up, split into those under
/// way and those still locked, with a way to ask for one earned by service.
///
/// Navigation is injected, as on the home page.
class BadgesScreen extends StatefulWidget {
  const BadgesScreen({
    super.key,
    this.repository = const BadgesRepository(),
    this.onBack,
  });

  static const routeName = 'EarnedBadges';
  static const routePath = '/earnedBadges';

  final BadgesRepository repository;
  final VoidCallback? onBack;

  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen> {
  late final _controller = BadgesController(repository: widget.repository);

  @override
  void initState() {
    super.initState();
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _request(BadgesData data) async {
    final sent = await showRequestBadgeDialog(
      context,
      badges: data.requestable,
      onSubmit: (badge, explanation, photo) => _controller.requestBadge(
        badge: badge,
        explanation: explanation,
        photo: photo,
      ),
    );
    if (sent == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request sent. An admin will check it soon.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.olive50,
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            if (_controller.isFirstLoad) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.olive500),
              );
            }
            return RefreshIndicator(
              color: AppColors.olive500,
              onRefresh: _controller.load,
              child: _content(context),
            );
          },
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    final data = _controller.data;
    final onBack = widget.onBack;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        onBack == null ? AppSpacing.xl : 0,
        AppSpacing.xl,
        AppSpacing.huge + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        if (onBack != null)
          Transform.translate(
            // The back button carries its own gutter; line its arrow up with
            // the page's edge instead.
            offset: const Offset(-AppSpacing.xl, 0),
            child: AppBackButton(onTap: onBack),
          ),
        Text(
          'Earned Badges',
          textAlign: TextAlign.center,
          style: AppTypography.screenTitle,
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          'These badges celebrate the kindness, leadership, and service '
          'you’ve shown in your community',
          textAlign: TextAlign.center,
          style: AppTypography.statLabel,
        ),
        const SizedBox(height: AppSpacing.xl),
        if (data == null)
          _Message(
            title: 'We could not load your badges.',
            body: '${_controller.error}',
            onRetry: _controller.load,
          )
        else ...[
          BadgeProgressCard(
            earned: data.earnedCount,
            total: data.badges.length,
            onRequest: data.requestable.isEmpty ? null : () => _request(data),
          ),
          const SizedBox(height: AppSpacing.md),
          BadgeTabToggle(
            selected: _controller.tab,
            onSelect: _controller.selectTab,
          ),
          const SizedBox(height: AppSpacing.md),
          if (data.badges.isEmpty)
            const _Message(
              title: 'No badges yet',
              body: 'Badges will appear here once they are set up.',
            )
          else if (_controller.visible.isEmpty)
            _Message(
              title: _controller.tab == BadgeTab.earned
                  ? 'Nothing earned yet'
                  : 'Nothing locked',
              body: _controller.tab == BadgeTab.earned
                  ? 'Mow lawns to start on your first badge.'
                  : 'You have started on every badge.',
            )
          else
            _Grid(controller: _controller),
        ],
      ],
    );
  }
}

/// Two cards to a row.
class _Grid extends StatelessWidget {
  const _Grid({required this.controller});

  final BadgesController controller;

  @override
  Widget build(BuildContext context) {
    final badges = controller.visible;
    return Column(
      children: [
        for (var i = 0; i < badges.length; i += 2) ...[
          if (i > 0) const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _card(badges[i])),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: i + 1 < badges.length
                    ? _card(badges[i + 1])
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _card(ChallengeBadge badge) => BadgeCard(
        key: ValueKey(badge.id),
        badge: badge,
        flipped: controller.isFlipped(badge),
        onFlip: () => controller.flip(badge),
      );
}

class _Message extends StatelessWidget {
  const _Message({required this.title, required this.body, this.onRetry});

  final String title;
  final String body;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.huge),
        child: Column(
          children: [
            Text(title,
                textAlign: TextAlign.center, style: AppTypography.emptyTitle),
            const SizedBox(height: AppSpacing.sm),
            Text(body,
                textAlign: TextAlign.center, style: AppTypography.emptyBody),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              TextButton(onPressed: onRetry, child: const Text('Try again')),
            ],
          ],
        ),
      );
}
