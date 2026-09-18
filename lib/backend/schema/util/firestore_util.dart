import 'package:flutter/material.dart';
import 'package:from_css_color/from_css_color.dart';

import '/backend/schema/enums/enums.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/supabase_compat/compat_types.dart';
import '/backend/supabase_compat/compat_query.dart';
import '/flutter_flow/flutter_flow_util.dart';

export '/backend/supabase_compat/compat_types.dart';
export '/backend/supabase_compat/compat_query.dart' show RecordBuilder;

/// Base for every generated record. Unchanged in shape from the Firestore
/// version so the v1 screens keep working; only the source is different.
abstract class FirestoreRecord {
  FirestoreRecord(this.reference, this.snapshotData);
  Map<String, dynamic> snapshotData;
  DocumentReference reference;
}

abstract class FFFirebaseStruct extends BaseStruct {
  FFFirebaseStruct(this.firestoreUtilData);

  FirestoreUtilData firestoreUtilData = FirestoreUtilData();
}

class FirestoreUtilData {
  const FirestoreUtilData({
    this.fieldValues = const {},
    this.clearUnsetFields = true,
    this.create = false,
    this.delete = false,
  });
  final Map<String, dynamic> fieldValues;
  final bool clearUnsetFields;
  final bool create;
  final bool delete;
  static String get name => 'firestoreUtilData';
}

/// Local copy of the Map filter helper. flutter_flow_util defines an
/// equivalent extension, but importing it here creates a cycle.
Map<String, dynamic> _filterKeys(
  Map<String, dynamic> map,
  bool Function(String, dynamic) test,
) =>
    Map.fromEntries(map.entries.where((e) => test(e.key, e.value)));

final _isoDate = RegExp(
  r'^\d{4}-\d{2}-\d{2}[T ]\d{2}:\d{2}:\d{2}',
);

/// Postgres returns timestamps as ISO-8601 strings, where Firestore returned
/// Timestamp objects. The generated records cast straight to DateTime, so
/// convert here rather than touching 9 record classes.
dynamic _coerce(dynamic value) {
  if (value is String && _isoDate.hasMatch(value)) {
    return DateTime.tryParse(value) ?? value;
  }
  return value;
}

Map<String, dynamic> mapFromFirestore(Map<String, dynamic> data) =>
    _filterKeys(mergeNestedFields(data), (k, _) => k != FirestoreUtilData.name)
        .map((key, value) {
      value = _coerce(value);
      if (value is Iterable && value.isNotEmpty && value.first is String) {
        value = value.map(_coerce).toList();
      }
      if (value is Map) {
        value = mapFromFirestore(Map<String, dynamic>.from(value));
      }
      if (value is Iterable && value.isNotEmpty && value.first is Map) {
        value = value
            .map((v) => mapFromFirestore(Map<String, dynamic>.from(v as Map)))
            .toList();
      }
      return MapEntry(key, value);
    });

Map<String, dynamic> mapToFirestore(Map<String, dynamic> data) =>
    _filterKeys(data, (k, v) => k != FirestoreUtilData.name).map((key, value) {
      // References are stored as plain text ids on the compat views.
      if (value is DocumentReference) {
        value = value.id;
      }
      if (value is Iterable &&
          value.isNotEmpty &&
          value.first is DocumentReference) {
        value = value.map((v) => (v as DocumentReference).id).toList();
      }
      if (value is DateTime) {
        value = value.toUtc().toIso8601String();
      }
      if (value is Iterable && value.isNotEmpty && value.first is DateTime) {
        value =
            value.map((v) => (v as DateTime).toUtc().toIso8601String()).toList();
      }
      if (value is LatLng) {
        value = {'lat': value.latitude, 'lng': value.longitude};
      }
      if (value is Color) {
        value = value.toCssString();
      }
      if (value is Iterable && value.isNotEmpty && value.first is Color) {
        value = value.map((v) => (v as Color).toCssString()).toList();
      }
      if (value is Enum) {
        value = value.serialize();
      }
      if (value is Iterable && value.isNotEmpty && value.first is Enum) {
        value = value.map((v) => (v as Enum).serialize()).toList();
      }
      if (value is Map) {
        value = mapToFirestore(Map<String, dynamic>.from(value));
      }
      if (value is Iterable && value.isNotEmpty && value.first is Map) {
        value = value
            .map((v) => mapToFirestore(Map<String, dynamic>.from(v as Map)))
            .toList();
      }
      return MapEntry(key, value);
    });

/// Rebuilds a DocumentReference from a "collection/id" path, as v1 stored it.
DocumentReference toRef(String ref) {
  final parts = ref.split('/');
  if (parts.length >= 2) {
    final collection = parts[parts.length - 2];
    return DocumentReference(
      collection.startsWith('v1_') ? collection : 'v1_$collection',
      parts.last,
    );
  }
  return DocumentReference('v1_users', ref);
}

/// Builds a reference from whatever the compat view returned for a reference
/// column: a bare id, a path, or null.
DocumentReference? toRefOrNull(String collectionName, dynamic value) {
  if (value == null) return null;
  if (value is DocumentReference) return value;
  final raw = '$value';
  if (raw.isEmpty) return null;
  final id = raw.contains('/') ? raw.split('/').last : raw;
  return DocumentReference(collectionName, id);
}

List<DocumentReference>? toRefList(String collectionName, dynamic value) {
  if (value is! Iterable) return null;
  return value
      .map((v) => toRefOrNull(collectionName, v))
      .whereType<DocumentReference>()
      .toList();
}

T? safeGet<T>(T Function() func, [Function(dynamic)? reportError]) {
  try {
    return func();
  } catch (e) {
    reportError?.call(e);
  }
  return null;
}

Map<String, dynamic> mergeNestedFields(Map<String, dynamic> data) {
  final nestedData = _filterKeys(data, (k, _) => k.contains('.'));
  final fieldNames = nestedData.keys.map((k) => k.split('.').first).toSet();
  data.removeWhere((k, _) => k.contains('.'));
  for (final name in fieldNames) {
    final mergedValues = mergeNestedFields(
      _filterKeys(nestedData, (k, _) => k.split('.').first == name)
          .map((k, v) => MapEntry(k.split('.').skip(1).join('.'), v)),
    );
    final existingValue = data[name];
    data[name] = {
      if (existingValue != null && existingValue is Map<String, dynamic>)
        ...existingValue,
      ...mergedValues,
    };
  }
  return data;
}
