import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kt_dart/kt.dart';
import 'package:mockito/mockito.dart';

import '../firestore_mock.dart';
import 'utils.dart';

typedef bool QueryPredicate(KtMapEntry<String, Map<String, dynamic>> entry);

class MockQuerySnapshot extends Mock implements QuerySnapshot {
  final Map<String, Map<String, dynamic>> data;

  MockQuerySnapshot(this.data);

  @override
  List<DocumentSnapshot> get documents => dataToDocumentSnapshots(data);

  @override
  // TODO: implement documentChanges
  List<DocumentChange> get documentChanges => null;
}

class MockQuery extends Mock implements Query {
  final MockFirestore firestore;
  final Map<String, Map<String, dynamic>> data;

  KtMap<String, Map<String, dynamic>> get _ktData => mapFrom(data);

  MockQuery(this.firestore, this.data);

  @override
  Future<QuerySnapshot> getDocuments() => Future.value(MockQuerySnapshot(data));

  @override
  // TODO: WHERE on nested fields
  Query where(String field,
      {isEqualTo,
      isLessThan,
      isLessThanOrEqualTo,
      isGreaterThan,
      isGreaterThanOrEqualTo,
      arrayContains,
      bool isNull}) {
    final filteredData = _ktData
        .filter(_isEqualTo(field, isEqualTo))
        .filter(_isLessThan(field, isLessThan))
        .filter(_isLessThanOrEqualTo(field, isLessThanOrEqualTo))
        .filter(_isGreaterThan(field, isGreaterThan))
        .filter(_isGreaterThanOrEqualTo(field, isGreaterThanOrEqualTo))
        .filter(_arrayContains(field, arrayContains))
        .filter(_isNull(field, isNull))
        .asMap();

    return MockQuery(firestore, filteredData);
  }

  Query limit(int length) {
    if (length >= data.length) {
      return this;
    } else {
      final limitedData = _ktData.toList().take(length).associate((pair) => pair).asMap();

      return MockQuery(firestore, limitedData);
    }
  }

  Query orderBy(String field, {bool descending = false}) {
    Map<String, Map<String, dynamic>> sorted;
    if (!descending) {
      sorted = _ktData
          .toList()
          .sortedWith((p1, p2) => p1.second[field].compareTo(p2.second[field]))
          .associate((pair) => pair)
          .asMap();
    } else {
      sorted = _ktData
          .toList()
          .sortedWith((p1, p2) => p2.second[field].compareTo(p2.second[field]))
          .associate((pair) => pair)
          .asMap();
    }

    return MockQuery(firestore, sorted);
  }

  QueryPredicate _isEqualTo(String field, isEqualTo) =>
      (entry) => isEqualTo != null ? entry.value[field] == isEqualTo : true;

  QueryPredicate _isLessThan(String field, isLessThan) =>
      (entry) => isLessThan != null ? entry.value[field].compareTo(isLessThan) < 0 : true;

  QueryPredicate _isLessThanOrEqualTo(String field, isLessThanOrEqualTo) => (entry) =>
      isLessThanOrEqualTo != null ? entry.value[field].compareTo(isLessThanOrEqualTo) <= 0 : true;

  QueryPredicate _isGreaterThan(String field, isGreaterThan) =>
      (entry) => isGreaterThan != null ? entry.value[field].compareTo(isGreaterThan) > 0 : true;

  QueryPredicate _isGreaterThanOrEqualTo(String field, isGreaterThanOrEqualTo) =>
      (entry) => isGreaterThanOrEqualTo != null
          ? entry.value[field].compareTo(isGreaterThanOrEqualTo) >= 0
          : true;

  QueryPredicate _arrayContains(String field, arrayContains) => (entry) =>
      arrayContains != null ? (entry.value[field] as List).contains(arrayContains) : true;

  QueryPredicate _isNull(String field, bool isNull) =>
      (entry) => isNull != null && isNull ? entry.value[field] == null : true;
}
