import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/checkin_settings.dart';

final checkinRepositoryProvider = Provider<CheckinRepository>((ref) {
  return CheckinRepository(firestore: FirebaseFirestore.instance);
});

class CheckinRepository {
  CheckinRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _firestore.collection('checkins').doc(uid);

  Stream<CheckinSettings> watchSettings(String uid) {
    return _doc(uid).snapshots().map(CheckinSettings.fromFirestore);
  }

  Future<void> saveSettings(String uid, CheckinSettings settings) {
    return _doc(uid).set(settings.toMap(), SetOptions(merge: true));
  }
}
