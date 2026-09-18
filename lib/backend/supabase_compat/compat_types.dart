import 'package:collection/collection.dart';

import '/core/supabase/supabase_config.dart';

/// Firestore-shaped types backed by Supabase.
///
/// The v1 screens were generated against cloud_firestore. Rather than rewrite
/// 86 UI files, this reproduces the small slice of the Firestore API they
/// actually use — `Query` (28 uses), `DocumentReference` (5) and
/// `FieldValue.increment` (2) — on top of Postgres.
///
/// Reads hit the `v1_*` compatibility views, which present the normalized v2
/// tables in the old document shape. Writes go to those same views, which are
/// made updatable by INSTEAD OF triggers.
///
/// This is a migration shim. It goes away as v2 screens talk to the real
/// tables through repositories.

/// Marker for `FieldValue.increment(n)`, resolved at write time.
class FieldValue {
  const FieldValue._(this.kind, this.value);

  final String kind;
  final Object? value;

  static FieldValue increment(num amount) => FieldValue._('increment', amount);
  static FieldValue serverTimestamp() =>
      const FieldValue._('serverTimestamp', null);
  static FieldValue delete() => const FieldValue._('delete', null);

  @override
  String toString() => 'FieldValue($kind, $value)';
}

/// Points at one row: a source (view name) plus its primary key.
class DocumentReference {
  const DocumentReference(this.collectionName, this.id);

  /// The `v1_*` view this row lives in.
  final String collectionName;

  /// Primary key, always text on the compat views.
  final String id;

  /// Firestore-style path, e.g. "users/abc123". The v1 code stores and
  /// compares these, so the format has to survive.
  String get path => '$collectionName/$id';

  Future<void> update(Map<String, dynamic> data) async {
    final payload = await _resolveFieldValues(collectionName, id, data);
    if (payload.isEmpty) return;
    await supabase.from(collectionName).update(payload).eq('id', id);
  }

  Future<void> set(Map<String, dynamic> data, {bool merge = false}) async {
    final payload = await _resolveFieldValues(collectionName, id, data);
    if (merge) {
      await supabase.from(collectionName).update(payload).eq('id', id);
    } else {
      await supabase.from(collectionName).upsert({...payload, 'id': id});
    }
  }

  Future<void> delete() async {
    await supabase.from(collectionName).delete().eq('id', id);
  }

  /// Resolves FieldValue sentinels, which Postgres has no concept of.
  /// `increment` needs the current value, so it costs one extra read.
  Future<Map<String, dynamic>> _resolveFieldValues(
    String table,
    String rowId,
    Map<String, dynamic> data,
  ) async {
    final sentinels = data.entries.where((e) => e.value is FieldValue).toList();
    if (sentinels.isEmpty) {
      return Map<String, dynamic>.from(data)
        ..removeWhere((_, v) => v == null);
    }

    final incrementFields = sentinels
        .where((e) => (e.value as FieldValue).kind == 'increment')
        .toList();

    Map<String, dynamic>? current;
    if (incrementFields.isNotEmpty) {
      current = await supabase
          .from(table)
          .select(incrementFields.map((e) => e.key).join(','))
          .eq('id', rowId)
          .maybeSingle();
    }

    final out = <String, dynamic>{};
    data.forEach((key, value) {
      if (value is! FieldValue) {
        if (value != null) out[key] = value;
        return;
      }
      switch (value.kind) {
        case 'increment':
          final existing = (current?[key] as num?) ?? 0;
          out[key] = existing + (value.value as num);
          break;
        case 'serverTimestamp':
          out[key] = DateTime.now().toUtc().toIso8601String();
          break;
        case 'delete':
          out[key] = null;
          break;
      }
    });
    return out;
  }

  /// v1 used `.parent` to recover the collection from a reference.
  CollectionReference get parent => CollectionReference(collectionName);

  /// v1 called `.get()` on a reference to fetch the document.
  Future<DocumentSnapshot> get() async {
    final row = await supabase
        .from(collectionName)
        .select()
        .eq('id', id)
        .maybeSingle();
    return DocumentSnapshot(
      this,
      row == null ? null : Map<String, dynamic>.from(row),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is DocumentReference &&
      other.collectionName == collectionName &&
      other.id == id;

  @override
  int get hashCode => path.hashCode;

  @override
  String toString() => 'DocumentReference($path)';
}

/// One row plus its identity, mirroring Firestore's DocumentSnapshot.
class DocumentSnapshot {
  const DocumentSnapshot(this.reference, this._data);

  final DocumentReference reference;
  final Map<String, dynamic>? _data;

  String get id => reference.id;
  bool get exists => _data != null;
  Map<String, dynamic>? data() => _data;
}

enum FilterOp { eq, neq, lt, lte, gt, gte, isNull, notNull, inList, contains }

class QueryFilter {
  const QueryFilter(this.field, this.op, this.value);
  final String field;
  final FilterOp op;
  final Object? value;
}

class QueryOrder {
  const QueryOrder(this.field, this.descending);
  final String field;
  final bool descending;
}

/// Fluent query builder matching the Firestore surface the v1 screens use.
///
/// Immutable: every method returns a new Query, so the `queryBuilder:
/// (q) => q.where(...).orderBy(...)` lambdas behave as they did.
class Query {
  const Query(
    this.collectionName, {
    this.filters = const [],
    this.orders = const [],
    this.limitCount,
  });

  final String collectionName;
  final List<QueryFilter> filters;
  final List<QueryOrder> orders;
  final int? limitCount;

  Query _copyWith({
    List<QueryFilter>? filters,
    List<QueryOrder>? orders,
    int? limitCount,
  }) =>
      Query(
        collectionName,
        filters: filters ?? this.filters,
        orders: orders ?? this.orders,
        limitCount: limitCount ?? this.limitCount,
      );

  Query where(
    String field, {
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    List<Object?>? whereIn,
    bool? isNull,
  }) {
    final added = <QueryFilter>[];
    if (isEqualTo != null) added.add(QueryFilter(field, FilterOp.eq, isEqualTo));
    if (isNotEqualTo != null) added.add(QueryFilter(field, FilterOp.neq, isNotEqualTo));
    if (isLessThan != null) added.add(QueryFilter(field, FilterOp.lt, isLessThan));
    if (isLessThanOrEqualTo != null) {
      added.add(QueryFilter(field, FilterOp.lte, isLessThanOrEqualTo));
    }
    if (isGreaterThan != null) added.add(QueryFilter(field, FilterOp.gt, isGreaterThan));
    if (isGreaterThanOrEqualTo != null) {
      added.add(QueryFilter(field, FilterOp.gte, isGreaterThanOrEqualTo));
    }
    if (arrayContains != null) {
      added.add(QueryFilter(field, FilterOp.contains, arrayContains));
    }
    if (whereIn != null) added.add(QueryFilter(field, FilterOp.inList, whereIn));
    if (isNull != null) {
      added.add(QueryFilter(field, isNull ? FilterOp.isNull : FilterOp.notNull, null));
    }
    return _copyWith(filters: [...filters, ...added]);
  }

  Query orderBy(String field, {bool descending = false}) =>
      _copyWith(orders: [...orders, QueryOrder(field, descending)]);

  Query limit(int count) => _copyWith(limitCount: count);

  /// Firestore allowed a startAfter cursor; nothing in v1 uses it, so it is
  /// deliberately not implemented rather than silently wrong.
  Query startAfterDocument(DocumentSnapshot _) => throw UnimplementedError(
        'startAfterDocument is not supported by the Supabase compat layer',
      );
}

/// A Query that can also address single documents.
class CollectionReference extends Query {
  const CollectionReference(super.collectionName);

  DocumentReference doc([String? id]) =>
      DocumentReference(collectionName, id ?? _newId());

  static int _counter = 0;
  static String _newId() =>
      '${DateTime.now().microsecondsSinceEpoch}_${_counter++}';
}

/// Serializes a filter value for Postgres. DocumentReference becomes its id,
/// because the compat views expose reference columns as plain text ids.
Object? _encode(Object? value) {
  if (value is DocumentReference) return value.id;
  if (value is DateTime) return value.toUtc().toIso8601String();
  if (value is Enum) return value.name;
  if (value is Iterable) return value.map(_encode).toList();
  return value;
}

/// Applies the accumulated filters/ordering to a Supabase request.
dynamic applyQuery(Query query) {
  dynamic builder = supabase.from(query.collectionName).select();

  for (final f in query.filters) {
    final v = _encode(f.value);
    switch (f.op) {
      case FilterOp.eq:
        builder = builder.eq(f.field, v as Object);
        break;
      case FilterOp.neq:
        builder = builder.neq(f.field, v as Object);
        break;
      case FilterOp.lt:
        builder = builder.lt(f.field, v as Object);
        break;
      case FilterOp.lte:
        builder = builder.lte(f.field, v as Object);
        break;
      case FilterOp.gt:
        builder = builder.gt(f.field, v as Object);
        break;
      case FilterOp.gte:
        builder = builder.gte(f.field, v as Object);
        break;
      case FilterOp.contains:
        builder = builder.contains(f.field, v as Object);
        break;
      case FilterOp.inList:
        builder = builder.inFilter(f.field, (v as List).cast<Object>());
        break;
      case FilterOp.isNull:
        builder = builder.isFilter(f.field, null);
        break;
      case FilterOp.notNull:
        builder = builder.not(f.field, 'is', null);
        break;
    }
  }

  for (final o in query.orders) {
    builder = builder.order(o.field, ascending: !o.descending);
  }
  if (query.limitCount != null && query.limitCount! > 0) {
    builder = builder.limit(query.limitCount!);
  }
  return builder;
}

/// True when two reference-ish values point at the same row.
bool sameRef(Object? a, Object? b) {
  final x = a is DocumentReference ? a.id : a;
  final y = b is DocumentReference ? b.id : b;
  return const DeepCollectionEquality().equals(x, y);
}
