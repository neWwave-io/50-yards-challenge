// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FindLawnsStruct extends FFFirebaseStruct {
  FindLawnsStruct({
    String? title,
    String? detail,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _title = title,
        _detail = detail,
        super(firestoreUtilData);

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "detail" field.
  String? _detail;
  String get detail => _detail ?? '';
  set detail(String? val) => _detail = val;

  bool hasDetail() => _detail != null;

  static FindLawnsStruct fromMap(Map<String, dynamic> data) => FindLawnsStruct(
        title: data['title'] as String?,
        detail: data['detail'] as String?,
      );

  static FindLawnsStruct? maybeFromMap(dynamic data) => data is Map
      ? FindLawnsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'title': _title,
        'detail': _detail,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'detail': serializeParam(
          _detail,
          ParamType.String,
        ),
      }.withoutNulls;

  static FindLawnsStruct fromSerializableMap(Map<String, dynamic> data) =>
      FindLawnsStruct(
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        detail: deserializeParam(
          data['detail'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'FindLawnsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is FindLawnsStruct &&
        title == other.title &&
        detail == other.detail;
  }

  @override
  int get hashCode => const ListEquality().hash([title, detail]);
}

FindLawnsStruct createFindLawnsStruct({
  String? title,
  String? detail,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    FindLawnsStruct(
      title: title,
      detail: detail,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

FindLawnsStruct? updateFindLawnsStruct(
  FindLawnsStruct? findLawns, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    findLawns
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addFindLawnsStructData(
  Map<String, dynamic> firestoreData,
  FindLawnsStruct? findLawns,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (findLawns == null) {
    return;
  }
  if (findLawns.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && findLawns.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final findLawnsData = getFindLawnsFirestoreData(findLawns, forFieldValue);
  final nestedData = findLawnsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = findLawns.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getFindLawnsFirestoreData(
  FindLawnsStruct? findLawns, [
  bool forFieldValue = false,
]) {
  if (findLawns == null) {
    return {};
  }
  final firestoreData = mapToFirestore(findLawns.toMap());

  // Add any Firestore field values
  mapToFirestore(findLawns.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getFindLawnsListFirestoreData(
  List<FindLawnsStruct>? findLawnss,
) =>
    findLawnss?.map((e) => getFindLawnsFirestoreData(e, true)).toList() ?? [];
