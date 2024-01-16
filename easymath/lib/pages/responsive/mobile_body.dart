import 'package:easymath/pages/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../util/result_message.dart';
import '../DataProvider.dart';


class MyMobileBody extends StatefulWidget {
  const MyMobileBody({super.key});

  @override
  State<MyMobileBody> createState() => _MyMobileBodyState();
}

class _MyMobileBodyState extends State<MyMobileBody> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int selectedLevel = 1; // Default selected level is 1
  List<LottieBuilder> levelImg = [];
  // firestore custom made
  //final FirestoreService firestoreService = FirestoreService();

  void signUserOut() {
      FirebaseAuth.instance.signOut();
  }

  void openLevelBox(int index) {

    showDialog(
        context: context,
        builder: (context) {
          return ResultMessage(
            message: 'Start this level?',
            onTap: () {

              switch(index){
                case 0:
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/homepage");
                  break;
                case 1:
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/homepage1");
                  break;
                case 2:
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/homepage");
                  break;
              }
            },
            icon: Icons.play_arrow,
          );
        }
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Listen to the authentication state changes
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        // User is signed in, show the connected message
        String email = user.email.toString();
        ConnectedMessage(email);
      }
    });
    /*
    final currentUser = _auth.currentUser;
    if(currentUser != null) {
      String _email = currentUser.email.toString();
      ConnectedMessage(_email);
    }*/
    levelImg = [
      Lottie.network('https://lottie.host/63faf248-4207-4df7-967d-71d3ec9fe523/ynVGZqBtBZ.json'),
      Lottie.network('https://lottie.host/dfa59957-68b6-43dc-8389-6468319b847f/xv7bE2F0Lo.json'),
      Lottie.network('https://lottie.host/b28a7bdd-400d-4676-8054-fb32c1620fcc/3dYhMEbpWw.json'),
    ];
  }

  void ConnectedMessage(String connectedEmail) {
    if(mounted){
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.deepPurple[600],
            title: Center(
              child: Text(
                '$connectedEmail Connected Successfully..',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      appBar: AppBar(
        leading: const SizedBox(width: 5),
        actions:[
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          ),

        ],
        title: const Text('L E V E L S'),
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // video screen
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                height: 250,
                color: Colors.deepPurple[400],
                child: Center(
                  child: selectedLevel == 1
                      ? Lottie.asset('lib/materials/Animation-teacher.json')
                      : selectedLevel == 2
                      ? Lottie.asset('lib/materials/Animation-girlphone.json')
                      : selectedLevel == 3
                      ? Lottie.asset('lib/materials/Animation-punchglove.json')
                      : const Text(
                    'Invalid level',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // comment sections form screen
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      selectedLevel = index + 1;
                    });
                    openLevelBox(index);

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.deepPurple[300],
                      height: 100,
                      child: Center(
                        child: Text(
                          'Level ${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )

        ],
      ),
    );
  }
}
