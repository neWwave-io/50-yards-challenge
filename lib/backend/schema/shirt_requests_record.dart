import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ShirtRequestsRecord extends FirestoreRecord {
  ShirtRequestsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "user_ref" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  // "child_name" field.
  String? _childName;
  String get childName => _childName ?? '';
  bool hasChildName() => _childName != null;

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  bool hasState() => _state != null;

  // "region" field.
  String? _region;
  String get region => _region ?? '';
  bool hasRegion() => _region != null;

  // "shirt_level" field.
  String? _shirtLevel;
  String get shirtLevel => _shirtLevel ?? '';
  bool hasShirtLevel() => _shirtLevel != null;

  // "is_group" field.
  bool? _isGroup;
  bool get isGroup => _isGroup ?? false;
  bool hasIsGroup() => _isGroup != null;

  // "lawn_count_at_request" field.
  int? _lawnCountAtRequest;
  int get lawnCountAtRequest => _lawnCountAtRequest ?? 0;
  bool hasLawnCountAtRequest() => _lawnCountAtRequest != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "update_at" field.
  DateTime? _updateAt;
  DateTime? get updateAt => _updateAt;
  bool hasUpdateAt() => _updateAt != null;

  // "group_detail" field.
  List<JoinGroupStruct>? _groupDetail;
  List<JoinGroupStruct> get groupDetail => _groupDetail ?? const [];
  bool hasGroupDetail() => _groupDetail != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  void _initializeFields() {
    _userRef = snapshotData['user_ref'] as DocumentReference?;
    _childName = snapshotData['child_name'] as String?;
    _state = snapshotData['state'] as String?;
    _region = snapshotData['region'] as String?;
    _shirtLevel = snapshotData['shirt_level'] as String?;
    _isGroup = snapshotData['is_group'] as bool?;
    _lawnCountAtRequest =
        castToType<int>(snapshotData['lawn_count_at_request']);
    _status = snapshotData['status'] as String?;
    _createdAt = snapshotData['created_at'] as DateTime?;
    _updateAt = snapshotData['update_at'] as DateTime?;
    _groupDetail = getStructList(
      snapshotData['group_detail'],
      JoinGroupStruct.fromMap,
    );
    _name = snapshotData['name'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('shirt_requests');

  static Stream<ShirtRequestsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ShirtRequestsRecord.fromSnapshot(s));

  static Future<ShirtRequestsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ShirtRequestsRecord.fromSnapshot(s));

  static ShirtRequestsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ShirtRequestsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ShirtRequestsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ShirtRequestsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ShirtRequestsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ShirtRequestsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createShirtRequestsRecordData({
  DocumentReference? userRef,
  String? childName,
  String? state,
  String? region,
  String? shirtLevel,
  bool? isGroup,
  int? lawnCountAtRequest,
  String? status,
  DateTime? createdAt,
  DateTime? updateAt,
  String? name,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user_ref': userRef,
      'child_name': childName,
      'state': state,
      'region': region,
      'shirt_level': shirtLevel,
      'is_group': isGroup,
      'lawn_count_at_request': lawnCountAtRequest,
      'status': status,
      'created_at': createdAt,
      'update_at': updateAt,
      'name': name,
    }.withoutNulls,
  );

  return firestoreData;
}

class ShirtRequestsRecordDocumentEquality
    implements Equality<ShirtRequestsRecord> {
  const ShirtRequestsRecordDocumentEquality();

  @override
  bool equals(ShirtRequestsRecord? e1, ShirtRequestsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.userRef == e2?.userRef &&
        e1?.childName == e2?.childName &&
        e1?.state == e2?.state &&
        e1?.region == e2?.region &&
        e1?.shirtLevel == e2?.shirtLevel &&
        e1?.isGroup == e2?.isGroup &&
        e1?.lawnCountAtRequest == e2?.lawnCountAtRequest &&
        e1?.status == e2?.status &&
        e1?.createdAt == e2?.createdAt &&
        e1?.updateAt == e2?.updateAt &&
        listEquality.equals(e1?.groupDetail, e2?.groupDetail) &&
        e1?.name == e2?.name;
  }

  @override
  int hash(ShirtRequestsRecord? e) => const ListEquality().hash([
        e?.userRef,
        e?.childName,
        e?.state,
        e?.region,
        e?.shirtLevel,
        e?.isGroup,
        e?.lawnCountAtRequest,
        e?.status,
        e?.createdAt,
        e?.updateAt,
        e?.groupDetail,
        e?.name
      ]);

  @override
  bool isValidKey(Object? o) => o is ShirtRequestsRecord;
}
