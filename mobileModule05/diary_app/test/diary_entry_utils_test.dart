import 'package:diary_app/models/diary_entry.dart';
import 'package:diary_app/utils/diary_entry_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('entriesOnCalendarDay', () {
    test('returns entries matching local calendar day, newest first', () {
      final day = DateTime(2024, 3, 16);
      final older = DiaryEntry(
        id: 'a',
        title: 'Old',
        body: '',
        moodIndex: 0,
        createdAt: DateTime(2024, 3, 16, 9, 0),
      );
      final newer = DiaryEntry(
        id: 'b',
        title: 'New',
        body: '',
        moodIndex: 1,
        createdAt: DateTime(2024, 3, 16, 18, 30),
      );
      final otherDay = DiaryEntry(
        id: 'c',
        title: 'Other',
        body: '',
        moodIndex: 0,
        createdAt: DateTime(2024, 3, 15, 23, 59),
      );

      final result = entriesOnCalendarDay([older, newer, otherDay], day);

      expect(result.length, 2);
      expect(result.first.id, 'b');
      expect(result.last.id, 'a');
    });

    test('excludes entries on a different day', () {
      final day = DateTime(2024, 1, 1);
      final entries = [
        DiaryEntry(
          id: 'x',
          title: 't',
          body: '',
          moodIndex: 0,
          createdAt: DateTime(2024, 1, 2),
        ),
      ];

      expect(entriesOnCalendarDay(entries, day), isEmpty);
    });
  });
}
