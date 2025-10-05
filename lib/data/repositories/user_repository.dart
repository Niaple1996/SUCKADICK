import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firestore = FirebaseFirestore.instance;
  return UserRepository(firestore: firestore);
});

class UserRepository {
  UserRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('users');

  Stream<UserProfile> watchProfile(String uid) {
    return _collection.doc(uid).snapshots().map(UserProfile.fromFirestore);
  }

  Future<void> saveProfile(UserProfile profile) {
    return _collection.doc(profile.uid).set(profile.toMap(), SetOptions(merge: true));
  }
}
