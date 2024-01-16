import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final _emailController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
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
              'msg: $e',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Future passwordReset() async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim());
      StringMessage("Password reset link sent! Check your email");
    } on FirebaseAuthException catch (e) {
      errorMessage(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[400],
        elevation: 0,
      ),
      backgroundColor: Colors.deepPurple[200],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.lock_reset,
            size: 50,
            color: Colors.deepPurple,
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text('Enter email for password reset link',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
            ),
          ),

          const SizedBox(height: 10,),

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

          const SizedBox(height: 10,),

          MaterialButton(
              onPressed: passwordReset,
              color: Colors.deepPurple,
              child: const Text('Reset Password',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                ),),
          ),
          
          const SizedBox(height: 20,),
          
          Row(
            children: [
              Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.deepPurple[400],
                  ),
              ),
              const Text('Reset Password Form'),
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: Colors.deepPurple[400],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
