import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Contact extends Equatable {
  const Contact({
    required this.id,
    required this.name,
    required this.phone,
    required this.isEmergency,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String phone;
  final bool isEmergency;
  final DateTime createdAt;

  factory Contact.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return Contact(
      id: doc.id,
      name: data['name'] as String? ?? 'Kontakt',
      phone: data['phone'] as String? ?? '',
      isEmergency: data['isEmergency'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phone': phone,
      'isEmergency': isEmergency,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  Contact copyWith({
    String? name,
    String? phone,
    bool? isEmergency,
  }) {
    return Contact(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      isEmergency: isEmergency ?? this.isEmergency,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, phone, isEmergency, createdAt];
}
