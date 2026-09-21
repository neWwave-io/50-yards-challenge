import 'package:flutter/material.dart';

/// Elevation tokens.
///
/// Figma's blur is the CSS one: a blur of B is a gaussian of sigma B/2.
/// Flutter's `blurRadius` is not — it converts as `sigma = R * 0.57735 + 0.5`.
/// Passing Figma's number straight through therefore draws a shadow about a
/// quarter too soft, so each radius below is converted:
///
///     R = (B / 2 - 0.5) / 0.57735
///
/// The Figma blur each one came from is noted beside it.
abstract final class AppShadows {
  /// `shad/textfield shad` — a filled, resting input. Figma blur 10.
  static const field = <BoxShadow>[
    BoxShadow(color: Color(0x1A2F7F33), offset: Offset(0, 1), blurRadius: 7.8),
  ];

  /// An input that currently has focus. Figma blur 8.
  static const fieldFocused = <BoxShadow>[
    BoxShadow(color: Color(0x1F2F7F33), blurRadius: 6.1),
  ];

  /// The primary call-to-action button. Figma blur 12.
  static const button = <BoxShadow>[
    BoxShadow(color: Color(0x1F1C4002), offset: Offset(0, 4), blurRadius: 9.5),
  ];

  /// `shadow new` — the resting shadow of a card.
  /// Figma: x 0, y 1, blur 10, spread 0, #1C4002 at 12%.
  static const card = <BoxShadow>[
    BoxShadow(color: Color(0x1F1C4002), offset: Offset(0, 1), blurRadius: 7.8),
  ];

  /// `shad/p2.container` — the challenge card, which sits over the header.
  /// Figma blur 15.
  static const cardRaised = <BoxShadow>[
    BoxShadow(color: Color(0x263A6618), offset: Offset(0, 4), blurRadius: 12.1),
  ];

  /// An open dropdown panel.
  static const dropdown = <BoxShadow>[
    BoxShadow(color: Color(0x1F2F7F33), offset: Offset(0, 4), blurRadius: 16.5),
  ];
}
