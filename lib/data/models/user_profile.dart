import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.uid,
    required this.displayName,
    required this.preferredLanguage,
    required this.textScale,
    required this.notificationsEnabled,
  });

  final String uid;
  final String displayName;
  final String preferredLanguage;
  final double textScale;
  final bool notificationsEnabled;

  factory UserProfile.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return UserProfile(
      uid: doc.id,
      displayName: data['displayName'] as String? ?? 'Gast',
      preferredLanguage: data['preferredLanguage'] as String? ?? 'de',
      textScale: (data['textScale'] as num?)?.toDouble() ?? 1.0,
      notificationsEnabled: data['notificationsEnabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'displayName': displayName,
      'preferredLanguage': preferredLanguage,
      'textScale': textScale,
      'notificationsEnabled': notificationsEnabled,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  UserProfile copyWith({
    String? displayName,
    String? preferredLanguage,
    double? textScale,
    bool? notificationsEnabled,
  }) {
    return UserProfile(
      uid: uid,
      displayName: displayName ?? this.displayName,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      textScale: textScale ?? this.textScale,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  List<Object?> get props => [uid, displayName, preferredLanguage, textScale, notificationsEnabled];
}
