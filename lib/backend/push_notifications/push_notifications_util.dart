/// Push notifications are not wired up.
///
/// Supabase has no push service, and firebase_messaging was removed with the
/// rest of Firebase. The `device_tokens` table exists for when push is added
/// back through an Edge Function calling FCM.
///
/// These no-ops keep the v1 call sites compiling.
Future<void> initializePushNotifications() async {}

Future<void> requestPushNotificationPermissions() async {}

/// v1 called this to queue a push. Push is not wired up on Supabase, so this
/// is a no-op that accepts the same arguments the screens pass.
Future<void> triggerPushNotification({
  String? notificationTitle,
  String? notificationText,
  String? notificationImageUrl,
  dynamic notificationSound,
  List<dynamic>? userRefs,
  String? initialPageName,
  dynamic parameterData,
  dynamic scheduledTime,
}) async {}
