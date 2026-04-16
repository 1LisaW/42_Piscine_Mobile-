import 'package:diary_app/constants/diary_ui_constants.dart';
import 'package:diary_app/models/diary_entry.dart';
import 'package:diary_app/providers/diary_providers.dart';
import 'package:diary_app/features/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

Future<void> showAddDiaryEntryDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  final email = ref.read(authStateProvider).value?.email;
  if (email == null || email.isEmpty) return;

  final titleCtrl = TextEditingController();
  final bodyCtrl = TextEditingController();
  var moodIndex = 0;

  await showDialog<void>(
    context: context,
    barrierColor: Colors.black54,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setLocal) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Add an entry',
              style: TextStyle(
                fontFamily: 'DancingScript',
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontFamily: 'DancingScript'),
                    ),
                    style: const TextStyle(fontFamily: 'DancingScript'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Mood: '),
                      Expanded(
                        child: DropdownButton<int>(
                          isExpanded: true,
                          value: moodIndex,
                          items: List.generate(
                            kMoodEmojis.length,
                            (i) => DropdownMenuItem(
                              value: i,
                              child: Text(
                                kMoodEmojis[i],
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                          onChanged: (v) {
                            if (v != null) {
                              setLocal(() => moodIndex = v);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: bodyCtrl,
                    minLines: 4,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      labelText: 'Text',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontFamily: 'DancingScript'),
                    ),
                    style: const TextStyle(fontFamily: 'DancingScript'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  final title = titleCtrl.text.trim();
                  if (title.isEmpty) return;
                  await ref
                      .read(diaryServiceProvider)
                      .addEntry(
                        email: email,
                        title: title,
                        body: bodyCtrl.text.trim(),
                        moodIndex: moodIndex,
                      );
                  if (ctx.mounted) Navigator.of(ctx).pop();
                },
                child: const Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.lightBlue,
                    fontFamily: 'DancingScript',
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> showReadDiaryEntryDialog(
  BuildContext context,
  WidgetRef ref,
  DiaryEntry entry,
) async {
  final email = ref.read(authStateProvider).value?.email;
  if (email == null || email.isEmpty) return;

  final dateStr = DateFormat('EEEE, MMMM d, y').format(entry.createdAt);
  final mood = kMoodEmojis[entry.moodIndex.clamp(0, kMoodEmojis.length - 1)];

  await showDialog<void>(
    context: context,
    barrierColor: Colors.black54,
    builder: (ctx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          dateStr,
          style: const TextStyle(fontFamily: 'DancingScript', fontSize: 20),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                entry.title,
                style: const TextStyle(
                  fontFamily: 'DancingScript',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'My feeling : $mood',
                style: const TextStyle(fontFamily: 'DancingScript'),
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                entry.body,
                style: const TextStyle(fontFamily: 'DancingScript'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(diaryServiceProvider).deleteEntry(email, entry.id);
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: const Text(
              'Delete this entry',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'DancingScript',
                fontSize: 16,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
