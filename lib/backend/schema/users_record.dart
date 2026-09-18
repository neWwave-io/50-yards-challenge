import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/supabase_compat/compat_query.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  bool hasState() => _state != null;

  // "region" field.
  String? _region;
  String get region => _region ?? '';
  bool hasRegion() => _region != null;

  // "total_lawns" field.
  int? _totalLawns;
  int get totalLawns => _totalLawns ?? 0;
  bool hasTotalLawns() => _totalLawns != null;

  // "shirt_level" field.
  ShirtLevel? _shirtLevel;
  ShirtLevel? get shirtLevel => _shirtLevel;
  bool hasShirtLevel() => _shirtLevel != null;

  // "is_hall_of_fame" field.
  bool? _isHallOfFame;
  bool get isHallOfFame => _isHallOfFame ?? false;
  bool hasIsHallOfFame() => _isHallOfFame != null;

  // "role" field.
  String? _role;
  String get role => _role ?? '';
  bool hasRole() => _role != null;

  // "updated_at" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  bool hasUpdatedAt() => _updatedAt != null;

  // "total_hours" field.
  double? _totalHours;
  double get totalHours => _totalHours ?? 0.0;
  bool hasTotalHours() => _totalHours != null;

  // "user_profile" field.
  PhotoDetailStruct? _userProfile;
  PhotoDetailStruct get userProfile => _userProfile ?? PhotoDetailStruct();
  bool hasUserProfile() => _userProfile != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "is_group" field.
  bool? _isGroup;
  bool get isGroup => _isGroup ?? false;
  bool hasIsGroup() => _isGroup != null;

  // "group_detail" field.
  List<JoinGroupStruct>? _groupDetail;
  List<JoinGroupStruct> get groupDetail => _groupDetail ?? const [];
  bool hasGroupDetail() => _groupDetail != null;

  // "gender" field.
  String? _gender;
  String get gender => _gender ?? '';
  bool hasGender() => _gender != null;

  // "child_name" field.
  String? _childName;
  String get childName => _childName ?? '';
  bool hasChildName() => _childName != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _state = snapshotData['state'] as String?;
    _region = snapshotData['region'] as String?;
    _totalLawns = castToType<int>(snapshotData['total_lawns']);
    _shirtLevel = snapshotData['shirt_level'] is ShirtLevel
        ? snapshotData['shirt_level']
        : deserializeEnum<ShirtLevel>(snapshotData['shirt_level']);
    _isHallOfFame = snapshotData['is_hall_of_fame'] as bool?;
    _role = snapshotData['role'] as String?;
    _updatedAt = snapshotData['updated_at'] as DateTime?;
    _totalHours = castToType<double>(snapshotData['total_hours']);
    _userProfile = snapshotData['user_profile'] is PhotoDetailStruct
        ? snapshotData['user_profile']
        : PhotoDetailStruct.maybeFromMap(snapshotData['user_profile']);
    _photoUrl = snapshotData['photo_url'] as String?;
    _isGroup = snapshotData['is_group'] as bool?;
    _groupDetail = getStructList(
      snapshotData['group_detail'],
      JoinGroupStruct.fromMap,
    );
    _gender = snapshotData['gender'] as String?;
    _childName = snapshotData['child_name'] as String?;
  }

  static CollectionReference get collection =>
      CollectionReference('v1_users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      documentStream(ref, UsersRecord.fromSnapshot);

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      documentOnce(ref, UsersRecord.fromSnapshot).then((r) => r!);

  static Future<UsersRecord?> getDocumentOnceOrNull(DocumentReference ref) =>
      documentOnce(ref, UsersRecord.fromSnapshot);

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(Map<String, dynamic>.from(snapshot.data() ?? {})),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? displayName,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  String? state,
  String? region,
  int? totalLawns,
  ShirtLevel? shirtLevel,
  bool? isHallOfFame,
  String? role,
  DateTime? updatedAt,
  double? totalHours,
  PhotoDetailStruct? userProfile,
  String? photoUrl,
  bool? isGroup,
  String? gender,
  String? childName,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'state': state,
      'region': region,
      'total_lawns': totalLawns,
      'shirt_level': shirtLevel,
      'is_hall_of_fame': isHallOfFame,
      'role': role,
      'updated_at': updatedAt,
      'total_hours': totalHours,
      'user_profile': PhotoDetailStruct().toMap(),
      'photo_url': photoUrl,
      'is_group': isGroup,
      'gender': gender,
      'child_name': childName,
    }.withoutNulls,
  );

  // Handle nested data for "user_profile" field.
  addPhotoDetailStructData(firestoreData, userProfile, 'user_profile');

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    const listEquality = ListEquality();
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.state == e2?.state &&
        e1?.region == e2?.region &&
        e1?.totalLawns == e2?.totalLawns &&
        e1?.shirtLevel == e2?.shirtLevel &&
        e1?.isHallOfFame == e2?.isHallOfFame &&
        e1?.role == e2?.role &&
        e1?.updatedAt == e2?.updatedAt &&
        e1?.totalHours == e2?.totalHours &&
        e1?.userProfile == e2?.userProfile &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.isGroup == e2?.isGroup &&
        listEquality.equals(e1?.groupDetail, e2?.groupDetail) &&
        e1?.gender == e2?.gender &&
        e1?.childName == e2?.childName;
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.state,
        e?.region,
        e?.totalLawns,
        e?.shirtLevel,
        e?.isHallOfFame,
        e?.role,
        e?.updatedAt,
        e?.totalHours,
        e?.userProfile,
        e?.photoUrl,
        e?.isGroup,
        e?.groupDetail,
        e?.gender,
        e?.childName
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
