// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TopUsersStruct extends FFFirebaseStruct {
  TopUsersStruct({
    DocumentReference? userRef,
    String? name,
    String? photoUrl,
    int? totalLawns,
    String? state,
    String? hashCodeImage,
    double? totalHours,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _userRef = userRef,
        _name = name,
        _photoUrl = photoUrl,
        _totalLawns = totalLawns,
        _state = state,
        _hashCodeImage = hashCodeImage,
        _totalHours = totalHours,
        super(firestoreUtilData);

  // "user_ref" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  set userRef(DocumentReference? val) => _userRef = val;

  bool hasUserRef() => _userRef != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  set photoUrl(String? val) => _photoUrl = val;

  bool hasPhotoUrl() => _photoUrl != null;

  // "total_lawns" field.
  int? _totalLawns;
  int get totalLawns => _totalLawns ?? 0;
  set totalLawns(int? val) => _totalLawns = val;

  void incrementTotalLawns(int amount) => totalLawns = totalLawns + amount;

  bool hasTotalLawns() => _totalLawns != null;

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  set state(String? val) => _state = val;

  bool hasState() => _state != null;

  // "hash_code_image" field.
  String? _hashCodeImage;
  String get hashCodeImage => _hashCodeImage ?? '';
  set hashCodeImage(String? val) => _hashCodeImage = val;

  bool hasHashCodeImage() => _hashCodeImage != null;

  // "total_hours" field.
  double? _totalHours;
  double get totalHours => _totalHours ?? 0.0;
  set totalHours(double? val) => _totalHours = val;

  void incrementTotalHours(double amount) => totalHours = totalHours + amount;

  bool hasTotalHours() => _totalHours != null;

  static TopUsersStruct fromMap(Map<String, dynamic> data) => TopUsersStruct(
        userRef: data['user_ref'] as DocumentReference?,
        name: data['name'] as String?,
        photoUrl: data['photo_url'] as String?,
        totalLawns: castToType<int>(data['total_lawns']),
        state: data['state'] as String?,
        hashCodeImage: data['hash_code_image'] as String?,
        totalHours: castToType<double>(data['total_hours']),
      );

  static TopUsersStruct? maybeFromMap(dynamic data) =>
      data is Map ? TopUsersStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'user_ref': _userRef,
        'name': _name,
        'photo_url': _photoUrl,
        'total_lawns': _totalLawns,
        'state': _state,
        'hash_code_image': _hashCodeImage,
        'total_hours': _totalHours,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'user_ref': serializeParam(
          _userRef,
          ParamType.DocumentReference,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'photo_url': serializeParam(
          _photoUrl,
          ParamType.String,
        ),
        'total_lawns': serializeParam(
          _totalLawns,
          ParamType.int,
        ),
        'state': serializeParam(
          _state,
          ParamType.String,
        ),
        'hash_code_image': serializeParam(
          _hashCodeImage,
          ParamType.String,
        ),
        'total_hours': serializeParam(
          _totalHours,
          ParamType.double,
        ),
      }.withoutNulls;

  static TopUsersStruct fromSerializableMap(Map<String, dynamic> data) =>
      TopUsersStruct(
        userRef: deserializeParam(
          data['user_ref'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['users'],
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        photoUrl: deserializeParam(
          data['photo_url'],
          ParamType.String,
          false,
        ),
        totalLawns: deserializeParam(
          data['total_lawns'],
          ParamType.int,
          false,
        ),
        state: deserializeParam(
          data['state'],
          ParamType.String,
          false,
        ),
        hashCodeImage: deserializeParam(
          data['hash_code_image'],
          ParamType.String,
          false,
        ),
        totalHours: deserializeParam(
          data['total_hours'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'TopUsersStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TopUsersStruct &&
        userRef == other.userRef &&
        name == other.name &&
        photoUrl == other.photoUrl &&
        totalLawns == other.totalLawns &&
        state == other.state &&
        hashCodeImage == other.hashCodeImage &&
        totalHours == other.totalHours;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [userRef, name, photoUrl, totalLawns, state, hashCodeImage, totalHours]);
}

TopUsersStruct createTopUsersStruct({
  DocumentReference? userRef,
  String? name,
  String? photoUrl,
  int? totalLawns,
  String? state,
  String? hashCodeImage,
  double? totalHours,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    TopUsersStruct(
      userRef: userRef,
      name: name,
      photoUrl: photoUrl,
      totalLawns: totalLawns,
      state: state,
      hashCodeImage: hashCodeImage,
      totalHours: totalHours,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

TopUsersStruct? updateTopUsersStruct(
  TopUsersStruct? topUsers, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    topUsers
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addTopUsersStructData(
  Map<String, dynamic> firestoreData,
  TopUsersStruct? topUsers,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (topUsers == null) {
    return;
  }
  if (topUsers.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && topUsers.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final topUsersData = getTopUsersFirestoreData(topUsers, forFieldValue);
  final nestedData = topUsersData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = topUsers.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getTopUsersFirestoreData(
  TopUsersStruct? topUsers, [
  bool forFieldValue = false,
]) {
  if (topUsers == null) {
    return {};
  }
  final firestoreData = mapToFirestore(topUsers.toMap());

  // Add any Firestore field values
  mapToFirestore(topUsers.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getTopUsersListFirestoreData(
  List<TopUsersStruct>? topUserss,
) =>
    topUserss?.map((e) => getTopUsersFirestoreData(e, true)).toList() ?? [];
