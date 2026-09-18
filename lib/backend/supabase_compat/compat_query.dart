import 'dart:async';

import '/core/supabase/supabase_config.dart';
import 'compat_types.dart';

/// Executes the Firestore-shaped queries from the v1 screens against Supabase.
///
/// Reads go to the `v1_*` compatibility views, which present the normalized v2
/// tables in the shape the old code expects.

typedef RecordBuilder<T> = T Function(DocumentSnapshot snapshot);

T? _safeBuild<T>(
  DocumentSnapshot snapshot,
  RecordBuilder<T> builder,
) {
  try {
    return builder(snapshot);
  } catch (e) {
    // ignore: avoid_print
    print('Error serializing ${snapshot.reference.path}: $e');
    return null;
  }
}

List<T> _mapRows<T>(
  List<dynamic> rows,
  String collectionName,
  RecordBuilder<T> builder,
) =>
    rows
        .map((row) {
          final map = Map<String, dynamic>.from(row as Map);
          final ref = DocumentReference(
            collectionName,
            '${map['id']}',
          );
          return _safeBuild(DocumentSnapshot(ref, map), builder);
        })
        .whereType<T>()
        .toList();

Query _build(Query collection, Query Function(Query)? queryBuilder,
    int limit, bool singleRecord) {
  var query = (queryBuilder ?? (q) => q)(collection);
  if (limit > 0 || singleRecord) {
    query = query.limit(singleRecord ? 1 : limit);
  }
  return query;
}

Future<int> queryCollectionCount(
  Query collection, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) async {
  try {
    final query = _build(collection, queryBuilder, limit, false);
    final rows = await applyQuery(query) as List<dynamic>;
    return rows.length;
  } catch (e) {
    // ignore: avoid_print
    print('Error counting ${collection.collectionName}: $e');
    return 0;
  }
}

Future<List<T>> queryCollectionOnce<T>(
  Query collection,
  RecordBuilder<T> recordBuilder, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) async {
  try {
    final query = _build(collection, queryBuilder, limit, singleRecord);
    final rows = await applyQuery(query) as List<dynamic>;
    return _mapRows(rows, collection.collectionName, recordBuilder);
  } catch (e) {
    // ignore: avoid_print
    print('Error querying ${collection.collectionName}: $e');
    return <T>[];
  }
}

/// Stream equivalent of Firestore's `.snapshots()`.
///
/// Supabase Realtime only streams base tables, not views, and these queries run
/// against `v1_*` views. So this polls instead: an immediate fetch, then a
/// refresh every few seconds. That is enough for the v1 screens, which used
/// streams for convenience rather than for true realtime.
///
/// v2 screens should subscribe to the real tables through repositories rather
/// than use this.
Stream<List<T>> queryCollection<T>(
  Query collection,
  RecordBuilder<T> recordBuilder, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
  Duration pollInterval = const Duration(seconds: 5),
}) {
  late StreamController<List<T>> controller;
  Timer? timer;
  var closed = false;

  Future<void> fetch() async {
    if (closed) return;
    final result = await queryCollectionOnce<T>(
      collection,
      recordBuilder,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );
    if (!closed && !controller.isClosed) controller.add(result);
  }

  controller = StreamController<List<T>>(
    onListen: () {
      fetch();
      timer = Timer.periodic(pollInterval, (_) => fetch());
    },
    onCancel: () {
      closed = true;
      timer?.cancel();
    },
  );

  return controller.stream;
}

/// Single-document stream, replacing `DocumentReference.snapshots()`.
Stream<T> documentStream<T>(
  DocumentReference ref,
  RecordBuilder<T> recordBuilder, {
  Duration pollInterval = const Duration(seconds: 5),
}) {
  late StreamController<T> controller;
  Timer? timer;
  var closed = false;

  Future<void> fetch() async {
    if (closed) return;
    try {
      final row = await supabase
          .from(ref.collectionName)
          .select()
          .eq('id', ref.id)
          .maybeSingle();
      if (row == null || closed || controller.isClosed) return;
      final record =
          _safeBuild(DocumentSnapshot(ref, Map<String, dynamic>.from(row)),
              recordBuilder);
      if (record != null) controller.add(record);
    } catch (e) {
      // ignore: avoid_print
      print('Error streaming ${ref.path}: $e');
    }
  }

  controller = StreamController<T>(
    onListen: () {
      fetch();
      timer = Timer.periodic(pollInterval, (_) => fetch());
    },
    onCancel: () {
      closed = true;
      timer?.cancel();
    },
  );

  return controller.stream;
}

Future<T?> documentOnce<T>(
  DocumentReference ref,
  RecordBuilder<T> recordBuilder,
) async {
  try {
    final row = await supabase
        .from(ref.collectionName)
        .select()
        .eq('id', ref.id)
        .maybeSingle();
    if (row == null) return null;
    return _safeBuild(
      DocumentSnapshot(ref, Map<String, dynamic>.from(row)),
      recordBuilder,
    );
  } catch (e) {
    // ignore: avoid_print
    print('Error fetching ${ref.path}: $e');
    return null;
  }
}

/// v1 used `Filter` objects for OR/IN composition. Only `filterIn` is used,
/// and only to build a whereIn clause.
class Filter {
  const Filter(this.field, {this.whereIn});
  final String field;
  final List<dynamic>? whereIn;
}

Filter filterIn(String field, List? list) =>
    Filter(field, whereIn: (list?.isEmpty ?? true) ? null : list);
