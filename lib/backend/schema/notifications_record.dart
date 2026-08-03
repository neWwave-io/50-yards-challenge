import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NotificationsRecord extends FirestoreRecord {
  NotificationsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "notification" field.
  DocumentReference? _notification;
  DocumentReference? get notification => _notification;
  bool hasNotification() => _notification != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "body" field.
  String? _body;
  String get body => _body ?? '';
  bool hasBody() => _body != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  bool hasType() => _type != null;

  // "shirt_request_ref" field.
  DocumentReference? _shirtRequestRef;
  DocumentReference? get shirtRequestRef => _shirtRequestRef;
  bool hasShirtRequestRef() => _shirtRequestRef != null;

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  bool hasState() => _state != null;

  // "region" field.
  String? _region;
  String get region => _region ?? '';
  bool hasRegion() => _region != null;

  // "shirt_level" field.
  ShirtLevel? _shirtLevel;
  ShirtLevel? get shirtLevel => _shirtLevel;
  bool hasShirtLevel() => _shirtLevel != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "is_read" field.
  bool? _isRead;
  bool get isRead => _isRead ?? false;
  bool hasIsRead() => _isRead != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "user_name" field.
  String? _userName;
  String get userName => _userName ?? '';
  bool hasUserName() => _userName != null;

  void _initializeFields() {
    _notification = snapshotData['notification'] as DocumentReference?;
    _title = snapshotData['title'] as String?;
    _body = snapshotData['body'] as String?;
    _type = snapshotData['type'] as String?;
    _shirtRequestRef = snapshotData['shirt_request_ref'] as DocumentReference?;
    _state = snapshotData['state'] as String?;
    _region = snapshotData['region'] as String?;
    _shirtLevel = snapshotData['shirt_level'] is ShirtLevel
        ? snapshotData['shirt_level']
        : deserializeEnum<ShirtLevel>(snapshotData['shirt_level']);
    _status = snapshotData['status'] as String?;
    _isRead = snapshotData['is_read'] as bool?;
    _createdAt = snapshotData['created_at'] as DateTime?;
    _userName = snapshotData['user_name'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('notifications');

  static Stream<NotificationsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => NotificationsRecord.fromSnapshot(s));

  static Future<NotificationsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => NotificationsRecord.fromSnapshot(s));

  static NotificationsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      NotificationsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static NotificationsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      NotificationsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'NotificationsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is NotificationsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createNotificationsRecordData({
  DocumentReference? notification,
  String? title,
  String? body,
  String? type,
  DocumentReference? shirtRequestRef,
  String? state,
  String? region,
  ShirtLevel? shirtLevel,
  String? status,
  bool? isRead,
  DateTime? createdAt,
  String? userName,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'notification': notification,
      'title': title,
      'body': body,
      'type': type,
      'shirt_request_ref': shirtRequestRef,
      'state': state,
      'region': region,
      'shirt_level': shirtLevel,
      'status': status,
      'is_read': isRead,
      'created_at': createdAt,
      'user_name': userName,
    }.withoutNulls,
  );

  return firestoreData;
}

class NotificationsRecordDocumentEquality
    implements Equality<NotificationsRecord> {
  const NotificationsRecordDocumentEquality();

  @override
  bool equals(NotificationsRecord? e1, NotificationsRecord? e2) {
    return e1?.notification == e2?.notification &&
        e1?.title == e2?.title &&
        e1?.body == e2?.body &&
        e1?.type == e2?.type &&
        e1?.shirtRequestRef == e2?.shirtRequestRef &&
        e1?.state == e2?.state &&
        e1?.region == e2?.region &&
        e1?.shirtLevel == e2?.shirtLevel &&
        e1?.status == e2?.status &&
        e1?.isRead == e2?.isRead &&
        e1?.createdAt == e2?.createdAt &&
        e1?.userName == e2?.userName;
  }

  @override
  int hash(NotificationsRecord? e) => const ListEquality().hash([
        e?.notification,
        e?.title,
        e?.body,
        e?.type,
        e?.shirtRequestRef,
        e?.state,
        e?.region,
        e?.shirtLevel,
        e?.status,
        e?.isRead,
        e?.createdAt,
        e?.userName
      ]);

  @override
  bool isValidKey(Object? o) => o is NotificationsRecord;
}
