//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // pop the loading circle
      //Navigator.pop(context);
      //Navigator.pushNamed(context, "/loginchecking");
    } on FirebaseAuthException catch(e){
      // pop the loading circle
      //Navigator.pop(context);
      print("Error signing in: $e");
      errorMessage(e);
    }
  }/*
  void signIn() async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,);
    //Navigator.pushNamed(context, "/loginchecking");
  }*/

  //error message popup
  void errorMessage(FirebaseAuthException e) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.deepPurple[600],
            title: Center(
                child: Text(
                    'Error: $e',
                    style: const TextStyle(color: Colors.white),
                ),
            ),
          );
        },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Sign in page'),backgroundColor: Colors.deepPurple[400]),
      backgroundColor: Colors.deepPurple[200],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock,
                  size: 100,
                  color: Colors.deepPurple,
                ),

                const SizedBox(height: 50),
            
                // Hello greetings
                Text(
                  'Greetings!',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 52,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Welcome back, you\'ve been missed!',
                  style: TextStyle(
                      fontSize: 20,
                  ),
                ),

                const SizedBox(height: 50),
            
                // Email Textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Email',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Pasword Textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Password',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Sign in Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: (){
                      /*showDialog(
                        context: context,
                        builder: (context) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );*/
                      signIn();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                            'Sign in',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                            ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Forgot password forn
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already a member? ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/forgotpasspage");
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,),
                          ),
                        )
                      ],
                    )
                  ),

                const SizedBox(height: 25),

                // Not a member? Register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                        'Not a member? ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/registerpage");
                      },
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
