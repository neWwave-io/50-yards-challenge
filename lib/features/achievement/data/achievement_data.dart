import '../../submit_lawn/data/lawn_draft.dart' show LawnPhoto;

/// How a lawn came back from review.
///
/// `lawns.status` has a third value, `pending`, which every lawn holds from
/// the moment it is submitted until an admin acts on it. The achievement page
/// lists reviewed work only, so the repository filters those out and this
/// enum has no case for them — a lawn that reaches the page has an outcome.
enum LawnReview {
  approved('approved'),
  rejected('rejected');

  const LawnReview(this.column);

  /// The value stored in `lawns.status`.
  final String column;

  /// Null for `pending`, or for anything an older row holds that this
  /// version does not know about.
  static LawnReview? parse(Object? value) {
    for (final review in values) {
      if (review.column == value) return review;
    }
    return null;
  }
}

/// One reviewed lawn, as the achievement card shows it.
///
/// Every field below [number] is nullable because the submit form grew over
/// time: lawns logged under v1 have no service, no mowed-on date and no
/// safety answer, and none has an address yet. The card leaves a row out
/// rather than printing a blank one.
class SubmittedLawn {
  const SubmittedLawn({
    required this.id,
    required this.number,
    required this.review,
    required this.mowedFor,
    required this.service,
    required this.address,
    required this.mowedOn,
    required this.hours,
    required this.woreSafetyGear,
    required this.photos,
  });

  final String id;

  /// Which lawn of the fifty this is, counting from the child's first. Fixed
  /// at submission order, so a lawn keeps its number as later ones land — and
  /// keeps it even though the pending ones between are not on the page.
  final int number;

  final LawnReview review;

  /// The kind of neighbour it was mowed for — "Elderly", "Veteran", …
  final String? mowedFor;

  /// What was done. One of [kLawnServices], but stored as free text.
  final String? service;

  /// The street it was on. Null on every lawn so far: the submit form does
  /// not ask for one yet.
  final String? address;

  /// The day the work was done, which may be earlier than the day it was
  /// submitted.
  final DateTime? mowedOn;

  final double? hours;

  /// The Safety Check answer.
  final bool? woreSafetyGear;

  /// Public URLs, by the step that took them. A step the child skipped, or
  /// one that did not exist when they submitted, is simply absent.
  final Map<LawnPhoto, String> photos;

  /// The four proof shots, in the order the design lays them out. A missing
  /// one still takes its place, so the grid does not reshuffle.
  static const proofSteps = [
    (LawnPhoto.before, 'Lawn Before Photo'),
    (LawnPhoto.after, 'Lawn After Photo'),
    (LawnPhoto.action, 'Child In Action'),
    (LawnPhoto.homeowner, 'Child with owner'),
  ];

  /// Whether opening the card would show anything at all.
  bool get hasDetail =>
      woreSafetyGear != null || photos.isNotEmpty;

  /// "2.0" — the hours, as the card prints them.
  String? get hoursLabel => hours?.toStringAsFixed(1);
}
