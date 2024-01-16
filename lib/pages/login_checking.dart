import 'package:easymath/hidden_drawer.dart';
import 'package:easymath/pages/level_page.dart';
import 'package:easymath/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginChecking extends StatelessWidget {
  const LoginChecking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),//FirebaseAuth.instance.userChanges()
        builder: (context, snapshot) {
          if(snapshot.hasData){
            print('hidddeeeennnn');
            return const LevelPage();
          } else {
            print('loginnnnnn');
            return const LoginPage();
          }
        },
      ),
    );
  }
}
