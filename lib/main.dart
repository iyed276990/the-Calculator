import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'آلة حاسبة',
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _expression = "";

  // دالة الضغط على الأزرار
  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "AC") {
        _output = "0";
        _expression = "";
      } else if (buttonText == "⌫") {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
        if (_expression.isEmpty) {
          _output = "0";
        } else {
          _output = _expression;
        }
      } else if (buttonText == "=") {
        try {
          String finalExpression = _expression
              .replaceAll('×', '*')
              .replaceAll('÷', '/')
              .replaceAll('%', '/100');
          
          // حساب بسيط للنتيجة
          _output = _evalExpression(finalExpression);
          _expression = _output;
        } catch (e) {
          _output = "خطأ";
        }
      } else {
        if (_output == "0" && buttonText != ".") {
          _expression = buttonText;
        } else {
          _expression += buttonText;
        }
        _output = _expression;
      }
    });
  }

  // دالة حساب العمليات الرياضية الأساسية
  String _evalExpression(String exp) {
    try {
      // تنفيذ العمليات باستخدام لغة دارت البسيطة
      Parser p = Parser();
      // استبدال مبسط للعمليات
      double result = double.parse(exp); // سيتم حسابها مباشرة
      return result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 2);
    } catch (e) {
      // طريقة بديلة آمنة للحساب
      return _calculateSimple(exp);
    }
  }

  String _calculateSimple(String exp) {
    // حساب مبسط للعمليات الأربع والنسبة المئوية
    try {
      // إرجاع النتيجة كـ String
      return evalString(exp).toString();
    } catch (e) {
      return "خطأ";
    }
  }

  double evalString(String expression) {
    // حساب بديلة آمنة
    expression = expression.replaceAll(' ', '');
    if (expression.contains('+')) {
      List<String> parts = expression.split('+');
      return double.parse(parts[0]) + double.parse(parts[1]);
    } else if (expression.contains('-')) {
      List<String> parts = expression.split('-');
      return double.parse(parts[0]) - double.parse(parts[1]);
    } else if (expression.contains('*')) {
      List<String> parts = expression.split('*');
      return double.parse(parts[0]) * double.parse(parts[1]);
    } else if (expression.contains('/')) {
      List<String> parts = expression.split('/');
      return double.parse(parts[0]) / double.parse(parts[1]);
    }
    return double.parse(expression);
  }

  // تصميم زر الآلة الحاسبة
  Widget _buildButton(String buttonText, {Color color = const Color(0xFFF2F2F2), Color textColor = const Color(0xFF1A1A1A)}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: textColor,
            padding: const EdgeInsets.symmetric(vertical: 22.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.0),
            ),
            elevation: 0,
          ),
          onPressed: () {
            if (buttonText == "Exit") {
              Navigator.of(context).pop();
            } else {
              _buttonPressed(buttonText);
            }
          },
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // زر الخروج Exit في أعلى اليمين
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE0E0E0),
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                onPressed: () {
                  // إغلاق التطبيق
                },
                child: const Text("Exit", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            
            // شاشة عرض الأرقام
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                child: Text(
                  _output,
                  style: const TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF202020),
                  ),
                  maxLines: 1,
                ),
              ),
            ),

            // أزرار الآلة الحاسبة
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFFE9E9E9),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Row(children: [
                    _buildButton("AC"),
                    _buildButton("%"),
                    _buildButton("⌫"),
                    _buildButton("÷"),
                  ]),
                  Row(children: [
                    _buildButton("7"),
                    _buildButton("8"),
                    _buildButton("9"),
                    _buildButton("×"),
                  ]),
                  Row(children: [
                    _buildButton("4"),
                    _buildButton("5"),
                    _buildButton("6"),
                    _buildButton("-"),
                  ]),
                  Row(children: [
                    _buildButton("1"),
                    _buildButton("2"),
                    _buildButton("3"),
                    _buildButton("+"),
                  ]),
                  Row(children: [
                    _buildButton("00"),
                    _buildButton("0"),
                    _buildButton(","),
                    _buildButton("=", color: const Color(0xFFFF7300), textColor: Colors.white),
                  ]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
