import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../data/home_data.dart';
import 'training_hub_card.dart';

/// Swipes through the published training videos, a page at a time.
///
/// Every card is given the same height so the page below does not jump as you
/// swipe; the description is capped at three lines to keep them even.
class TrainingHubCarousel extends StatefulWidget {
  const TrainingHubCarousel({
    super.key,
    required this.videos,
    this.onWatch,
  });

  final List<TrainingVideo> videos;
  final ValueChanged<TrainingVideo>? onWatch;

  /// Tall enough for a still, a title, three lines of copy and the button.
  static const cardHeight = 392.0;

  @override
  State<TrainingHubCarousel> createState() => _TrainingHubCarouselState();
}

class _TrainingHubCarouselState extends State<TrainingHubCarousel> {
  final _controller = PageController();
  var _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videos = widget.videos;
    if (videos.length == 1) {
      return TrainingHubCard(video: videos.single, onWatch: widget.onWatch);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: TrainingHubCarousel.cardHeight,
          child: PageView.builder(
            controller: _controller,
            // A PageView clips to its viewport, which sliced the card's
            // shadow off square at the page edge.
            clipBehavior: Clip.none,
            itemCount: videos.length,
            onPageChanged: (page) => setState(() => _page = page),
            itemBuilder: (context, i) => Padding(
              // A sliver of the next card shows at the edge, so it reads as
              // something you can swipe.
              padding: EdgeInsets.only(
                right: i == videos.length - 1 ? 0 : AppSpacing.md,
              ),
              child: TrainingHubCard(
                video: videos[i],
                onWatch: widget.onWatch,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _Dots(count: videos.length, current: _page),
      ],
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < count; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.sm),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: i == current ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: i == current
                    ? AppColors.olive500
                    : AppColors.neutralText500.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(AppRadii.pill),
              ),
            ),
          ],
        ],
      );
}
