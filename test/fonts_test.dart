import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Onest ships with the app.
///
/// Left to be fetched at runtime, the first frames — and every frame on a
/// device that cannot reach fonts.gstatic.com — fall back to the platform
/// font, whose weights and metrics are not the design's. google_fonts loads
/// a bundled file in preference to the network when it is named for the
/// family and variant, so the names here are the contract.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('every weight the design uses is bundled', () async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final assets = manifest.listAssets();

    // 400, 500, 600, 700 and 900 — the weights AppTypography asks for.
    for (final variant in const [
      'Regular',
      'Medium',
      'SemiBold',
      'Bold',
      'Black',
    ]) {
      expect(
        assets.any((asset) => asset.endsWith('Onest-$variant.ttf')),
        isTrue,
        reason: 'Onest-$variant.ttf is not bundled, so that weight would be '
            'fetched at runtime or fall back to the platform font',
      );
    }
  });
}
