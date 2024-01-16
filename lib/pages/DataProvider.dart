import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DataProvider extends ChangeNotifier {
  String _chatText = '';

  String get chatText => _chatText;

  void setChatText(String newText) {
    _chatText = newText;
    notifyListeners();
  }

  late Timer _timerIncrement;
  late Timer _timerDecrement;
  int _seconds_increment = 0;
  int get seconds_increment => _seconds_increment;
  int _seconds_decrement = 30;
  int get seconds_decrement => _seconds_decrement;

  DataProvider() {
    incrementTimer();
    decrementTimer();
  }

  void resetTimer() {
    _seconds_increment = 0;
    _seconds_decrement = 30;
    notifyListeners();
  }

  void incrementTimer() {
    _timerIncrement = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds_increment < 30) {
        _seconds_increment++;
        notifyListeners();
      }
    });
  }

  void decrementTimer() {
    _timerDecrement = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds_decrement > 0) {
        _seconds_decrement--;
        notifyListeners();
      }
    });
  }

  void cancelTimers() {
    _timerIncrement.cancel();
    _timerDecrement.cancel();
  }

  @override
  void dispose() {
    cancelTimers();
    super.dispose();
  }
}

