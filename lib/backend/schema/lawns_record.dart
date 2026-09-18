import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/supabase_compat/compat_query.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LawnsRecord extends FirestoreRecord {
  LawnsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "user_ref" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  // "who_for" field.
  String? _whoFor;
  String get whoFor => _whoFor ?? '';
  bool hasWhoFor() => _whoFor != null;

  // "hours_taken" field.
  double? _hoursTaken;
  double get hoursTaken => _hoursTaken ?? 0.0;
  bool hasHoursTaken() => _hoursTaken != null;

  // "photos" field.
  LawnsPhotosStruct? _photos;
  LawnsPhotosStruct get photos => _photos ?? LawnsPhotosStruct();
  bool hasPhotos() => _photos != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "verified_by" field.
  DocumentReference? _verifiedBy;
  DocumentReference? get verifiedBy => _verifiedBy;
  bool hasVerifiedBy() => _verifiedBy != null;

  // "verified_at" field.
  DateTime? _verifiedAt;
  DateTime? get verifiedAt => _verifiedAt;
  bool hasVerifiedAt() => _verifiedAt != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "notes" field.
  String? _notes;
  String get notes => _notes ?? '';
  bool hasNotes() => _notes != null;

  // "updated_at" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  bool hasUpdatedAt() => _updatedAt != null;

  void _initializeFields() {
    _userRef = toRefOrNull('v1_users', snapshotData['user_ref']);
    _whoFor = snapshotData['who_for'] as String?;
    _hoursTaken = castToType<double>(snapshotData['hours_taken']);
    _photos = snapshotData['photos'] is LawnsPhotosStruct
        ? snapshotData['photos']
        : LawnsPhotosStruct.maybeFromMap(snapshotData['photos']);
    _status = snapshotData['status'] as String?;
    _verifiedBy = toRefOrNull('v1_users', snapshotData['verified_by']);
    _verifiedAt = snapshotData['verified_at'] as DateTime?;
    _createdAt = snapshotData['created_at'] as DateTime?;
    _notes = snapshotData['notes'] as String?;
    _updatedAt = snapshotData['updated_at'] as DateTime?;
  }

  static CollectionReference get collection =>
      CollectionReference('v1_lawns');

  static Stream<LawnsRecord> getDocument(DocumentReference ref) =>
      documentStream(ref, LawnsRecord.fromSnapshot);

  static Future<LawnsRecord> getDocumentOnce(DocumentReference ref) =>
      documentOnce(ref, LawnsRecord.fromSnapshot).then((r) => r!);

  static Future<LawnsRecord?> getDocumentOnceOrNull(DocumentReference ref) =>
      documentOnce(ref, LawnsRecord.fromSnapshot);

  static LawnsRecord fromSnapshot(DocumentSnapshot snapshot) => LawnsRecord._(
        snapshot.reference,
        mapFromFirestore(Map<String, dynamic>.from(snapshot.data() ?? {})),
      );

  static LawnsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      LawnsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'LawnsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is LawnsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createLawnsRecordData({
  DocumentReference? userRef,
  String? whoFor,
  double? hoursTaken,
  LawnsPhotosStruct? photos,
  String? status,
  DocumentReference? verifiedBy,
  DateTime? verifiedAt,
  DateTime? createdAt,
  String? notes,
  DateTime? updatedAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user_ref': userRef,
      'who_for': whoFor,
      'hours_taken': hoursTaken,
      'photos': LawnsPhotosStruct().toMap(),
      'status': status,
      'verified_by': verifiedBy,
      'verified_at': verifiedAt,
      'created_at': createdAt,
      'notes': notes,
      'updated_at': updatedAt,
    }.withoutNulls,
  );

  // Handle nested data for "photos" field.
  addLawnsPhotosStructData(firestoreData, photos, 'photos');

  return firestoreData;
}

class LawnsRecordDocumentEquality implements Equality<LawnsRecord> {
  const LawnsRecordDocumentEquality();

  @override
  bool equals(LawnsRecord? e1, LawnsRecord? e2) {
    return e1?.userRef == e2?.userRef &&
        e1?.whoFor == e2?.whoFor &&
        e1?.hoursTaken == e2?.hoursTaken &&
        e1?.photos == e2?.photos &&
        e1?.status == e2?.status &&
        e1?.verifiedBy == e2?.verifiedBy &&
        e1?.verifiedAt == e2?.verifiedAt &&
        e1?.createdAt == e2?.createdAt &&
        e1?.notes == e2?.notes &&
        e1?.updatedAt == e2?.updatedAt;
  }

  @override
  int hash(LawnsRecord? e) => const ListEquality().hash([
        e?.userRef,
        e?.whoFor,
        e?.hoursTaken,
        e?.photos,
        e?.status,
        e?.verifiedBy,
        e?.verifiedAt,
        e?.createdAt,
        e?.notes,
        e?.updatedAt
      ]);

  @override
  bool isValidKey(Object? o) => o is LawnsRecord;
}
