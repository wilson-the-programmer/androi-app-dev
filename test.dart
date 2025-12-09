import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Calculator(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String expression = "";

  void addToExpression(String value) {
    setState(() {
      expression += value;
    });
  }

  void clearExpression() {
    setState(() {
      expression = "";
    });
  }

  void calculateResult() {
    try {
      // Using the 'expression_language' package is more robust, but for simplicity:
      final result = double.parse(expression);
      setState(() {
        expression = result.toString();
      });
    } catch (e) {
      try {
        final result = _evaluate(expression);
        setState(() {
          expression = result.toString();
        });
      } catch (_) {
        setState(() {
          expression = "Error";
        });
      }
    }
  }

  double _evaluate(String expr) {
    // Simple evaluator supporting +, -, *, /
    List<String> tokens = expr.split(RegExp(r'([+\-*/])')).map((e) => e.trim()).toList();
    double result = double.parse(tokens[0]);
    for (int i = 1; i < tokens.length; i += 2) {
      String op = tokens[i];
      double num = double.parse(tokens[i + 1]);
      if (op == '+') result += num;
      if (op == '-') result -= num;
      if (op == '*') result *= num;
      if (op == '/') result /= num;
    }
    return result;
  }

  Widget buildButton(String text, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[200],
            padding: const EdgeInsets.all(24),
          ),
          onPressed: () {
            if (text == "C") clearExpression();
            else if (text == "=") calculateResult();
            else addToExpression(text);
          },
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Simple Calculator")),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.bottomRight,
              child: Text(
                expression,
                style: const TextStyle(fontSize: 36),
              ),
            ),
          ),
          Row(
            children: [
              buildButton("7"), buildButton("8"), buildButton("9"), buildButton("/"),
            ],
          ),
          Row(
            children: [
              buildButton("4"), buildButton("5"), buildButton("6"), buildButton("*"),
            ],
          ),
          Row(
            children: [
              buildButton("1"), buildButton("2"), buildButton("3"), buildButton("-"),
            ],
          ),
          Row(
            children: [
              buildButton("0"), buildButton("."), buildButton("="), buildButton("+"),
            ],
          ),
          Row(
            children: [
              buildButton("C", color: Colors.redAccent),
            ],
          ),
        ],
      ),
    );
  }
}