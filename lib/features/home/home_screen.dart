import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'data/home_data.dart';
import 'data/home_repository.dart';
import 'home_controller.dart';
import 'widgets/activity_card.dart';
import 'widgets/announcement_card.dart';
import 'widgets/challenge_progress_card.dart';
import 'widgets/goal_progress_card.dart';
import 'widgets/home_header.dart';
import 'widgets/home_section.dart';
import 'widgets/mowed_for_grid.dart';
import 'widgets/passport_card.dart';
import 'widgets/requested_lawn_card.dart';
import 'widgets/training_hub_carousel.dart';

/// The home page.
///
/// Navigation is injected: the router supplies the callbacks so the feature
/// stays clear of the v1 route names.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.repository = const HomeRepository(),
    this.onStartMowing,
    this.onSeeAnnouncements,
    this.onOpenAnnouncement,
    this.onOpenBadges,
    this.onWatchTraining,
    this.bottomBar,
  });

  static const routeName = 'HomePage';
  static const routePath = '/homePage';

  final HomeRepository repository;
  final VoidCallback? onStartMowing;
  final VoidCallback? onSeeAnnouncements;
  final ValueChanged<Announcement>? onOpenAnnouncement;
  final VoidCallback? onOpenBadges;
  final ValueChanged<TrainingVideo>? onWatchTraining;

  /// The app's tab bar, pinned to the bottom.
  final Widget? bottomBar;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final _controller = HomeController(repository: widget.repository);

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
      // The Scaffold lays the body out above the bar, so the last card can
      // never end up underneath it.
      bottomNavigationBar: widget.bottomBar,
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (_controller.isFirstLoad) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.olive500),
            );
          }

          final data = _controller.data;
          if (data == null) {
            return _Failed(
              error: _controller.error,
              onRetry: _controller.load,
            );
          }

          return RefreshIndicator(
            color: AppColors.olive500,
            onRefresh: _controller.load,
            child: _Content(
              data: data,
              controller: _controller,
              screen: widget,
            ),
          );
        },
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.data,
    required this.controller,
    required this.screen,
  });

  final HomeData data;
  final HomeController controller;
  final HomeScreen screen;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The card overlaps the header's lower edge. Its top follows the
          // greeting rather than a fixed offset, so a taller status bar
          // pushes both down together instead of the card climbing over the
          // text.
          Stack(
            children: [
              HomeHeader(profile: data.profile),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.paddingOf(context).top +
                      4 +
                      HomeHeader.contentHeight +
                      14,
                  left: 20,
                  right: 20,
                ),
                child: ChallengeProgressCard(
                  profile: data.profile,
                  streak: data.streak,
                  onTap: screen.onOpenBadges,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, AppSpacing.lg, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GoalProgressCard(week: data.week),
                const SizedBox(height: AppSpacing.lg),
                RequestedLawnCard(
                  accepting: controller.acceptingRequests,
                  onToggle: controller.toggleAcceptingRequests,
                  onStartMowing: screen.onStartMowing,
                ),
                const SizedBox(height: AppSpacing.lg),
                PassportCard(
                  totalHours: data.profile.totalHours,
                  onOpen: screen.onStartMowing,
                ),
                const SizedBox(height: AppSpacing.lg),
                MowedForGrid(tallies: data.categories),
                const SizedBox(height: AppSpacing.lg),
                HomeSection(
                  title: 'Announcement',
                  onSeeMore: screen.onSeeAnnouncements,
                  child: data.announcements.isEmpty
                      ? const HomeSectionEmpty(message: 'Nothing posted yet.')
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final item in data.announcements) ...[
                              AnnouncementCard(
                                announcement: item,
                                onTap: screen.onOpenAnnouncement == null
                                    ? null
                                    : () => screen.onOpenAnnouncement!(item),
                              ),
                              if (item != data.announcements.last)
                                const SizedBox(height: AppSpacing.md),
                            ],
                          ],
                        ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                HomeSection(
                  title: 'Activity Feed',
                  child: data.activity.isEmpty
                      ? const HomeSectionEmpty(
                          message: 'No lawns have been finished yet.',
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final entry in data.activity) ...[
                              ActivityCard(entry: entry),
                              if (entry != data.activity.last)
                                const SizedBox(height: AppSpacing.md),
                            ],
                          ],
                        ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                HomeSection(
                  title: 'Training Hub',
                  subtitle: 'Stay up to date on how to safely and properly '
                      'complete your lawn services.',
                  child: data.training.isEmpty
                      ? const HomeSectionEmpty(
                          message: 'No training videos yet.',
                        )
                      : TrainingHubCarousel(
                          videos: data.training,
                          onWatch: screen.onWatchTraining,
                        ),
                ),
                const SizedBox(height: AppSpacing.huge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Failed extends StatelessWidget {
  const _Failed({required this.error, required this.onRetry});

  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'We could not load your challenge.',
                textAlign: TextAlign.center,
                style: AppTypography.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '$error',
                textAlign: TextAlign.center,
                style: AppTypography.caption,
              ),
              const SizedBox(height: AppSpacing.lg),
              TextButton(onPressed: onRetry, child: const Text('Try again')),
            ],
          ),
        ),
      );
}
