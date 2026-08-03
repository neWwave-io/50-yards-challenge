import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LeaderboardsRecord extends FirestoreRecord {
  LeaderboardsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "region" field.
  String? _region;
  String get region => _region ?? '';
  bool hasRegion() => _region != null;

  // "last_updated" field.
  DateTime? _lastUpdated;
  DateTime? get lastUpdated => _lastUpdated;
  bool hasLastUpdated() => _lastUpdated != null;

  // "top_users" field.
  List<TopUsersStruct>? _topUsers;
  List<TopUsersStruct> get topUsers => _topUsers ?? const [];
  bool hasTopUsers() => _topUsers != null;

  // "star_of_month" field.
  DocumentReference? _starOfMonth;
  DocumentReference? get starOfMonth => _starOfMonth;
  bool hasStarOfMonth() => _starOfMonth != null;

  void _initializeFields() {
    _region = snapshotData['region'] as String?;
    _lastUpdated = snapshotData['last_updated'] as DateTime?;
    _topUsers = getStructList(
      snapshotData['top_users'],
      TopUsersStruct.fromMap,
    );
    _starOfMonth = snapshotData['star_of_month'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('leaderboards');

  static Stream<LeaderboardsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => LeaderboardsRecord.fromSnapshot(s));

  static Future<LeaderboardsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => LeaderboardsRecord.fromSnapshot(s));

  static LeaderboardsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      LeaderboardsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static LeaderboardsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      LeaderboardsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'LeaderboardsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is LeaderboardsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createLeaderboardsRecordData({
  String? region,
  DateTime? lastUpdated,
  DocumentReference? starOfMonth,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'region': region,
      'last_updated': lastUpdated,
      'star_of_month': starOfMonth,
    }.withoutNulls,
  );

  return firestoreData;
}

class LeaderboardsRecordDocumentEquality
    implements Equality<LeaderboardsRecord> {
  const LeaderboardsRecordDocumentEquality();

  @override
  bool equals(LeaderboardsRecord? e1, LeaderboardsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.region == e2?.region &&
        e1?.lastUpdated == e2?.lastUpdated &&
        listEquality.equals(e1?.topUsers, e2?.topUsers) &&
        e1?.starOfMonth == e2?.starOfMonth;
  }

  @override
  int hash(LeaderboardsRecord? e) => const ListEquality()
      .hash([e?.region, e?.lastUpdated, e?.topUsers, e?.starOfMonth]);

  @override
  bool isValidKey(Object? o) => o is LeaderboardsRecord;
}
