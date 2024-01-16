import 'package:easymath/hidden_drawer.dart';
import 'package:easymath/pages/DataProvider.dart';
import 'package:easymath/pages/chat_page.dart';
import 'package:easymath/pages/forgotPass_page.dart';
import 'package:easymath/pages/home_page1.dart';
import 'package:easymath/pages/login_checking.dart';
import 'package:easymath/pages/login_page.dart';
import 'package:easymath/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'pages/level_page.dart';
import 'pages/scoreboard_page.dart';
import 'pages/intro_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//made async to continuously access our project and backend
void main() async {
  //access to native code
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DataProvider()),
      ],
      child: const MyApp(),
    ),
  );
  //runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const IntroPage(),
      routes: {
        '/intropage': (context) => const IntroPage(),
        '/registerpage': (context) => const RegisterPage(),
        '/loginpage': (context) => const LoginPage(),
        '/levelpage': (context) => const LevelPage(),
        '/homepage': (context) => const HomePage(),
        '/homepage1': (context) => const HomePage1(),
        '/chatpage': (context) => const ChatPage(),
        '/scoreboardpage': (context) => const ScoreboardPage(),
        '/hiddendrawer': (context) => const HiddenDrawer(),
        '/loginchecking': (context) => const LoginChecking(),
        '/forgotpasspage': (context) => const ForgotPasswordPage(),
      },
    );
  }
}
