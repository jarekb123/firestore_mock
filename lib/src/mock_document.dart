import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kt_dart/kt.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {
  final Map<String, dynamic> data;
  final String documentID;
  final DocumentReference reference;

  MockDocumentSnapshot.fromRef(MockDocumentReference mockReference)
      : data = mockReference.data.asMap(),
        documentID = mockReference.documentID,
        reference = mockReference;
}

class MockDocumentReference extends Mock implements DocumentReference {
  final KtMap<String, dynamic> data;
  final String documentID;

  MockDocumentReference({@required this.documentID, @required this.data});

  @override
  Future<DocumentSnapshot> get() =>
      Future.value(MockDocumentSnapshot.fromRef(this));
}
