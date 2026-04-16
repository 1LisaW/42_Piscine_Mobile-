import 'package:diary_app/models/diary_entry.dart';

/// Entries whose local calendar day matches [day], newest first.
List<DiaryEntry> entriesOnCalendarDay(List<DiaryEntry> all, DateTime day) {
  final filtered = all.where((e) {
    final c = e.createdAt;
    return c.year == day.year && c.month == day.month && c.day == day.day;
  }).toList();
  filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return filtered;
}
