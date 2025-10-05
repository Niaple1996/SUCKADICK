import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class EmergencyEvent extends Equatable {
  const EmergencyEvent({
    required this.id,
    required this.createdAt,
    required this.acknowledged,
  });

  final String id;
  final DateTime createdAt;
  final bool acknowledged;

  factory EmergencyEvent.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return EmergencyEvent(
      id: doc.id,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      acknowledged: data['acknowledged'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'createdAt': FieldValue.serverTimestamp(),
        'acknowledged': acknowledged,
      };

  @override
  List<Object?> get props => [id, createdAt, acknowledged];
}
