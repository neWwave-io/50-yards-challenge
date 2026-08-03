// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LawnsPhotosStruct extends FFFirebaseStruct {
  LawnsPhotosStruct({
    PhotoDetailStruct? before,
    PhotoDetailStruct? after,
    PhotoDetailStruct? action,
    PhotoDetailStruct? homeowner,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _before = before,
        _after = after,
        _action = action,
        _homeowner = homeowner,
        super(firestoreUtilData);

  // "before" field.
  PhotoDetailStruct? _before;
  PhotoDetailStruct get before => _before ?? PhotoDetailStruct();
  set before(PhotoDetailStruct? val) => _before = val;

  void updateBefore(Function(PhotoDetailStruct) updateFn) {
    updateFn(_before ??= PhotoDetailStruct());
  }

  bool hasBefore() => _before != null;

  // "after" field.
  PhotoDetailStruct? _after;
  PhotoDetailStruct get after => _after ?? PhotoDetailStruct();
  set after(PhotoDetailStruct? val) => _after = val;

  void updateAfter(Function(PhotoDetailStruct) updateFn) {
    updateFn(_after ??= PhotoDetailStruct());
  }

  bool hasAfter() => _after != null;

  // "action" field.
  PhotoDetailStruct? _action;
  PhotoDetailStruct get action => _action ?? PhotoDetailStruct();
  set action(PhotoDetailStruct? val) => _action = val;

  void updateAction(Function(PhotoDetailStruct) updateFn) {
    updateFn(_action ??= PhotoDetailStruct());
  }

  bool hasAction() => _action != null;

  // "homeowner" field.
  PhotoDetailStruct? _homeowner;
  PhotoDetailStruct get homeowner => _homeowner ?? PhotoDetailStruct();
  set homeowner(PhotoDetailStruct? val) => _homeowner = val;

  void updateHomeowner(Function(PhotoDetailStruct) updateFn) {
    updateFn(_homeowner ??= PhotoDetailStruct());
  }

  bool hasHomeowner() => _homeowner != null;

  static LawnsPhotosStruct fromMap(Map<String, dynamic> data) =>
      LawnsPhotosStruct(
        before: data['before'] is PhotoDetailStruct
            ? data['before']
            : PhotoDetailStruct.maybeFromMap(data['before']),
        after: data['after'] is PhotoDetailStruct
            ? data['after']
            : PhotoDetailStruct.maybeFromMap(data['after']),
        action: data['action'] is PhotoDetailStruct
            ? data['action']
            : PhotoDetailStruct.maybeFromMap(data['action']),
        homeowner: data['homeowner'] is PhotoDetailStruct
            ? data['homeowner']
            : PhotoDetailStruct.maybeFromMap(data['homeowner']),
      );

  static LawnsPhotosStruct? maybeFromMap(dynamic data) => data is Map
      ? LawnsPhotosStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'before': _before?.toMap(),
        'after': _after?.toMap(),
        'action': _action?.toMap(),
        'homeowner': _homeowner?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'before': serializeParam(
          _before,
          ParamType.DataStruct,
        ),
        'after': serializeParam(
          _after,
          ParamType.DataStruct,
        ),
        'action': serializeParam(
          _action,
          ParamType.DataStruct,
        ),
        'homeowner': serializeParam(
          _homeowner,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static LawnsPhotosStruct fromSerializableMap(Map<String, dynamic> data) =>
      LawnsPhotosStruct(
        before: deserializeStructParam(
          data['before'],
          ParamType.DataStruct,
          false,
          structBuilder: PhotoDetailStruct.fromSerializableMap,
        ),
        after: deserializeStructParam(
          data['after'],
          ParamType.DataStruct,
          false,
          structBuilder: PhotoDetailStruct.fromSerializableMap,
        ),
        action: deserializeStructParam(
          data['action'],
          ParamType.DataStruct,
          false,
          structBuilder: PhotoDetailStruct.fromSerializableMap,
        ),
        homeowner: deserializeStructParam(
          data['homeowner'],
          ParamType.DataStruct,
          false,
          structBuilder: PhotoDetailStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'LawnsPhotosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is LawnsPhotosStruct &&
        before == other.before &&
        after == other.after &&
        action == other.action &&
        homeowner == other.homeowner;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([before, after, action, homeowner]);
}

LawnsPhotosStruct createLawnsPhotosStruct({
  PhotoDetailStruct? before,
  PhotoDetailStruct? after,
  PhotoDetailStruct? action,
  PhotoDetailStruct? homeowner,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    LawnsPhotosStruct(
      before: before ?? (clearUnsetFields ? PhotoDetailStruct() : null),
      after: after ?? (clearUnsetFields ? PhotoDetailStruct() : null),
      action: action ?? (clearUnsetFields ? PhotoDetailStruct() : null),
      homeowner: homeowner ?? (clearUnsetFields ? PhotoDetailStruct() : null),
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

LawnsPhotosStruct? updateLawnsPhotosStruct(
  LawnsPhotosStruct? lawnsPhotos, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    lawnsPhotos
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addLawnsPhotosStructData(
  Map<String, dynamic> firestoreData,
  LawnsPhotosStruct? lawnsPhotos,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (lawnsPhotos == null) {
    return;
  }
  if (lawnsPhotos.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && lawnsPhotos.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final lawnsPhotosData =
      getLawnsPhotosFirestoreData(lawnsPhotos, forFieldValue);
  final nestedData =
      lawnsPhotosData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = lawnsPhotos.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getLawnsPhotosFirestoreData(
  LawnsPhotosStruct? lawnsPhotos, [
  bool forFieldValue = false,
]) {
  if (lawnsPhotos == null) {
    return {};
  }
  final firestoreData = mapToFirestore(lawnsPhotos.toMap());

  // Handle nested data for "before" field.
  addPhotoDetailStructData(
    firestoreData,
    lawnsPhotos.hasBefore() ? lawnsPhotos.before : null,
    'before',
    forFieldValue,
  );

  // Handle nested data for "after" field.
  addPhotoDetailStructData(
    firestoreData,
    lawnsPhotos.hasAfter() ? lawnsPhotos.after : null,
    'after',
    forFieldValue,
  );

  // Handle nested data for "action" field.
  addPhotoDetailStructData(
    firestoreData,
    lawnsPhotos.hasAction() ? lawnsPhotos.action : null,
    'action',
    forFieldValue,
  );

  // Handle nested data for "homeowner" field.
  addPhotoDetailStructData(
    firestoreData,
    lawnsPhotos.hasHomeowner() ? lawnsPhotos.homeowner : null,
    'homeowner',
    forFieldValue,
  );

  // Add any Firestore field values
  mapToFirestore(lawnsPhotos.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getLawnsPhotosListFirestoreData(
  List<LawnsPhotosStruct>? lawnsPhotoss,
) =>
    lawnsPhotoss?.map((e) => getLawnsPhotosFirestoreData(e, true)).toList() ??
    [];
