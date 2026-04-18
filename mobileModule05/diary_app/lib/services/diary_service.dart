import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/models/diary_entry.dart';
import 'package:flutter/foundation.dart';

class DiaryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _entries(String email) {
    return _db.collection('notes').doc(email).collection('entries');
  }

  Stream<List<DiaryEntry>> watchEntries(String email) {
    return _entries(email)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(DiaryEntry.fromDoc).toList());
  }

  Future<void> addEntry({
    required String email,
    required String title,
    required String body,
    required int moodIndex,
  }) async {
    final notes = _entries(email);
    final docRef = await notes.add({
      'title': title,
      'body': body,
      'moodIndex': moodIndex,
      'createdAt': FieldValue.serverTimestamp(),
    });
    debugPrint(
      '[DiaryService] entries path=${notes.path} | new document=${docRef.id}',
    );
  }

  Future<void> deleteEntry(String email, String entryId) async {
    await _entries(email).doc(entryId).delete();
  }
}
