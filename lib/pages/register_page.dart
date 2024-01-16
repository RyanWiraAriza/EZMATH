import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../hidden_drawer.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();

  Future signUp() async {
    // try creating the user
    try {
      // check if confirm password matches password register
      if(passwordConfirmed()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        StringMessage("${_emailController.text.trim()} Registered Successfully..");

        // firebase add user details
        await addUserDetails(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            0);

        _emailController.text = "";
        _passwordController.text = "";
        _confirmpasswordController.text = "";
        return const HiddenDrawer();
      } else {
        StringMessage("Passwords don't match");
      }
      // pop the loading circle
      //Navigator.pop(context);
    } on FirebaseAuthException catch(e){
      // pop the loading circle
      //Navigator.pop(context);
      errorMessage(e);
    }
  }

  Future addUserDetails(String email, String password, int score) async {
    try{
      await FirebaseFirestore.instance.collection('users').add({
        'email': email,
        'password': password,
        'score': score,
      });
    } catch (e) {
      StringMessage(e.toString());
    }

  }

  bool passwordConfirmed() {
    if(_passwordController.text.trim() ==
       _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

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

  //message popup
  void StringMessage(String e) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple[600],
          title: Center(
            child: Text(
              e.toString(),
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
      appBar: AppBar(title: const Text('Sign in page'),backgroundColor: Colors.deepPurple[400]),
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

                const SizedBox(height: 25),

                // Hello greetings
                Text(
                  'Hello Again!',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 52,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Let\'s create an account for you!',
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

                const SizedBox(height: 10),

                // Confirm Pasword Textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    obscureText: true,
                    controller: _confirmpasswordController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Confirm Password',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Sign up Button
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
                      signUp();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Sign up',
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

                // Not a member? Register now
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already registered? ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/loginpage");
                      },
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
