import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import 'mock_document.dart';
import 'mock_query.dart';
import 'utils.dart';

// TODO: Collection changes propagated to snapshots stream
class MockCollectionReference extends MockQuery implements CollectionReference {
  List<DocumentReference> get documents =>
      collectionDataToDocumentReferences(data);

  MockCollectionReference({@required Map<String, Map<String, dynamic>> data})
      : super(data);

  @override
  DocumentReference document([String path]) =>
      documents.firstWhere((it) => it.documentID == path);

  @override
  Future<DocumentReference> add(Map<String, dynamic> data) {
    final generatedID = randomString(20);

    return Future.value(MockDocumentReference(
      documentID: generatedID,
      data: data,
    ));
  }
}
