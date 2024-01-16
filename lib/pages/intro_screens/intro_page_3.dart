import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[100],
      child: Center(
          child:
          //Text('Intro Page 3')),
          //Lottie.network('https://lottie.host/b28a7bdd-400d-4676-8054-fb32c1620fcc/3dYhMEbpWw.json'),
          Lottie.asset('lib/materials/Animation-punchglove.json'),
      ),
    );
  }
}