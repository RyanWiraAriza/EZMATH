import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  // controller
  AnimationController? _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        duration: const Duration(seconds: 2),
        vsync: this,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller?.dispose();
  }

  bool liked = false;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("R E G I S T E R"),backgroundColor: Theme.of(context).colorScheme.inversePrimary,),
      body: Container(
        color: Colors.pink[100],
        child: Center(
          child:
          //Text('Intro Page 1'),
          GestureDetector(
            onTap: (){
              if(liked==false){
                liked = true;
                _controller?.forward();
                Navigator.pushNamed(context, "/hiddendrawer");
              }
              else{
                liked = false;
                _controller?.reverse();
              }
            },
            child:
            //Lottie.network('https://lottie.host/5e48afe3-9c07-46b6-9f54-5c37239c036f/k0jcvmzOft.json',
            Lottie.asset('lib/materials/Animation-heart.json',
                controller: _controller),
          ),
        ),
      ),
    );
  }
}

