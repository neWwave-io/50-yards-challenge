import 'package:flutter/material.dart';

/// Elevation tokens. Figma expresses these as layer drop shadows; the blur
/// radius here is the Figma blur, which is twice the CSS `drop-shadow` value.
abstract final class AppShadows {
  /// `shad/textfield shad` — a filled, resting input.
  static const field = <BoxShadow>[
    BoxShadow(color: Color(0x1A2F7F33), offset: Offset(0, 1), blurRadius: 10),
  ];

  /// An input that currently has focus.
  static const fieldFocused = <BoxShadow>[
    BoxShadow(color: Color(0x1F2F7F33), blurRadius: 8),
  ];

  /// The primary call-to-action button.
  static const button = <BoxShadow>[
    BoxShadow(color: Color(0x1F1C4002), offset: Offset(0, 4), blurRadius: 12),
  ];

  /// An open dropdown panel.
  static const dropdown = <BoxShadow>[
    BoxShadow(color: Color(0x1F2F7F33), offset: Offset(0, 4), blurRadius: 20),
  ];
}
