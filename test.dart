import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Calculator());
  }
}

class Calculator extends StatefulWidget {
  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String expression = "";

  void add(String value) {
    setState(() {
      if (expression.isNotEmpty &&
          "+-*/".contains(expression[expression.length - 1]) &&
          "+-*/".contains(value)) {
        expression = expression.substring(0, expression.length - 1);
      }
      expression += value;
    });
  }

  void clear() => setState(() => expression = "");

  void evaluate() {
    if (expression.isEmpty) return;
    String exp = expression;
    // remove trailing operators or decimal
    while (exp.isNotEmpty && "+-*/.".contains(exp[exp.length - 1])) {
      exp = exp.substring(0, exp.length - 1);
    }
    if (exp.isEmpty) return;

    try {
      Parser p = Parser();
      Expression parsedExp = p.parse(exp);
      ContextModel cm = ContextModel();
      double result = parsedExp.evaluate(EvaluationType.REAL, cm);
      setState(() => expression = result.toString());
    } catch (e) {
      setState(() => expression = "Error");
    }
  }

  Widget button(String text,
      {Color bgColor = const Color(0xFFF5F5DC), Color fgColor = Colors.blue}) {
    if (text == "C") {
      bgColor = Colors.red;
      fgColor = Colors.white;
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: () {
            if (text == "C") clear();
            else if (text == "=") evaluate();
            else add(text);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: fgColor,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(24),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24),
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
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                expression,
                style: const TextStyle(color: Colors.white, fontSize: 36),
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                Row(children: [button("7"), button("8"), button("9"), button("/")]),
                Row(children: [button("4"), button("5"), button("6"), button("*")]),
                Row(children: [button("1"), button("2"), button("3"), button("-")]),
                Row(children: [button("0"), button("."), button("="), button("+")]),
                Row(children: [button("C")]),
              ],
            )
          ],
        ),
      ),
    );
  }
}