import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import 'mock_collection.dart';

class MockFirestore extends Mock implements Firestore {
  final Map<String, dynamic> data;

  /// Creates mock for Firestore
  ///
  /// [data] - JSON structured data like in Google Cloud Firestore
  ///
  /// ```json
  /// {
  ///   "articles": {
  ///       "document_id_1": {
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
  MockFirestore({@required this.data});

  /// Returns mock for collection at [path].
  ///
  /// Note: Currently only first level collection is supported.
  @override
  CollectionReference collection(String path) {
    final collectionData = data[path] as Map<String, dynamic>;

    return MockCollectionReference(collection: path, firestore: this, data: collectionData);
  }


}
