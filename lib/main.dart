import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String input = "";
  String result = "0";

  void onButtonClick(String value) {
    setState(() {
      if (value == "C") {
        input = "";
        result = "0";
      } else if (value == "=") {
        calculate();
      } else {
        input += value;
      }
    });
  }

  void calculate() {
    try {
      String finalInput = input.replaceAll('×', '*');
      finalInput = finalInput.replaceAll('÷', '/');

      Parser p = Parser();
      Expression exp = p.parse(finalInput);
      ContextModel cm = ContextModel();

      double eval = exp.evaluate(EvaluationType.REAL, cm);

      // remove .0 if integer
      if (eval % 1 == 0) {
        result = eval.toInt().toString();
      } else {
        result = eval.toString();
      }
    } catch (e) {
      result = "Error";
    }
  }

  Widget buildButton(String text, {Color? bgColor, Color? textColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor ?? Colors.grey[900],
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () => onButtonClick(text),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Column(
          children: [
            // INPUT
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    input.isEmpty ? "0" : input,
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
            ),

            // RESULT
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    result,
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // BUTTONS
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 12,
              ),
              child: Column(
                children: [
                  Row(children: [
                    buildButton("7"),
                    buildButton("8"),
                    buildButton("9"),
                    buildButton("÷",
                        bgColor: Colors.orange, textColor: Colors.black),
                  ]),
                  Row(children: [
                    buildButton("4"),
                    buildButton("5"),
                    buildButton("6"),
                    buildButton("×",
                        bgColor: Colors.orange, textColor: Colors.black),
                  ]),
                  Row(children: [
                    buildButton("1"),
                    buildButton("2"),
                    buildButton("3"),
                    buildButton("-",
                        bgColor: Colors.orange, textColor: Colors.black),
                  ]),
                  Row(children: [
                    buildButton("C",
                        bgColor: Colors.red, textColor: Colors.white),
                    buildButton("0"),
                    buildButton("=",
                        bgColor: Colors.orange, textColor: Colors.black),
                    buildButton("+",
                        bgColor: Colors.orange, textColor: Colors.black),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}