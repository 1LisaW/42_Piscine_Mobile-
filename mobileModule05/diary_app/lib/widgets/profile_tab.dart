import 'package:diary_app/constants/diary_ui_constants.dart';
import 'package:diary_app/models/diary_entry.dart';
import 'package:diary_app/widgets/diary_list_tile.dart';
import 'package:diary_app/widgets/feel_tile.dart';
import 'package:diary_app/widgets/profile_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({
    super.key,
    required this.entriesAsync,
    required this.onOpenEntry,
    this.user,
  });

  final AsyncValue<List<DiaryEntry>> entriesAsync;
  final void Function(DiaryEntry) onOpenEntry;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (user != null) Profile_Info(user: user),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          color: kMintHeader,
          child: SafeArea(
            bottom: false,
            child: Text(
              'Your last diary entries',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DancingScript',
                fontSize: 26,
                color: Colors.grey.shade900,
              ),
            ),
          ),
        ),
        Expanded(
          child: entriesAsync.when(
            data: (entries) {
              if (entries.isEmpty) {
                return Center(
                  child: Text(
                    'No entries yet.\nTap “New diary entry”.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'DancingScript',
                      fontSize: 18,
                      color: Colors.grey.shade700,
                    ),
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: entries.length < 2 ? entries.length : 2,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final e = entries[i];
                  return DiaryListTile(entry: e, onTap: () => onOpenEntry(e));
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          color: kFeelSectionHeader,
          child: SafeArea(
            bottom: false,
            child: Text(
              'Your feel for your 7 entries',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DancingScript',
                fontSize: 26,
                color: Colors.grey.shade900,
              ),
            ),
          ),
        ),
        Expanded(
          child: entriesAsync.when(
            data: (entries) {
              if (entries.isEmpty) {
                return Center(
                  child: Text(
                    'No entries yet.\nTap “New diary entry”.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'DancingScript',
                      fontSize: 18,
                      color: Colors.grey.shade700,
                    ),
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: kMoodEmojis.length,
                separatorBuilder: (_, _) => const SizedBox(height: 5),
                itemBuilder: (context, i) {
                  final filteredEntr = entries.where(
                    (element) => element.moodIndex == i,
                  );
                  final int percent =
                      (filteredEntr.length * 100 / entries.length).truncate();
                  return FeelTile(moodIndex: i, percent: percent);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ),
      ],
    );
  }
}
