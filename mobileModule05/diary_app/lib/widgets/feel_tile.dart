import 'package:diary_app/constants/diary_ui_constants.dart';
import 'package:flutter/material.dart';

class FeelTile extends StatelessWidget {
  const FeelTile({super.key, required this.moodIndex, required this.percent});

  final int moodIndex;
  final int percent;

  @override
  Widget build(BuildContext context) {
    final mood = kMoodEmojis[moodIndex.clamp(0, kMoodEmojis.length - 1)];
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(mood, style: const TextStyle(fontSize: 25)),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 1,
            height: 32,
            color: Colors.grey.shade400,
          ),
          Expanded(
            child: Text(
              '$percent %',
              style: TextStyle(
                fontFamily: 'DancingScript',
                fontSize: 18,
                color: Colors.grey.shade900,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
