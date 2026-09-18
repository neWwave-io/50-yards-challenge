import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/supabase_compat/compat_query.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SettingsRecord extends FirestoreRecord {
  SettingsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "max_lawn_photos" field.
  int? _maxLawnPhotos;
  int get maxLawnPhotos => _maxLawnPhotos ?? 0;
  bool hasMaxLawnPhotos() => _maxLawnPhotos != null;

  // "auto_shirt_unlock" field.
  bool? _autoShirtUnlock;
  bool get autoShirtUnlock => _autoShirtUnlock ?? false;
  bool hasAutoShirtUnlock() => _autoShirtUnlock != null;

  // "auto_leaderboard_refresh" field.
  bool? _autoLeaderboardRefresh;
  bool get autoLeaderboardRefresh => _autoLeaderboardRefresh ?? false;
  bool hasAutoLeaderboardRefresh() => _autoLeaderboardRefresh != null;

  // "refresh_interval_hours" field.
  int? _refreshIntervalHours;
  int get refreshIntervalHours => _refreshIntervalHours ?? 0;
  bool hasRefreshIntervalHours() => _refreshIntervalHours != null;

  // "allow_dynamic_categories" field.
  bool? _allowDynamicCategories;
  bool get allowDynamicCategories => _allowDynamicCategories ?? false;
  bool hasAllowDynamicCategories() => _allowDynamicCategories != null;

  // "allow_mowed_categories" field.
  List<String>? _allowMowedCategories;
  List<String> get allowMowedCategories => _allowMowedCategories ?? const [];
  bool hasAllowMowedCategories() => _allowMowedCategories != null;

  // "list_state" field.
  List<String>? _listState;
  List<String> get listState => _listState ?? const [];
  bool hasListState() => _listState != null;

  // "find_lawns" field.
  List<FindLawnsStruct>? _findLawns;
  List<FindLawnsStruct> get findLawns => _findLawns ?? const [];
  bool hasFindLawns() => _findLawns != null;

  void _initializeFields() {
    _maxLawnPhotos = castToType<int>(snapshotData['max_lawn_photos']);
    _autoShirtUnlock = snapshotData['auto_shirt_unlock'] as bool?;
    _autoLeaderboardRefresh = snapshotData['auto_leaderboard_refresh'] as bool?;
    _refreshIntervalHours =
        castToType<int>(snapshotData['refresh_interval_hours']);
    _allowDynamicCategories = snapshotData['allow_dynamic_categories'] as bool?;
    _allowMowedCategories = getDataList(snapshotData['allow_mowed_categories']);
    _listState = getDataList(snapshotData['list_state']);
    _findLawns = getStructList(
      snapshotData['find_lawns'],
      FindLawnsStruct.fromMap,
    );
  }

  static CollectionReference get collection =>
      CollectionReference('v1_settings');

  static Stream<SettingsRecord> getDocument(DocumentReference ref) =>
      documentStream(ref, SettingsRecord.fromSnapshot);

  static Future<SettingsRecord> getDocumentOnce(DocumentReference ref) =>
      documentOnce(ref, SettingsRecord.fromSnapshot).then((r) => r!);

  static Future<SettingsRecord?> getDocumentOnceOrNull(DocumentReference ref) =>
      documentOnce(ref, SettingsRecord.fromSnapshot);

  static SettingsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SettingsRecord._(
        snapshot.reference,
        mapFromFirestore(Map<String, dynamic>.from(snapshot.data() ?? {})),
      );

  static SettingsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SettingsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SettingsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SettingsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSettingsRecordData({
  int? maxLawnPhotos,
  bool? autoShirtUnlock,
  bool? autoLeaderboardRefresh,
  int? refreshIntervalHours,
  bool? allowDynamicCategories,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'max_lawn_photos': maxLawnPhotos,
      'auto_shirt_unlock': autoShirtUnlock,
      'auto_leaderboard_refresh': autoLeaderboardRefresh,
      'refresh_interval_hours': refreshIntervalHours,
      'allow_dynamic_categories': allowDynamicCategories,
    }.withoutNulls,
  );

  return firestoreData;
}

class SettingsRecordDocumentEquality implements Equality<SettingsRecord> {
  const SettingsRecordDocumentEquality();

  @override
  bool equals(SettingsRecord? e1, SettingsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.maxLawnPhotos == e2?.maxLawnPhotos &&
        e1?.autoShirtUnlock == e2?.autoShirtUnlock &&
        e1?.autoLeaderboardRefresh == e2?.autoLeaderboardRefresh &&
        e1?.refreshIntervalHours == e2?.refreshIntervalHours &&
        e1?.allowDynamicCategories == e2?.allowDynamicCategories &&
        listEquality.equals(
            e1?.allowMowedCategories, e2?.allowMowedCategories) &&
        listEquality.equals(e1?.listState, e2?.listState) &&
        listEquality.equals(e1?.findLawns, e2?.findLawns);
  }

  @override
  int hash(SettingsRecord? e) => const ListEquality().hash([
        e?.maxLawnPhotos,
        e?.autoShirtUnlock,
        e?.autoLeaderboardRefresh,
        e?.refreshIntervalHours,
        e?.allowDynamicCategories,
        e?.allowMowedCategories,
        e?.listState,
        e?.findLawns
      ]);

  @override
  bool isValidKey(Object? o) => o is SettingsRecord;
}
