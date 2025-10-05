import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class HelpVideo extends Equatable {
  const HelpVideo({
    required this.id,
    required this.title,
    required this.url,
  });

  final String id;
  final String title;
  final String url;

  factory HelpVideo.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return HelpVideo(
      id: doc.id,
      title: data['title'] as String? ?? 'Video',
      url: data['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'title': title,
        'url': url,
      };

  @override
  List<Object?> get props => [id, title, url];
}
