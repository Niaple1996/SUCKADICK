import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:senioren_app/data/models/contact.dart';
import 'package:senioren_app/data/repositories/contacts_repository.dart';

class _MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class _MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}

class _MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}

class _MockQuery extends Mock implements Query<Map<String, dynamic>> {}

class _MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}

void main() {
  late ContactsRepository repository;
  late _MockFirebaseFirestore firestore;
  late _MockCollectionReference contactsCollection;
  late _MockDocumentReference userDoc;
  late _MockCollectionReference itemsCollection;
  late _MockQuery emergencyQuery;
  late _MockQuerySnapshot querySnapshot;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    firestore = _MockFirebaseFirestore();
    contactsCollection = _MockCollectionReference();
    userDoc = _MockDocumentReference();
    itemsCollection = _MockCollectionReference();
    emergencyQuery = _MockQuery();
    querySnapshot = _MockQuerySnapshot();

    when(() => firestore.collection(any())).thenReturn(contactsCollection);
    when(() => contactsCollection.doc(any())).thenReturn(userDoc);
    when(() => userDoc.collection(any())).thenReturn(itemsCollection);

    repository = ContactsRepository(firestore: firestore);
  });

  test('addContact throws when emergency limit reached', () async {
    when(() => itemsCollection.where('isEmergency', isEqualTo: true)).thenReturn(emergencyQuery);
    when(() => emergencyQuery.get()).thenAnswer((_) async => querySnapshot);
    when(() => querySnapshot.docs).thenReturn(List.generate(3, (index) {
      final doc = MockDocumentSnapshot();
      when(() => doc.data()).thenReturn({'isEmergency': true});
      return doc;
    }));

    final contact = Contact(
      id: '',
      name: 'Test',
      phone: '123',
      isEmergency: true,
      createdAt: DateTime.now(),
    );

    await expectLater(
      repository.addContact('uid', contact),
      throwsA(isA<StateError>()),
    );
  });

  test('addContact allows non-emergency contacts beyond limit', () async {
    when(() => itemsCollection.add(any())).thenAnswer((_) async => MockDocumentReference());
    final contact = Contact(
      id: '',
      name: 'Test',
      phone: '123',
      isEmergency: false,
      createdAt: DateTime.now(),
    );

    await repository.addContact('uid', contact);
    verify(() => itemsCollection.add(any())).called(1);
  });
}

class MockDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
