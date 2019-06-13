import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kt_dart/kt.dart';

import 'mock_document.dart';

String randomString(int length) {
  var rand = new Random();
  var codeUnits = new List.generate(length, (index) {
    return rand.nextInt(33) + 89;
  });

  return new String.fromCharCodes(codeUnits);
}

List<String> pathPartsOf(String path) => path.split('/');

List<DocumentReference> collectionDataToDocumentReferences(
  Map<String, Map<String, dynamic>> data,
) {
  return mapFrom(data).map((entry) {
    return MockDocumentReference(documentID: entry.key, data: entry.value);
  }).asList();
}

List<DocumentSnapshot> dataToDocumentSnapshots(
    Map<String, Map<String, dynamic>> data) {
  return collectionDataToDocumentReferences(data)
      .map((ref) => MockDocumentSnapshot.fromRef(ref))
      .toList(growable: false);
}
