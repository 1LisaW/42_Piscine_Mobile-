import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryEntry {
  DiaryEntry({
    required this.id,
    required this.title,
    required this.body,
    required this.moodIndex,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String body;
  final int moodIndex;
  final DateTime createdAt;

  static DiaryEntry fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final ts = data['createdAt'];
    DateTime at;
    if (ts is Timestamp) {
      at = ts.toDate();
    } else {
      at = DateTime.now();
    }
    return DiaryEntry(
      id: doc.id,
      title: data['title'] as String? ?? '',
      body: data['body'] as String? ?? '',
      moodIndex: (data['moodIndex'] as num?)?.toInt() ?? 0,
      createdAt: at,
    );
  }
}
