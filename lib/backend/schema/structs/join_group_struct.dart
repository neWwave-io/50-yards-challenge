// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class JoinGroupStruct extends FFFirebaseStruct {
  JoinGroupStruct({
    String? childName,
    String? shirtSize,
    String? gender,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _childName = childName,
        _shirtSize = shirtSize,
        _gender = gender,
        super(firestoreUtilData);

  // "child_name" field.
  String? _childName;
  String get childName => _childName ?? '';
  set childName(String? val) => _childName = val;

  bool hasChildName() => _childName != null;

  // "shirt_size" field.
  String? _shirtSize;
  String get shirtSize => _shirtSize ?? '';
  set shirtSize(String? val) => _shirtSize = val;

  bool hasShirtSize() => _shirtSize != null;

  // "gender" field.
  String? _gender;
  String get gender => _gender ?? '';
  set gender(String? val) => _gender = val;

  bool hasGender() => _gender != null;

  static JoinGroupStruct fromMap(Map<String, dynamic> data) => JoinGroupStruct(
        childName: data['child_name'] as String?,
        shirtSize: data['shirt_size'] as String?,
        gender: data['gender'] as String?,
      );

  static JoinGroupStruct? maybeFromMap(dynamic data) => data is Map
      ? JoinGroupStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'child_name': _childName,
        'shirt_size': _shirtSize,
        'gender': _gender,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'child_name': serializeParam(
          _childName,
          ParamType.String,
        ),
        'shirt_size': serializeParam(
          _shirtSize,
          ParamType.String,
        ),
        'gender': serializeParam(
          _gender,
          ParamType.String,
        ),
      }.withoutNulls;

  static JoinGroupStruct fromSerializableMap(Map<String, dynamic> data) =>
      JoinGroupStruct(
        childName: deserializeParam(
          data['child_name'],
          ParamType.String,
          false,
        ),
        shirtSize: deserializeParam(
          data['shirt_size'],
          ParamType.String,
          false,
        ),
        gender: deserializeParam(
          data['gender'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'JoinGroupStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is JoinGroupStruct &&
        childName == other.childName &&
        shirtSize == other.shirtSize &&
        gender == other.gender;
  }

  @override
  int get hashCode => const ListEquality().hash([childName, shirtSize, gender]);
}

JoinGroupStruct createJoinGroupStruct({
  String? childName,
  String? shirtSize,
  String? gender,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    JoinGroupStruct(
      childName: childName,
      shirtSize: shirtSize,
      gender: gender,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

JoinGroupStruct? updateJoinGroupStruct(
  JoinGroupStruct? joinGroup, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    joinGroup
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addJoinGroupStructData(
  Map<String, dynamic> firestoreData,
  JoinGroupStruct? joinGroup,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (joinGroup == null) {
    return;
  }
  if (joinGroup.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && joinGroup.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final joinGroupData = getJoinGroupFirestoreData(joinGroup, forFieldValue);
  final nestedData = joinGroupData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = joinGroup.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getJoinGroupFirestoreData(
  JoinGroupStruct? joinGroup, [
  bool forFieldValue = false,
]) {
  if (joinGroup == null) {
    return {};
  }
  final firestoreData = mapToFirestore(joinGroup.toMap());

  // Add any Firestore field values
  mapToFirestore(joinGroup.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getJoinGroupListFirestoreData(
  List<JoinGroupStruct>? joinGroups,
) =>
    joinGroups?.map((e) => getJoinGroupFirestoreData(e, true)).toList() ?? [];
