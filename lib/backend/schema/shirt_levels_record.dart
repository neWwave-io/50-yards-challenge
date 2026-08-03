import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ShirtLevelsRecord extends FirestoreRecord {
  ShirtLevelsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "min_lawns" field.
  String? _minLawns;
  String get minLawns => _minLawns ?? '';
  bool hasMinLawns() => _minLawns != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "image_url" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  bool hasImageUrl() => _imageUrl != null;

  // "name" field.
  ShirtLevel? _name;
  ShirtLevel? get name => _name;
  bool hasName() => _name != null;

  void _initializeFields() {
    _minLawns = snapshotData['min_lawns'] as String?;
    _description = snapshotData['description'] as String?;
    _imageUrl = snapshotData['image_url'] as String?;
    _name = snapshotData['name'] is ShirtLevel
        ? snapshotData['name']
        : deserializeEnum<ShirtLevel>(snapshotData['name']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('shirt_levels');

  static Stream<ShirtLevelsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ShirtLevelsRecord.fromSnapshot(s));

  static Future<ShirtLevelsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ShirtLevelsRecord.fromSnapshot(s));

  static ShirtLevelsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ShirtLevelsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ShirtLevelsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ShirtLevelsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ShirtLevelsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ShirtLevelsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createShirtLevelsRecordData({
  String? minLawns,
  String? description,
  String? imageUrl,
  ShirtLevel? name,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'min_lawns': minLawns,
      'description': description,
      'image_url': imageUrl,
      'name': name,
    }.withoutNulls,
  );

  return firestoreData;
}

class ShirtLevelsRecordDocumentEquality implements Equality<ShirtLevelsRecord> {
  const ShirtLevelsRecordDocumentEquality();

  @override
  bool equals(ShirtLevelsRecord? e1, ShirtLevelsRecord? e2) {
    return e1?.minLawns == e2?.minLawns &&
        e1?.description == e2?.description &&
        e1?.imageUrl == e2?.imageUrl &&
        e1?.name == e2?.name;
  }

  @override
  int hash(ShirtLevelsRecord? e) => const ListEquality()
      .hash([e?.minLawns, e?.description, e?.imageUrl, e?.name]);

  @override
  bool isValidKey(Object? o) => o is ShirtLevelsRecord;
}
