// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MowedCategoriesStruct extends FFFirebaseStruct {
  MowedCategoriesStruct({
    String? who,
    int? numMow,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _who = who,
        _numMow = numMow,
        super(firestoreUtilData);

  // "who" field.
  String? _who;
  String get who => _who ?? '';
  set who(String? val) => _who = val;

  bool hasWho() => _who != null;

  // "num_mow" field.
  int? _numMow;
  int get numMow => _numMow ?? 0;
  set numMow(int? val) => _numMow = val;

  void incrementNumMow(int amount) => numMow = numMow + amount;

  bool hasNumMow() => _numMow != null;

  static MowedCategoriesStruct fromMap(Map<String, dynamic> data) =>
      MowedCategoriesStruct(
        who: data['who'] as String?,
        numMow: castToType<int>(data['num_mow']),
      );

  static MowedCategoriesStruct? maybeFromMap(dynamic data) => data is Map
      ? MowedCategoriesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'who': _who,
        'num_mow': _numMow,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'who': serializeParam(
          _who,
          ParamType.String,
        ),
        'num_mow': serializeParam(
          _numMow,
          ParamType.int,
        ),
      }.withoutNulls;

  static MowedCategoriesStruct fromSerializableMap(Map<String, dynamic> data) =>
      MowedCategoriesStruct(
        who: deserializeParam(
          data['who'],
          ParamType.String,
          false,
        ),
        numMow: deserializeParam(
          data['num_mow'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'MowedCategoriesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MowedCategoriesStruct &&
        who == other.who &&
        numMow == other.numMow;
  }

  @override
  int get hashCode => const ListEquality().hash([who, numMow]);
}

MowedCategoriesStruct createMowedCategoriesStruct({
  String? who,
  int? numMow,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    MowedCategoriesStruct(
      who: who,
      numMow: numMow,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

MowedCategoriesStruct? updateMowedCategoriesStruct(
  MowedCategoriesStruct? mowedCategories, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    mowedCategories
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addMowedCategoriesStructData(
  Map<String, dynamic> firestoreData,
  MowedCategoriesStruct? mowedCategories,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (mowedCategories == null) {
    return;
  }
  if (mowedCategories.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && mowedCategories.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final mowedCategoriesData =
      getMowedCategoriesFirestoreData(mowedCategories, forFieldValue);
  final nestedData =
      mowedCategoriesData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = mowedCategories.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getMowedCategoriesFirestoreData(
  MowedCategoriesStruct? mowedCategories, [
  bool forFieldValue = false,
]) {
  if (mowedCategories == null) {
    return {};
  }
  final firestoreData = mapToFirestore(mowedCategories.toMap());

  // Add any Firestore field values
  mapToFirestore(mowedCategories.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getMowedCategoriesListFirestoreData(
  List<MowedCategoriesStruct>? mowedCategoriess,
) =>
    mowedCategoriess
        ?.map((e) => getMowedCategoriesFirestoreData(e, true))
        .toList() ??
    [];
