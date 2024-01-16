import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink[100],
      child: Center(
        child:
          //Text('Intro Page 1'),
          //Lottie.network('https://lottie.host/63faf248-4207-4df7-967d-71d3ec9fe523/ynVGZqBtBZ.json'),
          Lottie.asset('lib/materials/Animation-teacher.json'),
      ),
    );
  }
}
