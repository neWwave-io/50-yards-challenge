import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_tab_bar.dart';
import '../home/widgets/challenge_progress_card.dart';
import '../home/widgets/home_header.dart';
import 'data/profile_data.dart';
import 'data/profile_repository.dart';
import 'profile_controller.dart';
import 'widgets/badge_progression_card.dart';
import 'widgets/contact_admin_button.dart';
import 'widgets/family_card.dart';
import 'widgets/impact_summary_card.dart';
import 'widgets/latest_badge_card.dart';
import 'widgets/my_ranking_card.dart';
import 'widgets/nearby_families_card.dart';
import 'widgets/settings_button.dart';

/// The "Me" tab: the home page's header and challenge card, then the family,
/// their impact, badges, ranking and shirts.
///
/// Navigation is injected, as on the home page.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    this.repository = const ProfileRepository(),
    this.onOpenSettings,
    this.onAddChild,
    this.onOpenBadges,
    this.onOpenLeaderboard,
    this.onContactAdmin,
    this.bottomBar,
  });

  // Kept from v1 so existing links still land here.
  static const routeName = 'ProfilePage';
  static const routePath = '/profilePage';

  final ProfileRepository repository;
  final VoidCallback? onOpenSettings;
  final VoidCallback? onAddChild;
  final VoidCallback? onOpenBadges;
  final VoidCallback? onOpenLeaderboard;

  /// Shows the floating contact-admin button when set.
  final VoidCallback? onContactAdmin;

  /// The app's tab bar, pinned to the bottom.
  final Widget? bottomBar;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final _controller = ProfileController(repository: widget.repository);

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
    final onContactAdmin = widget.onContactAdmin;

    return Scaffold(
      backgroundColor: AppColors.olive50,
      // The bar floats over the page rather than standing on a strip of
      // its own, so the body runs the full height and the content
      // scrolls behind it. Each page pads its own foot by
      // AppTabBar.clearance so nothing comes to rest underneath.
      extendBody: true,
      bottomNavigationBar: widget.bottomBar,
      floatingActionButton: onContactAdmin == null
          ? null
          : ContactAdminButton(onTap: onContactAdmin),
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
            return _Failed(error: _controller.error, onRetry: _controller.load);
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

  final ProfileData data;
  final ProfileController controller;
  final ProfileScreen screen;

  /// The profile's avatar is larger than home's and sits lower in the banner.
  static const _avatarSize = 100.0;
  static const _topGap = 27.0;

  /// From the bottom of the avatar row to the top of the progress card.
  static const _cardGap = 24.0;

  @override
  Widget build(BuildContext context) {
    final onSettings = screen.onOpenSettings;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // As on home, the card's top follows the avatar row, so a taller
          // status bar moves both together.
          Stack(
            children: [
              HomeHeader(
                profile: data.profile,
                availability: data.availability,
                avatarSize: _avatarSize,
                topGap: _topGap,
                gradient: AppColors.brandFill,
                trailing: onSettings == null
                    ? null
                    : SettingsButton(onTap: onSettings),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.paddingOf(context).top +
                      _topGap +
                      _avatarSize +
                      _cardGap,
                  left: AppSpacing.xl,
                  right: AppSpacing.xl,
                ),
                child: ChallengeProgressCard(
                  profile: data.profile,
                  streak: data.streak,
                  title: 'Progress Overview',
                  ringShowsPercent: true,
                  onTap: screen.onOpenBadges,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.xl,
              // Room for the floating contact-admin button, so the last card
              // scrolls clear of it instead of ending underneath.
              screen.onContactAdmin == null
                  ? AppSpacing.huge
                  : AppSpacing.huge + AppSizes.fab + AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FamilyCard(
                  guardian: data.guardian,
                  children: data.children,
                  onAddChild: screen.onAddChild,
                ),
                const SizedBox(height: AppSpacing.lg),
                ImpactSummaryCard(tallies: data.categories),
                const SizedBox(height: AppSpacing.lg),
                LatestBadgeCard(
                  badge: data.latestBadge,
                  firstLevel: data.levels.firstOrNull,
                  onOpen: screen.onOpenBadges,
                ),
                const SizedBox(height: AppSpacing.lg),
                MyRankingCard(
                  ranking: data.ranking,
                  onTap: screen.onOpenLeaderboard,
                ),
                const SizedBox(height: AppSpacing.lg),
                NearbyFamiliesCard(
                  shares: controller.sharesContact,
                  onToggle: controller.toggleSharesContact,
                ),
                const SizedBox(height: AppSpacing.lg),
                BadgeProgressionCard(
                  current: data.currentLevel,
                  next: data.nextLevel,
                  lawnsToNext: data.lawnsToNext,
                ),
                SizedBox(height: AppTabBar.clearance(context)),
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
                'We could not load your profile.',
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
