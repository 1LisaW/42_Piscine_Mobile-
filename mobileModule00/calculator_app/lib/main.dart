import 'package:flutter/material.dart';
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
  int _position = 0;
  List<String> _output = [];
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

  void updateOutput(int idx, String value) {
    while (_output.length < idx + 1) {
      _output.add('');
    }
    _output[idx] = value;
  }

  void fillNumber(String ch) {
    String finaluserinput;
    if (_position == 1 || _position == 3) {
      setState(() {
        _input = '0';
      });
    }
    if (_position == 1 && _output[1] != '=') {
      setState(() {
        _position = 2;
      });
    }

    if (ch == '.' && _input.indexOf(ch) != -1)
      finaluserinput = _input;
    else if (_input == '0' && ch != '.')
      finaluserinput = ch[0];
    else
      finaluserinput = _input + ch;

    setState(() {
      _input = finaluserinput;
    });
  }

  void updateResult() {
    if (_position >= 0)
      setState(() {
        _result = _output.sublist(0, _position + 1).join(' ');
      });
    else
      setState(() {
        _result = '';
      });
  }

  void clearAll() {
    setState(() {
      _input = '0';
      _position = 0;
      _output.clear();
      _result = '';
    });
  }

  void clearInput() {
    setState(() {
      _input = '0';
      if (_position == 2) _position = 1;
    });
  }

  void updateInvalidInput() {
    try {
      double.parse(_input);
    } catch (e) {
      setState(() {
        _input = '0';
        _position = 0;
        _output.clear();
      });
    }
  }

  void fillOperator(String ch) {
    updateInvalidInput();
    if (ch == '=') {
      equalPressed();
      return;
    }
    if (_position == 2) {
      updateOutput(2, _input);
      calculateResult();
    }
    setState(() {
      updateOutput(0, _input);
      updateOutput(1, ch);
      _position = 1;
      updateResult();
    });
  }

  void calculateResult() {
    double result = 0;

    if (_output.length < 3) {
      try {
        double firstNumber = double.parse(_output[0]);
        result = firstNumber;
        setState(() {
          _input = result.toString();
        });
      } catch (e) {
        setState(() {
          _input = 'Error';
        });
      }
    } else {
      try {
        double firstNumber = double.parse(_output[0]);
        double secondNumber = double.parse(_output[2]);
        if (_output[1] == '+') {
          result = firstNumber + secondNumber;
        } else if (_output[1] == '-') {
          result = firstNumber - secondNumber;
        } else if (_output[1] == '*') {
          result = firstNumber * secondNumber;
        } else if (_output[1] == '/') {
          result = firstNumber / secondNumber;
        }
        setState(() {
          _input = result.toString();
        });
      } catch (e) {
        setState(() {
          _input = 'Error';
        });
      }
    }
    updateResult();
  }

  void equalPressed() {
    if (_output.length <= 1) {
      updateOutput(0, _input);
      updateOutput(1, '=');
    } else if (_position != 3 && _output[1] != '=') {
      updateOutput(2, _input);
      updateOutput(3, '=');
    } else {
      updateOutput(0, _input);
    }
    _position = _output.indexOf('=');
    calculateResult();
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
