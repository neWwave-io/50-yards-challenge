import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_tab_bar.dart';
import 'data/leaderboard_data.dart';
import 'data/leaderboard_repository.dart';
import 'leaderboard_controller.dart';
import 'widgets/leaderboard_empty.dart';
import 'widgets/leaderboard_header.dart';
import 'widgets/participant_filters.dart';
import 'widgets/podium_card.dart';
import 'widgets/rank_row.dart';

/// The leaderboard: the national top five, then everyone else, searchable
/// and filterable by state. The signed-in child's row is highlighted wherever
/// it falls in the list — and simply absent when it is not in it.
class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({
    super.key,
    this.repository = const LeaderboardRepository(),
    this.bottomBar,
  });

  // Kept from v1 so the tab bar's existing links still land here.
  static const routeName = 'LeaderBoard';
  static const routePath = '/leaderBoard';

  final LeaderboardRepository repository;

  /// The app's tab bar, pinned to the bottom.
  final Widget? bottomBar;

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late final _controller = LeaderboardController(repository: widget.repository);
  final _search = TextEditingController();
  final _scroll = ScrollController();

  /// Start fetching the next page this far before the end of the list.
  static const _prefetchExtent = 400.0;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_maybeLoadMore);
    _controller.load();
  }

  @override
  void dispose() {
    _scroll.dispose();
    _search.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _maybeLoadMore() {
    final position = _scroll.position;
    if (position.extentAfter < _prefetchExtent) _controller.loadMore();
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
      body: ListenableBuilder(
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
    );
  }

  Widget _content(BuildContext context) {
    final c = _controller;
    // Nobody on the board at all — not merely nothing matching a filter.
    final empty = c.podium.isEmpty && c.error == null;

    // People have joined but nobody has an approved lawn yet: there is no
    // ranking to show, so the trophy card stands in for the podium and the
    // would-be top five join the list instead of vanishing.
    final noRankings =
        c.podium.isNotEmpty && c.podium.every((e) => e.totalLawns == 0);

    final podium =
        noRankings ? const <LeaderboardEntry>[] : c.podium.take(3).toList();
    final runnersUp =
        noRankings ? const <LeaderboardEntry>[] : c.podium.skip(3).toList();
    final participants = noRankings && !c.isFiltered
        ? [...c.podium, ...c.participants]
        : c.participants;

    return CustomScrollView(
      controller: _scroll,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Stack(
            children: [
              LeaderboardHeader(state: c.me?.state, compact: empty),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.paddingOf(context).top +
                      (empty
                          ? LeaderboardHeader.compactCardTop
                          : LeaderboardHeader.cardTop),
                  left: AppSpacing.xl,
                  right: AppSpacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (empty)
                      const NoParticipantsCard()
                    else if (noRankings)
                      const NoRankingsCard()
                    else if (podium.isNotEmpty)
                      PodiumCard(leaders: podium),
                    for (final entry in runnersUp) ...[
                      SizedBox(
                        height: entry == runnersUp.first
                            ? AppSpacing.lg
                            : AppSpacing.md,
                      ),
                      _row(entry, null),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.lg,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Participants',
                  textAlign: TextAlign.center,
                  style: AppTypography.sectionHeading,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  c.state == null
                      ? 'Participants across all states.'
                      : 'Participants in ${c.state}.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: AppSpacing.lg),
                ParticipantFilters(
                  search: _search,
                  state: c.state,
                  onSearch: c.setSearch,
                  onState: c.chooseState,
                ),
              ],
            ),
          ),
        ),
        if (empty)
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            sliver: SliverToBoxAdapter(child: NoRankingsCard()),
          )
        else if (c.error != null && participants.isEmpty)
          SliverToBoxAdapter(child: _Failed(onRetry: c.load))
        else if (participants.isEmpty && !c.loadingPage && c.isFiltered)
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            sliver: SliverToBoxAdapter(
              child: NoParticipantsCard(
                title: 'No one found',
                body: 'Try another name, or choose a different state.',
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            sliver: SliverList.separated(
              itemCount: participants.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (_, i) => _row(participants[i], c.state),
            ),
          ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: AppTabBar.clearance(context) + AppSpacing.huge,
            child: c.loadingPage
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.olive500),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _row(LeaderboardEntry entry, String? state) {
    final mine = entry.profileId == _controller.me?.entry?.profileId;
    // "Me, 5th, 0 lawns" says nothing useful; before their first approved
    // lawn a child is told how to get onto the board instead.
    if (mine && entry.totalLawns == 0) return const NoLawnsYetCard();
    return RankRow(
      rank: entry.rankFor(state),
      name: entry.name,
      photoUrl: entry.photoUrl,
      totalLawns: entry.totalLawns,
      mine: mine,
    );
  }
}

class _Failed extends StatelessWidget {
  const _Failed({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          Text(
            'We could not load the leaderboard.',
            textAlign: TextAlign.center,
            style:
                AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
          ),
          TextButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}
