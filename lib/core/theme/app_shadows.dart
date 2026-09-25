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

  /// The glow under a screen's dark header. Figma blur 40.
  static const header = <BoxShadow>[
    BoxShadow(color: Color(0x2642A645), offset: Offset(0, 16), blurRadius: 33.8),
  ];

  /// The glass card holding the podium. Figma drop-shadow blur 7.5.
  static const glassCard = <BoxShadow>[
    BoxShadow(color: Color(0x263A6618), offset: Offset(0, 4), blurRadius: 5.6),
  ];

  /// The lawn-count tag under a podium name. Figma blur 4.
  static const tag = <BoxShadow>[
    BoxShadow(color: Color(0x33577E3D), blurRadius: 2.6),
  ];

  /// The floating tab bar. Figma drop-shadow blur 10.
  static const tabBar = <BoxShadow>[
    BoxShadow(color: Color(0x2412170D), offset: Offset(0, 8), blurRadius: 7.8),
  ];

  /// An empty or filled photo slot. Figma drop-shadow blur 5.
  static const photoSlot = <BoxShadow>[
    BoxShadow(color: Color(0x1A2F7F33), offset: Offset(0, 1), blurRadius: 3.5),
  ];

  /// A Yes / No answer button. Figma drop-shadow blur 6.
  static const answer = <BoxShadow>[
    BoxShadow(color: Color(0x1F1C4002), offset: Offset(0, 4), blurRadius: 4.3),
  ];

  /// The white Done button on a coloured screen. Figma drop-shadow blur 2.
  static const buttonOnColour = <BoxShadow>[
    BoxShadow(color: Color(0x141C4002), offset: Offset(0, 2), blurRadius: 1),
  ];

  /// The amber glow around the banner's warning icon. Figma blur 2.
  static const alertIcon = <BoxShadow>[
    BoxShadow(color: Color(0x26FFC107), blurRadius: 0.9),
  ];

  /// A small square icon button, like the sort toggle. Figma blur 7.
  static const iconButton = <BoxShadow>[
    BoxShadow(color: Color(0x1A4FAB24), offset: Offset(0, 1), blurRadius: 5.2),
  ];

  /// `togel` — the selected half of a two-way toggle. Figma blur 2.
  static const segment = <BoxShadow>[
    BoxShadow(
      color: Color(0x26000000),
      offset: Offset(0, 1),
      blurRadius: 0.9,
      spreadRadius: -1,
    ),
    BoxShadow(color: Color(0x4D000000), offset: Offset(1, 0), blurRadius: 0.9),
  ];

  /// An open dropdown panel.
  static const dropdown = <BoxShadow>[
    BoxShadow(color: Color(0x1F2F7F33), offset: Offset(0, 4), blurRadius: 16.5),
  ];
}
