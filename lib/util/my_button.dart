import 'dart:async';

import 'package:flutter/material.dart';
import '../const.dart';

class MyButton extends StatefulWidget {
  final String child;
  final VoidCallback onTap;

  MyButton({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  var buttonColor = Colors.deepPurple[400];

  @override
  void initState() {
    super.initState();
    startPlayButtonTimer();
    // ... (other initialization logic)
  }

  late Timer playButtonTimer;
  bool isPlayButtonVisible = true;

  void startPlayButtonTimer() {
    playButtonTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      //if(playButtonTimer.tick==1) {
      if (mounted) {
        setState(() {
          isPlayButtonVisible = !isPlayButtonVisible;
          //print(isPlayButtonVisible.toString());
        });
      }
      //}
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child == 'C') {
      buttonColor = Colors.green;
    } else if (widget.child == 'DEL') {
      buttonColor = Colors.red;
    } else if (widget.child == '=') {
      buttonColor = Colors.deepPurple;
    } else if (widget.child == 'PLAY') {
      return AnimatedOpacity(
        opacity: (isPlayButtonVisible) ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  'PLAY',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      );
    }
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                widget.child,
                style: whiteTextStyle,
              ),
            ),
          ),
        ),
      );
    }
  }


