import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_theme.dart';

/// The app's top-level destinations, in tab-bar order.
enum AppTab {
  home('Home', 'assets/icons/tab_home.svg'),
  board('Board', 'assets/icons/tab_board.svg'),
  log('Log', 'assets/icons/tab_log.svg'),
  badges('Badges', 'assets/icons/tab_badges.svg'),
  me('Me', 'assets/icons/tab_me.svg');

  const AppTab(this.label, this.icon);

  final String label;
  final String icon;
}

/// The floating white pill at the bottom of the main screens.
///
/// The current tab grows into a green pill with its label; the others are
/// icons only. Where each tab leads is the router's business, so this widget
/// only reports the tap.
class AppTabBar extends StatelessWidget {
  const AppTabBar({super.key, required this.current, required this.onSelect});

  /// Null when the screen on show is not one of the tabs.
  final AppTab? current;
  final ValueChanged<AppTab> onSelect;

  /// Never closer than this to the screen edge.
  static const _minSideMargin = AppSpacing.sm;

  /// How much room the bar needs at the foot of a page.
  ///
  /// It floats over the content rather than sitting on a strip of its own, so
  /// a page that hosts it pads the bottom of its scroll view by this much —
  /// otherwise the last card would come to rest underneath it.
  static double clearance(BuildContext context) =>
      AppSizes.tabBarHeight +
      AppSpacing.sm +
      math.max(MediaQuery.paddingOf(context).bottom, AppSpacing.sm);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          _minSideMargin,
          AppSpacing.sm,
          _minSideMargin,
          0,
        ),
        // Centres the bar across the width while staying exactly as tall as
        // it is. A plain Center would take the whole height the Scaffold
        // offers the bottom slot, which is most of the screen.
        child: Align(
          alignment: Alignment.center,
          heightFactor: 1,
          // The bar is exactly as wide as its five tabs, rather than a fixed
          // width with the slack shared out between them. Growing it left a
          // gap either side of every icon that read as the bar being too
          // wide for what is in it.
          child: AnimatedSize(
            duration: _Tab._duration,
            curve: Curves.easeOut,
            child: FittedBox(
              // Only bites on a phone too narrow to hold the five tabs at
              // their own size; everywhere else this is a no-op.
              fit: BoxFit.scaleDown,
              child: Container(
                height: AppSizes.tabBarHeight,
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                // The bar is a white pill in its own right. It floats over
                // the page rather than standing on a strip, so the shadow is
                // what lifts it off whatever scrolls underneath.
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                  boxShadow: AppShadows.tabBar,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final tab in AppTab.values)
                      _Tab(
                        tab: tab,
                        active: tab == current,
                        onTap: () => onSelect(tab),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.tab, required this.active, required this.onTap});

  final AppTab tab;
  final bool active;
  final VoidCallback onTap;

  static const _duration = Duration(milliseconds: 200);

  /// An idle tab's tap target. Four of the five tabs are idle whichever one
  /// is current, so this is also the knob that sets the bar's width: every
  /// point here is four on the bar. Widened from 46 to put 50 back between
  /// the icons without leaving dead space at the two ends.
  static const _idleWidth = 58.5;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      label: tab.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: _duration,
          curve: Curves.easeOut,
          // Idle tabs centre the icon in a box rather than padding it, so the
          // box can narrow without squeezing the icon.
          constraints: BoxConstraints(minWidth: active ? 0 : _idleWidth),
          padding: EdgeInsets.symmetric(
            horizontal: active ? 15 : 0,
            vertical: 11,
          ),
          decoration: BoxDecoration(
            color: active ? AppColors.olive600 : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
          child: AnimatedSize(
            duration: _duration,
            curve: Curves.easeOut,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  tab.icon,
                  width: active ? AppSizes.tabIcon : AppSizes.tabIconIdle,
                  height: active ? AppSizes.tabIcon : AppSizes.tabIconIdle,
                  colorFilter: ColorFilter.mode(
                    active ? AppColors.surface : AppColors.tabIcon,
                    BlendMode.srcIn,
                  ),
                ),
                if (active) ...[
                  const SizedBox(width: 7),
                  Text(
                    tab.label,
                    maxLines: 1,
                    softWrap: false,
                    style: AppTypography.tabLabel,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
