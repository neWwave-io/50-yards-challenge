/// Where a message to the admin team stands. Mirrors the `status` column,
/// which the database derives from `viewed_at` and `deleted_at`.
enum AdminMessageStatus {
  sent('Sent'),
  viewed('Viewed'),
  deleted('Deleted');

  const AdminMessageStatus(this.label);

  final String label;

  static AdminMessageStatus parse(String? value) => switch (value) {
        'viewed' => viewed,
        'deleted' => deleted,
        _ => sent,
      };
}

/// One message a family sent to the admin team.
class AdminMessage {
  const AdminMessage({
    required this.id,
    required this.body,
    required this.status,
    required this.sentAt,
  });

  final String id;
  final String body;
  final AdminMessageStatus status;
  final DateTime sentAt;
}
