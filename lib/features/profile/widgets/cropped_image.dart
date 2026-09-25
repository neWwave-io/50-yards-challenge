import 'package:flutter/material.dart';

/// An exported illustration shown the way the design frames it: scaled past
/// its box and shifted, so the soft margin baked into the export is cut off.
///
/// The numbers are the design's own, as fractions of the box. An image
/// 122.83% of the box, pulled 10.96% left and up, is
/// `scaleX: 1.2283, scaleY: 1.2283, insetLeft: 0.1096, insetTop: 0.1096`.
class CroppedImage extends StatelessWidget {
  const CroppedImage(
    this.asset, {
    super.key,
    required this.width,
    required this.height,
    required this.scaleX,
    required this.scaleY,
    required this.insetLeft,
    required this.insetTop,
  });

  /// A square icon cropped evenly on every side.
  const CroppedImage.square(
    this.asset, {
    super.key,
    required double size,
    required double scale,
    required double inset,
  })  : width = size,
        height = size,
        scaleX = scale,
        scaleY = scale,
        insetLeft = inset,
        insetTop = inset;

  final String asset;
  final double width;
  final double height;
  final double scaleX;
  final double scaleY;

  /// How far the image is pulled left and up, past the box's edge.
  final double insetLeft;
  final double insetTop;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        height: height,
        child: ClipRect(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: -insetLeft * width,
                top: -insetTop * height,
                width: scaleX * width,
                height: scaleY * height,
                child: Image.asset(asset, fit: BoxFit.fill),
              ),
            ],
          ),
        ),
      );
}
