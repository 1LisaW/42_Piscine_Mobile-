import 'package:diary_app/constants/diary_ui_constants.dart';
import 'package:diary_app/models/diary_entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiaryListTile extends StatelessWidget {
  const DiaryListTile({super.key, required this.entry, required this.onTap});

  final DiaryEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final day = DateFormat('d').format(entry.createdAt);
    final month = DateFormat('MMMM').format(entry.createdAt);
    final year = DateFormat('y').format(entry.createdAt);
    final mood = kMoodEmojis[entry.moodIndex.clamp(0, kMoodEmojis.length - 1)];

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kCardBorder, width: 1.2),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 56,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      day,
                      style: TextStyle(
                        fontFamily: 'DancingScript',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    Text(
                      month,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'DancingScript',
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      year,
                      style: TextStyle(
                        fontFamily: 'DancingScript',
                        fontSize: 11,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              Text(mood, style: const TextStyle(fontSize: 28)),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 1,
                height: 52,
                color: Colors.grey.shade400,
              ),
              Expanded(
                child: Text(
                  entry.title,
                  style: TextStyle(
                    fontFamily: 'DancingScript',
                    fontSize: 20,
                    color: Colors.grey.shade900,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
