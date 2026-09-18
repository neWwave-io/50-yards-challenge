import 'package:collection/collection.dart';

enum ShirtLevel {
  starter,
  orange,
  green,
  blue,
  red,
  black,
}

enum ShirtStatus {
  pending,
  approved,
  rejected,
  done,
}

enum AnnouncementType {
  article,
  video,
}

enum Gender {
  Male,
  Female,
}

extension FFEnumExtensions<T extends Enum> on T {
  String serialize() => name;
}

extension FFEnumListExtensions<T extends Enum> on Iterable<T> {
  T? deserialize(String? value) =>
      firstWhereOrNull((e) => e.serialize() == value);
}

T? deserializeEnum<T>(String? value) {
  switch (T) {
    case (ShirtLevel):
      return ShirtLevel.values.deserialize(value) as T?;
    case (ShirtStatus):
      return ShirtStatus.values.deserialize(value) as T?;
    case (AnnouncementType):
      return AnnouncementType.values.deserialize(value) as T?;
    case (Gender):
      return Gender.values.deserialize(value) as T?;
    default:
      return null;
  }
}
