import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kt_dart/kt.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import 'mock_collection.dart';
import 'mock_document.dart';

class MockFirestore extends Mock implements Firestore {
  final KtMap<String, dynamic> data;

  /// Creates mock for Firestore
  ///
  /// [data] - JSON structured data like in Google Cloud Firestore
  ///
  /// ```json
  /// {
  ///   "articles": {
  ///       "documentid1": {
  ///         "title": "Flutter is Awesome",
  ///         "author": "uid",
  ///         "views": 123,
  ///       },
  ///       "document_id_2": {
  ///         "title": "Kotlin is better than Dart",
  ///         "author": "uid_2",
  ///         "views": 999,
  ///       }
  /// }
  /// ```
  MockFirestore({@required Map<String, dynamic> data})
      : data = KtMap.from(data);

  /// Returns mock for collection at [path].
  ///
  /// Note: Currently only first level collection is supported.
  @override
  CollectionReference collection(String path) {
    final collection = data[path] as KtMap<String, dynamic>;

    return MockCollectionReference(
      documents: collection.map(
        (it) => MockDocumentReference(documentID: it.key, data: it.value),
      ),
    );
  }
}
