import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_mock/firestore_mock.dart';
import 'package:test/test.dart';

void main() {
  Firestore mockFirestore;

  setUp(() {
    mockFirestore = MockFirestore(data: {
      'articles': {
        'article_id_1': {
          'title': 'Flutter is awesome',
          'author': 'Mr Smith',
          'views': 123
        },
        'article_id_2': {
          'title': 'Flutter is awesome',
          'author': 'Mr Bean',
          'views': 123
        },
        'article_id_3': {
          'title': 'I love Flutter',
          'author': 'Mr Bean',
          'views': 25
        }
      },
      'users': {
        'uid_1': {'username': 'fakeUser', 'email': 'email@email.com'},
        'uid_2': {'username': 'fakeUser2', 'email': 'fake@email.com'}
      },
      'test_collection': {
        'test_1': {'nullable': null, 'num': 100},
        'test_2': {'nullable': 'non-null', 'num': 90},
        'test_3': {'nullable': null, 'num': 70}
      }
    });
  });

  test('simple fetch data from collection', () async {
    final articlesCollection = mockFirestore.collection('articles');
    final articles = await articlesCollection.getDocuments();

    expect(articles.documents, hasLength(3));
  });

  test('get document by ID from collection', () async {
    final collection = mockFirestore.collection('users');
    final docReference = collection.document('uid_1');
    final docSnapshot = await docReference.get();

    expect(docSnapshot.documentID, 'uid_1');
    expect(
        docSnapshot.data, {'username': 'fakeUser', 'email': 'email@email.com'});
  });

  test('WHERE equalsTo query', () async {
    final filteredData = await mockFirestore
        .collection('users')
        .where('username', isEqualTo: 'fakeUser')
        .getDocuments();

    expect(filteredData.documents, hasLength(1));
    expect(filteredData.documents[0].documentID, 'uid_1');
    expect(filteredData.documents[0].data,
        {'username': 'fakeUser', 'email': 'email@email.com'});

    final filteredArticles = await mockFirestore
        .collection('articles')
        .where('views', isEqualTo: 123)
        .getDocuments();

    expect(filteredArticles.documents, hasLength(2));
    expect(
      filteredArticles.documents
          .where((snapshot) => snapshot.data['views'] == 123),
      hasLength(2),
    );
  });

  test('WHERE isLessThan query', () async {
    final filteredArticles = await mockFirestore
        .collection('articles')
        .where('views', isLessThan: 100)
        .getDocuments();
    expect(filteredArticles.documents, hasLength(1));
  });

  test('WHERE isLessThanOrEqualTo query', () async {
    final filteredArticles = await mockFirestore
        .collection('articles')
        .where('title', isLessThanOrEqualTo: 'G')
        .getDocuments();
    expect(filteredArticles.documents, hasLength(2));
  });

  test('WHERE isGreaterThan query', () async {
    final filteredArticles = await mockFirestore
        .collection('articles')
        .where('views', isGreaterThan: 25)
        .getDocuments();
    expect(filteredArticles.documents, hasLength(2));
    expect(filteredArticles.documents[0].documentID, 'article_id_1');
  });

  test('WHERE isGreaterThanOrEqualTo query', () async {
    final filteredUsers = await mockFirestore
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: 'fake')
        .getDocuments();
    expect(filteredUsers.documents, hasLength(2));
  });

  test('WHERE isNull query', () async {
    final filteredTests = await mockFirestore
        .collection('test_collection')
        .where('nullable', isNull: true)
        .getDocuments();
    expect(filteredTests.documents, hasLength(1));
    expect(filteredTests.documents[0]['nullable'], isNull);
  });

  test('WHERE combined query', () async {
    final filtered = await mockFirestore
        .collection('test_collection')
        .where('num', isGreaterThanOrEqualTo: 70, isLessThan: 100)
        .getDocuments();
    expect(filtered.documents, hasLength(2));
  });

  test('mulitple call WHERE on query', () async {
    final filtered = await mockFirestore
        .collection('test_collection')
        .where('num', isGreaterThan: 70)
        .where('nullable', isNull: true)
        .getDocuments();

    expect(filtered.documents, hasLength(1));
    expect(filtered.documents[0].data['num'], 100);
  });
}
