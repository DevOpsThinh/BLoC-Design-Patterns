///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 19/ 7/ 2021
///------------------------------------------------------------------

///----------------------------------------------------------------///
///                    Import Library                             ///
///--------------------------------------------------------------///
import 'dart:math';

import 'package:flutter/material.dart';

/// Class's document:
/// FancyButton is a Stateful Widget
class FancyButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const FancyButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  _FancyButtonState createState() => _FancyButtonState();
}

class _FancyButtonState extends State<FancyButton> {
  /// Manges color for all fancy buttons
  Color _getColors() {
    return _buttonColors.putIfAbsent(this, () => colors[next(0, 5)]);
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle colorStyle = new ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(_getColors()));

    return Container(
      child: ElevatedButton(
        style: colorStyle,
        child: widget.child,
        onPressed: widget.onPressed,
      ),
    );
  }
}

///----------------------------------------------------------------///
///                    Helper methods                             ///
///--------------------------------------------------------------///

final _random = new Random();
int next(int min, int max) => min + _random.nextInt(max - min);

var colors = [
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.amber,
  Colors.lightBlue
];
var _buttonColors = <_FancyButtonState, Color>{};
