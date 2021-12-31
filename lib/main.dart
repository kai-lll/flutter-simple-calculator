import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:flutter/material.dart';

import './widgets/CalcButton.dart';

void main() {
  runApp(CalcApp());
}

class CalcApp extends StatefulWidget {
  const CalcApp({Key key}) : super(key: key);

  @override
  CalcAppState createState() => CalcAppState();
}

class CalcAppState extends State<CalcApp> {
  final String _version = "v1.0.3";
  final ScrollController _controller = ScrollController();

  final colorDarkGreen = Color(0xFF283637);
  final colorGreen = Color(0xFF6C807F);
  final colorLightGreen = Color(0xFF65BDAC);
  final colorWhite = Color(0xFFFFFFFF);

  List<String> _history = [""];
  String _expression = '';
  bool get isFirst => _expression.isEmpty;

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  bool isNumeric(String str) {
    if(str == null) {
      return false;
    }
    try {
      return double.tryParse(str) != null;
    } catch (e) {
      return false;
    }
  }

  bool isAvailableOperator(String operator) {
    if (isNumeric(operator)) {
      return true;
    }
    if (operator == "-" || operator == "(" || operator == ")") {
      return true;
    }
    if (_expression.isNotEmpty) {
      String last = _expression[_expression.length-1];
      bool isNumericEnd = isNumeric(last);
      if (isNumericEnd) {
        return true;
      } else {
        if (last == ")")
          return true;
        return false;
      }
    }

    return false;
  }

  void voidClick(String text) {

  }

  void numClick(String text) {
    //print(text);
    if (text == "x")
      text = "*";

    if (isFirst) {
      if (isNumeric(text)) {
        _expression = "";
      }
    }

    if (isAvailableOperator(text) == false) {
      return;
    }

    setState(() => _expression += text);
  }

  void allClear(String text) {
    setState(() {
      _expression = '';
    });
  }

  void removeLast(String text) {
    if (_expression.length < 1) {
      return;
    }
    setState(() {
      _expression = _expression.substring(0, _expression.length-1);
    });
  }

  void evaluate(String text) {
    if (isFirst && text == "=") {
      return;
    }
    Parser p = Parser();
    Expression exp;
    try {
      exp = p.parse(_expression);
    } catch (e) {
      //print("error : $e");
      return;
    }
    ContextModel cm = ContextModel();

    setState(() {
      var result = exp.evaluate(EvaluationType.REAL, cm).toString();
      var newHistory = _expression + " = " + result;
      if (_history.last != newHistory) {
        _history.add(_expression + " = " + result);
      }
      _expression = exp.evaluate(EvaluationType.REAL, cm).toString();

      Future.delayed(Duration(milliseconds: 50)).then((value) => _scrollDown());
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kai CALC',
      home: Scaffold(
        backgroundColor: colorDarkGreen,
        body: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: ListView.builder(
                    controller: _controller,
                    shrinkWrap: true,
                    itemCount: _history.length,
                    itemBuilder: (BuildContext context,int index){
                      return GestureDetector(
                        onTap: () {
                          String exp = _history[index].split("=").first;
                          setState(() {
                            _expression = exp;
                          });
                        },
                        child: Text(formatedExpression(_history[index]),
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 30, color: colorLightGreen,)),
                      );
                    }
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    formatedExpression(_expression),
                    style: TextStyle(
                      fontSize: 48,
                      color: colorLightGreen,
                    ),
                  ),
                ),
                alignment: Alignment(1.0, 1.0),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CalcButton(
                    text: 'AC',
                    fillColor: colorGreen,
                    textSize: 20,
                    callback: allClear,
                  ),
                  CalcButton(
                    child: Icon(Icons.arrow_back, color: colorWhite),
                    fillColor: colorGreen,
                    textColor: colorLightGreen,
                    callback: removeLast,
                  ),
                  CalcButton(
                    text: '',
                    fillColor: colorWhite,
                    textColor: colorLightGreen,
                    callback: voidClick,
                  ),
                  CalcButton(
                    text: '',
                    fillColor: colorWhite,
                    textColor: colorLightGreen,
                    callback: voidClick,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CalcButton(
                    text: '(',
                    fillColor: colorGreen,
                    callback: numClick,
                  ),
                  CalcButton(
                    text: ')',
                    fillColor: colorGreen,
                    callback: numClick,
                  ),
                  CalcButton(
                    text: '%',
                    fillColor: colorWhite,
                    textColor: colorLightGreen,
                    callback: numClick,
                  ),
                  CalcButton(
                    text: '/',
                    fillColor: colorWhite,
                    textColor: colorLightGreen,
                    callback: numClick,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CalcButton(
                    text: '7',
                    callback: numClick,
                  ),
                  CalcButton(
                    text: '8',
                    callback: numClick,
                  ),
                  CalcButton(
                    text: '9',
                    callback: numClick,
                  ),
                  CalcButton(
                    text: 'x',
                    fillColor: colorWhite,
                    textColor: colorLightGreen,
                    textSize: 24,
                    callback: numClick,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CalcButton(
                    text: '4',
                    callback: numClick,
                  ),
                  CalcButton(
                    text: '5',
                    callback: numClick,
                  ),
                  CalcButton(
                    text: '6',
                    callback: numClick,
                  ),
                  CalcButton(
                    text: '-',
                    fillColor: colorWhite,
                    textColor: colorLightGreen,
                    textSize: 38,
                    callback: numClick,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CalcButton(
                    text: '1',
                    callback: numClick,
                  ),
                  CalcButton(
                    text: '2',
                    callback: numClick,
                  ),
                  CalcButton(
                    text: '3',
                    callback: numClick,
                  ),
                  CalcButton(
                    text: '+',
                    fillColor: colorWhite,
                    textColor: colorLightGreen,
                    textSize: 30,
                    callback: numClick,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CalcButton(
                    text: '.',
                    callback: numClick,
                  ),
                  CalcButton(
                    text: '0',
                    callback: numClick,
                  ),
                  CalcButton(
                    text: '00',
                    callback: numClick,
                    textSize: 25,
                  ),
                  CalcButton(
                    text: '=',
                    fillColor: colorWhite,
                    textColor: colorLightGreen,
                    callback: evaluate,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    _version,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatedExpression(String expression) {
    if (expression == '')
      return '';

    //print("raw : $expression");

    var lex = Lexer();
    final List<Token> inputStream = lex.tokenize(expression);

    var nf = NumberFormat("###,###.##########", "en_US");

    String resultText = "";
    for (Token currToken in inputStream) {

      switch (currToken.type) {
        case TokenType.VAL:
          resultText += nf.format(double.parse(currToken.text));
          //print(resultText);
          break;
        case TokenType.VAR:
          resultText += " = ";
          break;
        case TokenType.UNMINUS:
          resultText += "-";
          break;
        case TokenType.PLUS:
          resultText += "+";
          break;
        case TokenType.MINUS:
          resultText += "-";
          break;
        case TokenType.TIMES:
          resultText += "x";
          break;
        case TokenType.DIV:
          resultText += "/";
          break;
        case TokenType.MOD:
          resultText += "%";
          break;
        case TokenType.LBRACE:
          resultText += "(";
          break;
        case TokenType.RBRACE:
          resultText += ")";
          break;
        case TokenType.POW:
          break;
        case TokenType.EFUNC:
          break;
        case TokenType.LOG:
          break;
        case TokenType.LN:
          break;
        case TokenType.SQRT:
          break;
        case TokenType.ROOT:
          break;
        case TokenType.SIN:
          break;
        case TokenType.COS:
          break;
        case TokenType.TAN:
          break;
        case TokenType.ASIN:
          break;
        case TokenType.ACOS:
          break;
        case TokenType.ATAN:
          break;
        case TokenType.ABS:
          break;
        case TokenType.CEIL:
          break;
        case TokenType.FLOOR:
          break;
        case TokenType.SGN:
          break;
        default:
          throw FormatException('Unsupported token: $currToken');
      }

      //print("currToken : ${currToken.text} ${currToken.type}");
    }

    return resultText;
  }
}
