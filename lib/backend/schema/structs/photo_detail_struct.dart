// ignore_for_file: unnecessary_getters_setters

import '/backend/supabase_compat/compat_types.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PhotoDetailStruct extends FFFirebaseStruct {
  PhotoDetailStruct({
    String? image,
    String? hashCodeImage,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _image = image,
        _hashCodeImage = hashCodeImage,
        super(firestoreUtilData);

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  set image(String? val) => _image = val;

  bool hasImage() => _image != null;

  // "hash_code_image" field.
  String? _hashCodeImage;
  String get hashCodeImage => _hashCodeImage ?? '';
  set hashCodeImage(String? val) => _hashCodeImage = val;

  bool hasHashCodeImage() => _hashCodeImage != null;

  static PhotoDetailStruct fromMap(Map<String, dynamic> data) =>
      PhotoDetailStruct(
        image: data['image'] as String?,
        hashCodeImage: data['hash_code_image'] as String?,
      );

  static PhotoDetailStruct? maybeFromMap(dynamic data) => data is Map
      ? PhotoDetailStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'image': _image,
        'hash_code_image': _hashCodeImage,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'image': serializeParam(
          _image,
          ParamType.String,
        ),
        'hash_code_image': serializeParam(
          _hashCodeImage,
          ParamType.String,
        ),
      }.withoutNulls;

  static PhotoDetailStruct fromSerializableMap(Map<String, dynamic> data) =>
      PhotoDetailStruct(
        image: deserializeParam(
          data['image'],
          ParamType.String,
          false,
        ),
        hashCodeImage: deserializeParam(
          data['hash_code_image'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'PhotoDetailStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PhotoDetailStruct &&
        image == other.image &&
        hashCodeImage == other.hashCodeImage;
  }

  @override
  int get hashCode => const ListEquality().hash([image, hashCodeImage]);
}

PhotoDetailStruct createPhotoDetailStruct({
  String? image,
  String? hashCodeImage,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PhotoDetailStruct(
      image: image,
      hashCodeImage: hashCodeImage,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PhotoDetailStruct? updatePhotoDetailStruct(
  PhotoDetailStruct? photoDetail, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    photoDetail
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPhotoDetailStructData(
  Map<String, dynamic> firestoreData,
  PhotoDetailStruct? photoDetail,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (photoDetail == null) {
    return;
  }
  if (photoDetail.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && photoDetail.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final photoDetailData =
      getPhotoDetailFirestoreData(photoDetail, forFieldValue);
  final nestedData =
      photoDetailData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = photoDetail.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPhotoDetailFirestoreData(
  PhotoDetailStruct? photoDetail, [
  bool forFieldValue = false,
]) {
  if (photoDetail == null) {
    return {};
  }
  final firestoreData = mapToFirestore(photoDetail.toMap());

  // Add any Firestore field values
  mapToFirestore(photoDetail.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPhotoDetailListFirestoreData(
  List<PhotoDetailStruct>? photoDetails,
) =>
    photoDetails?.map((e) => getPhotoDetailFirestoreData(e, true)).toList() ??
    [];
