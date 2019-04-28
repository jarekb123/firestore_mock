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
        }
      },
      'users': {
        'uid_1': {
          'username': 'fakeUser',
          'email': 'email@email.com'
        },
        'uid_2': {
          'username': 'fakeUser2',
          'email': 'fake@email.com'
        }
      }
    });
  });

  test('simple fetch data from collection', () async {
    final articlesCollection = mockFirestore.collection('articles');
    final articles = await articlesCollection.getDocuments();

    expect(articles.documents, hasLength(2));
  });

  test('get document by ID from collection', () async {
    final collection = mockFirestore.collection('users');
    final docReference =  collection.document('uid_1');
    final docSnapshot = await docReference.get();

    expect(docSnapshot.documentID, 'uid_1');
    expect(docSnapshot.data, {
      'username': 'fakeUser',
      'email': 'email@email.com'
    });
  });
}
