import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kt_dart/kt.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import 'mock_document.dart';
import 'utils.dart';

// TODO: Collection changes propagated to snapshots stream
class MockCollectionReference extends Mock implements CollectionReference {
  final Map<String, dynamic> data;

  List<DocumentReference> get documents =>
      _collectionDataToDocumentReferences(data);

  MockCollectionReference({@required this.data});

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

  @override
  Future<QuerySnapshot> getDocuments() {
    // TODO: implement getDocuments
    return null;
  }
}

List<DocumentReference> _collectionDataToDocumentReferences(
  Map<String, Map<String, dynamic>> data,
) {
  return mapFrom(data).map((entry) {
    return MockDocumentReference(documentID: entry.key, data: entry.value);
  }).asList();
}
