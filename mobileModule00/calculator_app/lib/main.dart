import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
// import 'package:math_expressions/math_expressions.dart';

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ColorScheme(),
      title: 'Flutter App!!',
      theme: ThemeData(
        // colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        colorScheme: colorScheme,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        // colorSchemeSeed: Colors.blue,
        useMaterial3: true,
        colorScheme: colorScheme,
        brightness: Brightness.light,
        // brightness: Brightness.dark,
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
  bool _justEvaluated = false;

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
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
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
                        controller: TextEditingController(text: _result),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
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
                    var _buttontapped = null;
                    if (['AC', 'C'].indexOf(buttons[index]) >= 0) {
                      _textColor = Theme.of(context).colorScheme.error;
                      _buttontapped =
                          buttons[index] == 'AC' ? clearInput : clearAll;
                    } else if (['+', '-', '/', '*', '=']
                            .indexOf(buttons[index]) >=
                        0) {
                      _textColor = Theme.of(context).colorScheme.onPrimary;
                      _buttontapped = () => fillOperator(buttons[index]);
                    } else
                      _buttontapped = () => fillNumber(buttons[index]);
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

  bool isOperator(String s) {
    if (s == '/' || s == '*' || s == '+' || s == '-' || s == '=') return true;
    return false;
  }

  void fillNumber(String ch) {
    setState(() {
      if (_justEvaluated) {
        _input = '0';
        _result = '';
        _justEvaluated = false;
      }

      if (_input == '0' && ch != '.') {
        _input = ch;
      } else {
        _input += ch;
      }
    });
  }

  void clearAll() {
    setState(() {
      _input = '0';
      _result = '0';
    });
  }

  void clearInput() {
    setState(() {
      _input = '0';
    });
  }

  void fillOperator(String ch) {
    if (ch == '=') {
      equalPressed();
      return;
    }

    setState(() {
      if (_justEvaluated) {
        _result = '';
        _justEvaluated = false;
      }

      if (_input.isNotEmpty &&
          ['+', '-', '*', '/'].contains(_input[_input.length - 1])) {
        _input = _input.substring(0, _input.length - 1) + ch;
      } else {
        _input += ch;
      }
    });
  }
  
  void equalPressed() {
    try {
      String expression = _input;

      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();

      double eval = exp.evaluate(EvaluationType.REAL, cm);

      setState(() {
        _result = expression;
        _input = eval.toString();
        _justEvaluated = true;
      });
    } catch (e) {
      setState(() {
        _input = 'Error';
        _justEvaluated = true;
      });
    }
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
