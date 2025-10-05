import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CheckinSettings extends Equatable {
  const CheckinSettings({
    required this.frequency,
    required this.nextDueAt,
    required this.enabled,
  });

  final String frequency;
  final DateTime? nextDueAt;
  final bool enabled;

  factory CheckinSettings.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return CheckinSettings(
      frequency: data['frequency'] as String? ?? 'daily',
      nextDueAt: (data['nextDueAt'] as Timestamp?)?.toDate(),
      enabled: data['enabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'frequency': frequency,
      'nextDueAt': nextDueAt != null ? Timestamp.fromDate(nextDueAt!) : FieldValue.serverTimestamp(),
      'enabled': enabled,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  CheckinSettings copyWith({
    String? frequency,
    DateTime? nextDueAt,
    bool? enabled,
  }) {
    return CheckinSettings(
      frequency: frequency ?? this.frequency,
      nextDueAt: nextDueAt ?? this.nextDueAt,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  List<Object?> get props => [frequency, nextDueAt, enabled];
}
