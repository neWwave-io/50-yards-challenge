import 'dart:typed_data';

import '../../home/data/home_data.dart' show MowedCategory;

/// What was done. Free text in `lawns.service`, so the list can change
/// without a migration.
const kLawnServices = <String>[
  'Lawn Mowing',
  'Grocery Shopping',
  'Dog Walking',
  'Car Wash',
  'Other',
];

/// Every photo the flow asks for, as stored in `lawn_photos.photo_kind`.
enum LawnPhoto {
  before('before'),
  after('after'),
  action('action'),
  homeowner('homeowner'),
  safety('safety');

  const LawnPhoto(this.kind);

  final String kind;
}

/// The four screens, in order.
enum SubmitStep { details, lawnPhotos, actionPhotos, safety }

/// A lawn being filled in. Immutable; the controller swaps in copies.
class LawnDraft {
  const LawnDraft({
    this.whoFor,
    this.service,
    required this.mowedOn,
    this.hours,
    this.note = '',
    this.photos = const {},
    this.woreSafetyGear,
  });

  final MowedCategory? whoFor;
  final String? service;

  /// A calendar date — the day the work was done.
  final DateTime mowedOn;

  /// Null until a valid number is typed.
  final double? hours;

  final String note;

  /// JPEG bytes, already scaled down by the picker.
  final Map<LawnPhoto, Uint8List> photos;

  final bool? woreSafetyGear;

  /// A day's work, give or take — anything past that is a typo.
  static const maxHours = 24.0;

  bool get hasValidHours => hours != null && hours! > 0 && hours! <= maxHours;

  /// Whether [step] has everything it needs to move on.
  bool isComplete(SubmitStep step) => switch (step) {
        SubmitStep.details =>
          whoFor != null && service != null && hasValidHours,
        SubmitStep.lawnPhotos =>
          photos.containsKey(LawnPhoto.before) &&
              photos.containsKey(LawnPhoto.after),
        SubmitStep.actionPhotos =>
          photos.containsKey(LawnPhoto.action) &&
              photos.containsKey(LawnPhoto.homeowner),
        SubmitStep.safety =>
          woreSafetyGear != null && photos.containsKey(LawnPhoto.safety),
      };

  LawnDraft copyWith({
    MowedCategory? whoFor,
    String? service,
    DateTime? mowedOn,
    double? Function()? hours,
    String? note,
    Map<LawnPhoto, Uint8List>? photos,
    bool? woreSafetyGear,
  }) =>
      LawnDraft(
        whoFor: whoFor ?? this.whoFor,
        service: service ?? this.service,
        mowedOn: mowedOn ?? this.mowedOn,
        hours: hours == null ? this.hours : hours(),
        note: note ?? this.note,
        photos: photos ?? this.photos,
        woreSafetyGear: woreSafetyGear ?? this.woreSafetyGear,
      );
}
