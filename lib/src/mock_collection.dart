import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kt_dart/kt.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import 'mock_document.dart';
import 'utils.dart';

class MockCollectionReference extends Mock implements CollectionReference {
  final KtList<DocumentReference> documents;

  MockCollectionReference({@required this.documents});

  @override
  DocumentReference document([String path]) =>
      documents.first((it) => it.documentID == path);

  @override
  // TODO: Collection changes propagated to snapshots stream
  Future<DocumentReference> add(Map<String, dynamic> data) {
    final generatedID = randomString(20);

    return Future.value(MockDocumentReference(
      documentID: generatedID,
      data: KtMap.from(data),
    ));
  }
}