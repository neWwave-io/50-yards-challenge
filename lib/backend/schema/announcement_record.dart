import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AnnouncementRecord extends FirestoreRecord {
  AnnouncementRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  bool hasType() => _type != null;

  // "article_link" field.
  String? _articleLink;
  String get articleLink => _articleLink ?? '';
  bool hasArticleLink() => _articleLink != null;

  // "image_detail" field.
  PhotoDetailStruct? _imageDetail;
  PhotoDetailStruct get imageDetail => _imageDetail ?? PhotoDetailStruct();
  bool hasImageDetail() => _imageDetail != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "update_at" field.
  DateTime? _updateAt;
  DateTime? get updateAt => _updateAt;
  bool hasUpdateAt() => _updateAt != null;

  // "video_link" field.
  String? _videoLink;
  String get videoLink => _videoLink ?? '';
  bool hasVideoLink() => _videoLink != null;

  void _initializeFields() {
    _title = snapshotData['title'] as String?;
    _description = snapshotData['description'] as String?;
    _type = snapshotData['type'] as String?;
    _articleLink = snapshotData['article_link'] as String?;
    _imageDetail = snapshotData['image_detail'] is PhotoDetailStruct
        ? snapshotData['image_detail']
        : PhotoDetailStruct.maybeFromMap(snapshotData['image_detail']);
    _createdAt = snapshotData['created_at'] as DateTime?;
    _updateAt = snapshotData['update_at'] as DateTime?;
    _videoLink = snapshotData['video_link'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('announcement');

  static Stream<AnnouncementRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AnnouncementRecord.fromSnapshot(s));

  static Future<AnnouncementRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AnnouncementRecord.fromSnapshot(s));

  static AnnouncementRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AnnouncementRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AnnouncementRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AnnouncementRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AnnouncementRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AnnouncementRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAnnouncementRecordData({
  String? title,
  String? description,
  String? type,
  String? articleLink,
  PhotoDetailStruct? imageDetail,
  DateTime? createdAt,
  DateTime? updateAt,
  String? videoLink,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': title,
      'description': description,
      'type': type,
      'article_link': articleLink,
      'image_detail': PhotoDetailStruct().toMap(),
      'created_at': createdAt,
      'update_at': updateAt,
      'video_link': videoLink,
    }.withoutNulls,
  );

  // Handle nested data for "image_detail" field.
  addPhotoDetailStructData(firestoreData, imageDetail, 'image_detail');

  return firestoreData;
}

class AnnouncementRecordDocumentEquality
    implements Equality<AnnouncementRecord> {
  const AnnouncementRecordDocumentEquality();

  @override
  bool equals(AnnouncementRecord? e1, AnnouncementRecord? e2) {
    return e1?.title == e2?.title &&
        e1?.description == e2?.description &&
        e1?.type == e2?.type &&
        e1?.articleLink == e2?.articleLink &&
        e1?.imageDetail == e2?.imageDetail &&
        e1?.createdAt == e2?.createdAt &&
        e1?.updateAt == e2?.updateAt &&
        e1?.videoLink == e2?.videoLink;
  }

  @override
  int hash(AnnouncementRecord? e) => const ListEquality().hash([
        e?.title,
        e?.description,
        e?.type,
        e?.articleLink,
        e?.imageDetail,
        e?.createdAt,
        e?.updateAt,
        e?.videoLink
      ]);

  @override
  bool isValidKey(Object? o) => o is AnnouncementRecord;
}
