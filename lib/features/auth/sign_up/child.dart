import 'dart:typed_data';

import '../../../core/constants/child_options.dart';
import '../../../core/utils/date_format.dart';

/// One child being signed up. Held in memory through step 2; a repository
/// turns it into a `children` row once sign-up succeeds.
class Child {
  const Child({
    required this.id,
    this.name = '',
    this.dateOfBirth,
    this.gender,
    this.shirtSize,
    this.photo,
  });

  /// Local only — the database assigns the real id.
  final String id;

  final String name;
  final DateTime? dateOfBirth;
  final ChildGender? gender;
  final String? shirtSize;

  /// Raw bytes so the same code path works on web and mobile.
  final Uint8List? photo;

  bool get isComplete =>
      name.trim().isNotEmpty &&
      dateOfBirth != null &&
      gender != null &&
      (shirtSize?.isNotEmpty ?? false);

  /// "Emma · Female", or just the name until a gender is picked.
  String get summary =>
      gender == null ? name : '$name · ${gender!.label}';

  Child copyWith({
    String? name,
    DateTime? dateOfBirth,
    ChildGender? gender,
    String? shirtSize,
    Uint8List? photo,
  }) =>
      Child(
        id: id,
        name: name ?? this.name,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        gender: gender ?? this.gender,
        shirtSize: shirtSize ?? this.shirtSize,
        photo: photo ?? this.photo,
      );
}

/// "12th/Sep", the format the design uses on the summary row.
String formatBirthday(DateTime date) => dayOverMonth(date);
