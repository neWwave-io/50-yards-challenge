import 'package:flutter/material.dart';

/// Push is not wired up (Supabase has no push service). This keeps the widget
/// tree in nav.dart unchanged by simply rendering its child.
class PushNotificationsHandler extends StatelessWidget {
  const PushNotificationsHandler({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
