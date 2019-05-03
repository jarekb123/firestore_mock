# firestore_mock

Google Cloud Firestore Test Helpers

## Getting Started

### Create Firestore Mock

```dart
MockFirestore mockFirestore = MockFirestore({
     "articles": {
         "document_id_1": {
           "title": "Flutter is Awesome",
           "author": "uid",
           "views": 123,
         },
         "document_id_2": {
           "title": "Kotlin is better than Dart",
           "author": "uid_2",
           "views": 999,
         }
   }
});
```
### What is implemented (stubbed)?
* Add new document to collection
* Get documents from collection
* Get document by ID from collection
* Query - where, limit, orderBy

Note: Methods (API) that return stream are not stubbed yet.

### Example usage
You can use public cloud_firestore package API.

```dart
final articles = mockFirestore.collection('articles').getDocuments();

print(articles.documents.length); // 3
print(articles.documents[0].documentID); // document_id_1
print(articles.documents[0].data['title']); // Flutter is Awesome
```