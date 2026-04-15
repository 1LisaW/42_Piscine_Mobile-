
import 'package:diary_app/features/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile_Info extends StatelessWidget {
  const Profile_Info({this.user});
  final User? user;
  static const IconData logout = IconData(0xe3b3, fontFamily: 'MaterialIcons');

  @override
  Widget build(BuildContext context) {
    Future<void> _signOut() async {
      await FirebaseAuth.instance.signOut();
    }
    return (
      Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleAvatar(
          backgroundColor: const Color.fromARGB(255, 30, 94, 44),
          foregroundColor: Colors.white,
          radius: 40,
          child: const Text('AH', style: TextStyle(fontSize: 28),),
        ),
        Text(user?.email ?? '', style: TextStyle(fontSize: 20)),
        ElevatedButton(
                          onPressed: () {
                            _signOut();
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const LoginScreen())
                            );
                          },
                          child:  Icon(logout),
                        ),
        // Icon(logout)
      ],
    ),
      ));
  }
}
