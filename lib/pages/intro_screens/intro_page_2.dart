import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple[200],
      child: Center(
          child:
          //Text('Intro Page 2')),
          //Lottie.network('https://lottie.host/dfa59957-68b6-43dc-8389-6468319b847f/xv7bE2F0Lo.json'),
          Lottie.asset('lib/materials/Animation-girlphone.json'),
      ),
    );
  }
}