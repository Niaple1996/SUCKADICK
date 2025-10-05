import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/contact.dart';

final contactsRepositoryProvider = Provider<ContactsRepository>((ref) {
  return ContactsRepository(firestore: FirebaseFirestore.instance);
});

class ContactsRepository {
  ContactsRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String uid) =>
      _firestore.collection('contacts').doc(uid).collection('items');

  Stream<List<Contact>> watchContacts(String uid) {
    return _collection(uid)
        .orderBy('isEmergency', descending: true)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Contact.fromFirestore).toList());
  }

  Future<int> countEmergencyContacts(String uid) async {
    final snapshot = await _collection(uid).where('isEmergency', isEqualTo: true).get();
    return snapshot.docs.length;
  }

  Future<void> addContact(String uid, Contact contact) async {
    if (contact.isEmergency) {
      final count = await countEmergencyContacts(uid);
      if (count >= 3) {
        throw StateError('Maximale Anzahl an Notfallkontakten erreicht.');
      }
    }
    await _collection(uid).add(contact.toMap());
  }

  Future<void> updateContact(String uid, Contact contact) {
    return _collection(uid).doc(contact.id).set(contact.toMap(), SetOptions(merge: true));
  }

  Future<void> deleteContact(String uid, String contactId) {
    return _collection(uid).doc(contactId).delete();
  }
}
