import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileBlock extends StatelessWidget {
  final User user;
  const ProfileBlock({
    super.key,
    required this.user
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          // Image(image: image),
          Text(user.email ?? ""),
        ],
      ),
    );
  }

}