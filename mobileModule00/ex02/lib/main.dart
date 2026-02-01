import 'package:flutter/material.dart';

final ColorScheme colorScheme = ColorScheme(
  primary: Color.fromARGB(255, 96, 125, 139),
  secondary: Color.fromARGB(255, 43, 56, 63),
  surface: Colors.white,
  background: Colors.grey.shade200,
  error: Color.fromARGB(255, 174, 36, 37),
  onPrimary: Color.fromARGB(255, 242, 244, 245),
  onSecondary: Colors.black,
  onSurface: Colors.black,
  onBackground: Colors.black,
  onError: Colors.white,
  brightness: Brightness.light,
  // More colors
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(title: 'Calculator'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _input = '0';
  var _result = '0';

  final List<String> buttons = [
    '7',
    '8',
    '9',
    'C',
    'AC',
    '4',
    '5',
    '6',
    '+',
    '-',
    '1',
    '2',
    '3',
    '*',
    '/',
    '0',
    '.',
    '00',
    '=',
  ];

  void _onPushButton(String char) {
    print("button pressed :" + char);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.secondary,
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.only(right: 10, top: 10, bottom: 0),
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(border: InputBorder.none),
                        controller: TextEditingController(text: _input),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      color: Theme.of(context).colorScheme.secondary,
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.only(right: 10, top: 10, bottom: 0),
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(border: InputBorder.none),
                        controller: TextEditingController(text: _result),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 25,
                        ),
                      ),
                    ))
                  ],
                )),
            Expanded(
              flex: 3,
              child: Container(
                color: Theme.of(context).colorScheme.primary,
                child: GridView.builder(
                  itemCount: buttons.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5, mainAxisExtent: MediaQuery.of(context).size.height * 0.125),
                  itemBuilder: (BuildContext context, int index) {
                    var _textColor = Theme.of(context).colorScheme.secondary;
                    var _buttontapped = () => _onPushButton(buttons[index]);
                    if (['AC', 'C'].indexOf(buttons[index]) >= 0)
                      _textColor = Theme.of(context).colorScheme.error;
                    else if (['+', '-', '/', '*', '=']
                            .indexOf(buttons[index]) >=
                        0) _textColor = Theme.of(context).colorScheme.onPrimary;
                    return MyButton(
                        buttontapped: _buttontapped,
                        buttonText: buttons[index],
                        color: Theme.of(context).colorScheme.primary,
                        textColor: _textColor);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final color;
  final textColor;
  final String buttonText;
  final buttontapped;

  MyButton(
      {this.color,
      this.textColor,
      required this.buttonText,
      this.buttontapped});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttontapped,
      child: Padding(
          padding: const EdgeInsets.all(0.2),
          child: ClipRect(
              child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromARGB(255, 43, 56, 63),
                width: 0.1,
              ),
            ),
            child: Center(
              child: Text(buttonText,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ))),
    );
  }
}
