import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../firestore_mock.dart';
import 'mock_document.dart';
import 'mock_query.dart';
import 'utils.dart';

// TODO: Collection changes propagated to snapshots stream
class MockCollectionReference extends MockQuery implements CollectionReference {
  final String collection;

  List<DocumentReference> get documents =>
      collectionDataToDocumentReferences(data);

  MockCollectionReference(
      {@required this.collection,
      @required MockFirestore firestore,
      @required Map<String, Map<String, dynamic>> data})
      : super(firestore, data);

  @override
  DocumentReference document([String path]) =>
      documents.firstWhere((it) => it.documentID == path);

  @override

  /// Creates document with [data] and auto-generated id
  ///
  /// The added document can be fetched then using `firestore.collection(...).document('document_id')`
  Future<DocumentReference> add(Map<String, dynamic> data) {
    final generatedID = randomString(20);
    firestore.data[collection][generatedID] = data;
    this.data[generatedID] = data;

    return Future.value(MockDocumentReference(
      documentID: generatedID,
      data: data,
    ));
  }
}
