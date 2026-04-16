import 'package:diary_app/models/diary_entry.dart';
import 'package:diary_app/widgets/diary_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DiaryListTile displays entry title', (
    WidgetTester tester,
  ) async {
    final entry = DiaryEntry(
      id: '1',
      title: 'Test title',
      body: 'Body',
      moodIndex: 0,
      createdAt: DateTime(2024, 6, 1),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DiaryListTile(entry: entry, onTap: () {}),
        ),
      ),
    );

    expect(find.text('Test title'), findsOneWidget);
  });
}
