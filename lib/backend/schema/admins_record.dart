import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/supabase_compat/compat_query.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AdminsRecord extends FirestoreRecord {
  AdminsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "user_ref" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "role" field.
  String? _role;
  String get role => _role ?? '';
  bool hasRole() => _role != null;

  // "active" field.
  bool? _active;
  bool get active => _active ?? false;
  bool hasActive() => _active != null;

  // "assigned_region" field.
  String? _assignedRegion;
  String get assignedRegion => _assignedRegion ?? '';
  bool hasAssignedRegion() => _assignedRegion != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  void _initializeFields() {
    _userRef = toRefOrNull('v1_users', snapshotData['user_ref']);
    _email = snapshotData['email'] as String?;
    _name = snapshotData['name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _role = snapshotData['role'] as String?;
    _active = snapshotData['active'] as bool?;
    _assignedRegion = snapshotData['assigned_region'] as String?;
    _createdAt = snapshotData['created_at'] as DateTime?;
  }

  static CollectionReference get collection =>
      CollectionReference('v1_admins');

  static Stream<AdminsRecord> getDocument(DocumentReference ref) =>
      documentStream(ref, AdminsRecord.fromSnapshot);

  static Future<AdminsRecord> getDocumentOnce(DocumentReference ref) =>
      documentOnce(ref, AdminsRecord.fromSnapshot).then((r) => r!);

  static Future<AdminsRecord?> getDocumentOnceOrNull(DocumentReference ref) =>
      documentOnce(ref, AdminsRecord.fromSnapshot);

  static AdminsRecord fromSnapshot(DocumentSnapshot snapshot) => AdminsRecord._(
        snapshot.reference,
        mapFromFirestore(Map<String, dynamic>.from(snapshot.data() ?? {})),
      );

  static AdminsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AdminsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AdminsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AdminsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAdminsRecordData({
  DocumentReference? userRef,
  String? email,
  String? name,
  String? photoUrl,
  String? role,
  bool? active,
  String? assignedRegion,
  DateTime? createdAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user_ref': userRef,
      'email': email,
      'name': name,
      'photo_url': photoUrl,
      'role': role,
      'active': active,
      'assigned_region': assignedRegion,
      'created_at': createdAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class AdminsRecordDocumentEquality implements Equality<AdminsRecord> {
  const AdminsRecordDocumentEquality();

  @override
  bool equals(AdminsRecord? e1, AdminsRecord? e2) {
    return e1?.userRef == e2?.userRef &&
        e1?.email == e2?.email &&
        e1?.name == e2?.name &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.role == e2?.role &&
        e1?.active == e2?.active &&
        e1?.assignedRegion == e2?.assignedRegion &&
        e1?.createdAt == e2?.createdAt;
  }

  @override
  int hash(AdminsRecord? e) => const ListEquality().hash([
        e?.userRef,
        e?.email,
        e?.name,
        e?.photoUrl,
        e?.role,
        e?.active,
        e?.assignedRegion,
        e?.createdAt
      ]);

  @override
  bool isValidKey(Object? o) => o is AdminsRecord;
}
