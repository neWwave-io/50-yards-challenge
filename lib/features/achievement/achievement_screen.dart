import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_tab_bar.dart';
import '../../core/widgets/app_primary_button.dart';
import 'achievement_controller.dart';
import 'data/achievement_repository.dart';
import 'widgets/lawn_card.dart';

/// The "Badges" tab: every lawn an admin has ruled on, newest first.
///
/// A lawn is `pending` from the moment it is submitted until someone reviews
/// it, and the design has no card for that state — so this page lists
/// reviewed work only. A child's newest submission appears here once it has
/// been approved or turned down.
///
/// Navigation is injected, as on the home page.
class AchievementScreen extends StatefulWidget {
  const AchievementScreen({
    super.key,
    this.repository = const AchievementRepository(),
    this.onEarnBadge,
    this.onSubmitLawn,
    this.bottomBar,
  });

  static const routeName = 'Achievement';
  static const routePath = '/achievement';

  final AchievementRepository repository;
  final VoidCallback? onEarnBadge;
  final VoidCallback? onSubmitLawn;

  /// The app's tab bar, pinned to the bottom.
  final Widget? bottomBar;

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  late final _controller = AchievementController(
    repository: widget.repository,
  );

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.olive50,
      // The bar floats over the page rather than standing on a strip of
      // its own, so the body runs the full height and the content
      // scrolls behind it. Each page pads its own foot by
      // AppTabBar.clearance so nothing comes to rest underneath.
      extendBody: true,
      bottomNavigationBar: widget.bottomBar,
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
              child: _Content(controller: _controller, screen: widget),
            );
          },
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.controller, required this.screen});

  final AchievementController controller;
  final AchievementScreen screen;

  /// From the status bar to the heading.
  static const _topGap = 20.0;

  @override
  Widget build(BuildContext context) {
    final lawns = controller.lawns;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        _topGap,
        AppSpacing.xl,
        AppTabBar.clearance(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _Heading(),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: AppPrimaryButton(
                  label: 'Earn Badge',
                  onPressed: screen.onEarnBadge,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: AppPrimaryButton(
                  label: 'Submit Lawn',
                  onPressed: screen.onSubmitLawn,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          if (controller.error != null && lawns.isEmpty)
            _Failed(error: controller.error, onRetry: controller.load)
          else if (lawns.isEmpty)
            const _NothingYet()
          else
            for (final lawn in lawns) ...[
              LawnCard(
                lawn: lawn,
                open: controller.isOpen(lawn),
                onToggle: () => controller.toggle(lawn),
              ),
              if (lawn != lawns.last) const SizedBox(height: AppSpacing.md),
            ],
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(
            'Achievement',
            textAlign: TextAlign.center,
            style: AppTypography.screenTitle,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Submit More Lawn to gain more achievement',
            textAlign: TextAlign.center,
            style: AppTypography.statLabel,
          ),
        ],
      );
}

/// No lawn has been reviewed yet — which is also what a child sees while
/// their first submission is still in the queue.
class _NothingYet extends StatelessWidget {
  const _NothingYet();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.huge),
        child: Column(
          children: [
            Text(
              'Nothing reviewed yet',
              textAlign: TextAlign.center,
              style: AppTypography.emptyTitle,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'A lawn shows up here once it has been checked. '
              'Submit one to get started.',
              textAlign: TextAlign.center,
              style: AppTypography.emptyBody,
            ),
          ],
        ),
      );
}

class _Failed extends StatelessWidget {
  const _Failed({required this.error, required this.onRetry});

  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.huge),
        child: Column(
          children: [
            Text(
              'We could not load your lawns.',
              textAlign: TextAlign.center,
              style: AppTypography.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '$error',
              textAlign: TextAlign.center,
              style: AppTypography.caption,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      );
}
