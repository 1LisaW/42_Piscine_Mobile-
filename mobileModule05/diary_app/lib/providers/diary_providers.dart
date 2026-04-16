import 'package:diary_app/features/auth/auth_controller.dart';
import 'package:diary_app/models/diary_entry.dart';
import 'package:diary_app/services/diary_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final diaryServiceProvider = Provider<DiaryService>((ref) => DiaryService());

final diaryEntriesProvider = StreamProvider<List<DiaryEntry>>((ref) {
  final userAsync = ref.watch(authStateProvider);
  return userAsync.when(
    data: (user) {
      if (user == null) return Stream.value([]);
      final email = user.email;
      if (email == null || email.isEmpty) return Stream.value([]);
      return ref.watch(diaryServiceProvider).watchEntries(email);
    },
    loading: () => Stream.value([]),
    error: (_, __) => Stream.value([]),
  );
});
