import 'package:flutter/material.dart';

class CalcButton extends StatelessWidget {
  final Widget child;
  final String text;
  final Color fillColor;
  final Color textColor;
  final double textSize;
  final Function callback;

  const CalcButton({
    Key key,
    this.child,
    this.text,
    this.fillColor,
    this.textColor = const Color(0xFFFFFFFF),
    this.textSize = 28,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      child: SizedBox(
        height: 65,
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          onPressed: () {
            callback(text);
          },
          child: child == null? Text(
            text,
            style: TextStyle(
              fontSize: textSize,
            ),
          ) : child,
          color: fillColor != null ? fillColor : null,
          textColor: textColor,
        ),
      ),
    );
  }
}
