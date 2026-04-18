import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ); // MaterialApp
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  int idx = 0;
  final List<String> texts = ["A  simple text", "Hello World"];

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Flutter layout demo';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        body:  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12.0),
                margin: EdgeInsets.only(bottom: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color.fromARGB(225, 98, 98, 0)

                  ),
                child: Text(texts[idx], style: TextStyle(color: Colors.white, fontSize: 35.0),),
              ),
          FloatingActionButton.extended(
            onPressed: () => setState(() { idx = (idx + 1) % 2; }),
            label: const Text('Click me'),
              backgroundColor: Color.fromARGB(225, 246, 243, 242),
              foregroundColor: Color.fromARGB(225, 98, 98, 0),
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            ),
          ],)
        ),
      ),
    );
    }

}
