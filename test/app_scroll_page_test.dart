import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_50_yard_challenge/core/widgets/app_scroll_page.dart';

/// Lays out [height] tall but reports an intrinsic height of zero.
///
/// This is the failure mode that overflowed step 2 on a real phone: a child's
/// prediction of its own height came in short (there, text measured before
/// the web font arrived), and a layout that trusted the prediction handed the
/// column less room than it then needed.
class _UnderReportingBox extends LeafRenderObjectWidget {
  const _UnderReportingBox(this.height);

  final double height;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderUnderReportingBox(height);
}

class _RenderUnderReportingBox extends RenderBox {
  _RenderUnderReportingBox(this._height);

  final double _height;

  @override
  double computeMinIntrinsicHeight(double width) => 0;

  @override
  double computeMaxIntrinsicHeight(double width) => 0;

  @override
  void performLayout() {
    size = constraints.constrain(Size(constraints.maxWidth, _height));
  }
}

void main() {
  Future<void> pumpPage(WidgetTester tester, Widget page) async {
    tester.view.physicalSize = const Size(360, 400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: page)));
    await tester.pumpAndSettle();
  }

  testWidgets('a child that under-reports its height cannot overflow the page',
      (tester) async {
    await pumpPage(
      tester,
      const AppScrollPage(
        padding: EdgeInsets.all(20),
        body: _UnderReportingBox(600),
        footer: SizedBox(height: 42, child: Text('Sign up')),
      ),
    );

    // An overflow is reported as an exception during layout.
    expect(tester.takeException(), isNull);

    // The page scrolls instead, and the footer is still reachable.
    await tester.scrollUntilVisible(find.text('Sign up'), 200);
    expect(find.text('Sign up'), findsOneWidget);
  });

  testWidgets('on a tall screen the footer still sits at the bottom',
      (tester) async {
    await pumpPage(
      tester,
      const AppScrollPage(
        padding: EdgeInsets.zero,
        body: SizedBox(height: 50),
        footer: SizedBox(height: 42, child: Text('Sign up')),
      ),
    );

    final bottom = tester.getBottomLeft(find.text('Sign up')).dy;
    expect(bottom, closeTo(400, 1));
  });
}
