import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Flutter layout demo';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12.0),
                margin: EdgeInsets.only(bottom: 15.0),
                // color: Colors.green,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color.fromARGB(225, 98, 98, 0),
                ),
                child: Text(
                  'A  simple text',
                  style: TextStyle(color: Colors.white, fontSize: 35.0),
                ),
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  print('Button pressed');
                },
                label: const Text('Click me'),
                backgroundColor: Color.fromARGB(225, 246, 243, 242),
                foregroundColor: Color.fromARGB(225, 98, 98, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
