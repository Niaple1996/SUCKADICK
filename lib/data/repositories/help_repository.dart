import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/help_video.dart';

final helpRepositoryProvider = Provider<HelpRepository>((ref) {
  return HelpRepository(firestore: FirebaseFirestore.instance);
});

class HelpRepository {
  HelpRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('help').doc('videos').collection('items');

  Stream<List<HelpVideo>> watchVideos() {
    return _collection.snapshots().map(
          (snapshot) => snapshot.docs.map(HelpVideo.fromFirestore).toList(),
        );
  }
}
