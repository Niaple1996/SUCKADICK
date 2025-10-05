import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/emergency_event.dart';

final emergencyRepositoryProvider = Provider<EmergencyRepository>((ref) {
  return EmergencyRepository(firestore: FirebaseFirestore.instance);
});

class EmergencyRepository {
  EmergencyRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String uid) =>
      _firestore.collection('emergency').doc(uid).collection('events');

  Future<void> logEmergency(String uid) {
    return _collection(uid).add(const EmergencyEvent(
      id: '',
      createdAt: DateTime.now(),
      acknowledged: false,
    ).toMap());
  }

  Stream<List<EmergencyEvent>> watchEmergencies(String uid) {
    return _collection(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(EmergencyEvent.fromFirestore).toList());
  }
}
