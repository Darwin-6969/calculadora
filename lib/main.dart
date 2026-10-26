import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const CalculadoraHome(),
    );
  }
}

class CalculadoraHome extends StatefulWidget {
  const CalculadoraHome({super.key});

  @override
  State<CalculadoraHome> createState() => _CalculadoraHomeState();
}

class _CalculadoraHomeState extends State<CalculadoraHome> {
  String _output = '0';
  String _currentInput = '';
  double _num1 = 0;
  double _num2 = 0;
  String _operand = '';
  bool _isResultDisplayed = false;

  // Manejo de botones presionados
  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _output = '0';
        _currentInput = '';
        _num1 = 0;
        _num2 = 0;
        _operand = '';
        _isResultDisplayed = false;
      } else if (buttonText == '⌫') {
        if (_currentInput.isNotEmpty) {
          _currentInput = _currentInput.substring(0, _currentInput.length - 1);
          _output = _currentInput.isEmpty ? '0' : _currentInput;
        }
      } else if (buttonText == '+' || buttonText == '-' || buttonText == '×' || buttonText == '÷') {
        if (_currentInput.isNotEmpty || _output != '0') {
          _num1 = double.tryParse(_currentInput.isNotEmpty ? _currentInput : _output) ?? 0;
          _operand = buttonText;
          _currentInput = '';
          _isResultDisplayed = false;
        }
      } else if (buttonText == '.') {
        if (_isResultDisplayed) {
          _currentInput = '0.';
          _isResultDisplayed = false;
        } else if (!_currentInput.contains('.')) {
          _currentInput = _currentInput.isEmpty ? '0.' : '$_currentInput.';
        }
        _output = _currentInput;
      } else if (buttonText == '=') {
        if (_operand.isNotEmpty && _currentInput.isNotEmpty) {
          _num2 = double.tryParse(_currentInput) ?? 0;
          
          double result = 0;
          switch (_operand) {
            case '+':
              result = _num1 + _num2;
              break;
            case '-':
              result = _num1 - _num2;
              break;
            case '×':
              result = _num1 * _num2;
              break;
            case '÷':
              if (_num2 == 0) {
                _output = 'Error';
                _currentInput = '';
                _operand = '';
                _isResultDisplayed = true;
                return;
              }
              result = _num1 / _num2;
              break;
          }

          // Formatear el resultado para quitar decimales innecesarios (.0)
          if (result == result.toInt()) {
            _output = result.toInt().toString();
          } else {
            _output = result.toString();
          }

          _currentInput = _output;
          _operand = '';
          _isResultDisplayed = true;
        }
      } else {
        // Números (0-9)
        if (_isResultDisplayed) {
          _currentInput = buttonText;
          _isResultDisplayed = false;
        } else {
          _currentInput = _currentInput == '0' ? buttonText : _currentInput + buttonText;
        }
        _output = _currentInput;
      }
    });
  }

  // Widget personalizado para cada botón
  Widget _buildButton(String text, {Color? textColor, Color? bgColor}) {
    // Determinar colores por defecto según el tipo de botón
    final isOperator = ['+', '-', '×', '÷', '='].contains(text);
    final isAction = ['C', '⌫'].contains(text);

    final defaultBgColor = isOperator
        ? Colors.deepOrange
        : isAction
            ? Colors.grey[850]
            : Colors.grey[900];

    final defaultTextColor = isOperator
        ? Colors.white
        : isAction
            ? Colors.deepOrangeAccent
            : Colors.white;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 22),
            backgroundColor: bgColor ?? defaultBgColor,
            foregroundColor: textColor ?? defaultTextColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
          ),
          onPressed: () => _buttonPressed(text),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora Flutter'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Pantalla / Display de resultados
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Muestra la operación actual o el estado intermedio opcionalmente
                  Text(
                    _operand.isNotEmpty ? '$_num1 $_operand' : '',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Pantalla principal de resultados
                  FittedBox(
                    alignment: Alignment.centerRight,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _output,
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: Colors.white12),
          // Teclado de la calculadora
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildButton('C'),
                    _buildButton('⌫'),
                    _buildButton('%', textColor: Colors.grey), // Opcional o placeholder
                    _buildButton('÷'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('×'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('-'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('+'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('0'),
                    _buildButton('.'),
                    _buildButton('='),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}