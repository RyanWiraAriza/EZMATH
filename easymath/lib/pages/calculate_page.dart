import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easymath/pages/progressbar.dart';
import 'package:easymath/pages/scoreboard_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
//import 'package:provider/provider.dart';

import '../const.dart';
import '../util/my_button.dart';
import '../util/result_message.dart';
//import 'DataProvider.dart';

class CalculatePage extends StatefulWidget {
  const CalculatePage({super.key});

  @override
  State<CalculatePage> createState() => _CalculatePageState();
}

class _CalculatePageState extends State<CalculatePage> {

  // number pad list
  List<String> numberPad = [
    '7',
    '8',
    '9',
    'C',
    '4',
    '5',
    '6',
    'DEL',
    '1',
    '2',
    '3',
    '=',
    '0',
    '-',
    'NaN',
    'PLAY',
  ];

  // create random numbers
  var randomNumber = Random();

  // number A, number B
  int numberA = 1;
  int numberB = 1;
  String operator = "+";
  int operatorIndex = 0;
  List<String> operators = ['+','-','/','%','*'];
  String level1_question = '';

  // user answer
  String userAnswer = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool allowPlay=false;
  int highScore=0;
  int currentScore=0;
  String currentEmail='';

  late Timer _timerDecrement;
  double seconds_decrement = 0;

  void decrementTimer(double decrement_second_amount){
    _timerDecrement = Timer.periodic(
      const Duration(seconds: 1),
          (timer) async {
        if(allowPlay==false){return;}
        if(_timerDecrement.tick==1) {
          //print("Timer callback start");
          // Wrap the logic in Future.delayed to run it on the main thread
          await Future.delayed(Duration.zero, () {
            if (mounted) {
              setState(() {
                if (seconds_decrement <= 0) {
                  // do something once countdown is 0
                  _timerDecrement.cancel();
                } else {
                  seconds_decrement =
                      seconds_decrement - decrement_second_amount;
                  if(seconds_decrement.isNegative)
                  {
                    // so no negative width from width*progress
                    seconds_decrement = 0.0;
                  }
                  seconds_decrement =
                      double.parse(seconds_decrement.toString());
                  print(seconds_decrement);
                }
              });
            }
          });
        }
            //print("Timer callback end");
      },
    );
  }





  // user tapped a button
  void buttonTapped(String button) {
    setState(() {
      if (button == '=') {
        // calculate if user is correct or incorrect
        checkResult();
      } else if (button == 'C') {
        // clear the input
        userAnswer = '';
      } else if (button == 'DEL') {
        // delete the last number
        if (userAnswer.isNotEmpty) {
          userAnswer = userAnswer.substring(0, userAnswer.length - 1);
        }
      } else if (button == 'PLAY') {
          setState(() {
            //_timerDecrement.cancel();
            allowPlay=true;
            seconds_decrement=1;
          });
      } else if (userAnswer.length < 3) {
        // maximum of 3 numbers can be inputted
        userAnswer += button;
      }
    });
  }

  void DiagMenu() {
    showDialog(
        context: context,
        builder: (context) {
          return ResultMessage(
            message: 'TIMES UP',
            onTap: (){
            },
            icon: Icons.arrow_forward,
          );
        });
  }

  void DiagCorrect() {
    showDialog(
        context: context,
        builder: (context) {
          return ResultMessage(
            message: 'Correct!',
            onTap: goToNextQuestion,
            icon: Icons.arrow_forward,
          );
        });
  }

  void DiagIncorrect() {
    showDialog(
        context: context,
        builder: (context) {
          return ResultMessage(
            message: 'Sorry try again',
            onTap: goBackToQuestion,
            icon: Icons.rotate_left,
          );
        });
  }

  // check if user is correct or not
  void checkResult() {
    Parser p = Parser();
    print('question: '+level1_question);
    Expression exp = p.parse(level1_question);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    print('eval: '+eval.toString());
    int eval_int = 0;
    if(eval.isInfinite || eval.isNaN) {
      if(userAnswer == 'NaN') {
        goToNextQuestion();
      } else {
        DiagIncorrect();
      }
    } else {
      eval_int = eval.toInt();
      print('ans: '+userAnswer);
      print('eval: '+eval_int.toString());
      if (userAnswer == eval_int.toString()) {
        if(seconds_decrement>0) {
          currentScore += 3;
          print(currentScore);
        }
        goToNextQuestion();
        //DiagCorrect();
      } else {
        DiagIncorrect();
      }
    }
  }

  // GO TO NEXT QUESTION
  void goToNextQuestion() {
    // dismiss alert dialog
    //Navigator.of(context).pop();

    // reset values
    setState(() {
      userAnswer = '';
    });

    // create a new question
    numberA = randomNumber.nextInt(10);
    numberB = randomNumber.nextInt(10);
    operatorIndex = randomNumber.nextInt(operators.length);
  }

  // GO BACK TO QUESTION
  void goBackToQuestion() {
    // dismiss alert dialog
    Navigator.of(context).pop();
    // reset values
    setState(() {
      userAnswer = '';
    });
  }

  Text questionGenerator() {
    if(seconds_decrement<=0) {
      setState(() {
        allowPlay=false;
        keju();
        if(highScore<currentScore){
          highScore=currentScore;
          print('New HighScore: $highScore');
          // update new score
          updateHighScoreInFirestore(currentEmail, highScore);
        }
        // reset current score once uploaded
        currentScore=0;
      });

    }
    level1_question = '$numberA${operators[operatorIndex]}$numberB';
    return Text(
      level1_question+' = ',
      style: whiteTextStyle,
    );
  }

  Future keju() async {
    await getScoreForEmail(currentEmail).then((int? score) {
      if (score != null) {
        highScore=score;
        print('HighScore: $score');
        // Do something with the score
      } else {
        print('Email not found');
      }
    });
  }

  Future<String?> getDocIdForEmail(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      return null; // Email not found
    }
  }


  Future<int?> getScoreForEmail(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.get('score');
    } else {
      return null; // Email not found
    }
  }

  Future<void> updateHighScoreInFirestore(String email, int newHighScore) async {
    try {
      // Get the docID for the user's email
      String? docID = await getDocIdForEmail(email);

      if (docID != null) {
        // Update the 'score' field in the document using the retrieved docID
        DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(docID);

        await userDocRef.update({'score': newHighScore});

        print('High score updated in Firestore: $newHighScore');
      } else {
        print('Email not found');
      }
    } catch (e) {
      print('Error updating high score in Firestore: $e');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Listen to the authentication state changes
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        // User is signed in, show the connected message
        currentEmail = user.email.toString();
        keju();
      }
    });
    //resetTimer(0);
    //context.watch<DataProvider>().TimerProvider();
  }

  @override
  void dispose() {
    //timerProvider.cancelTimers();
     /* if(mounted) {
        timerProvider.resetTimer();
      }*/
    //resetTimer(0);
    //_timerDecrement.cancel();
    _timerDecrement.cancel();
        super.dispose();
  }

  //DataProvider timerProvider=DataProvider();
  @override
  Widget build(BuildContext context) {
    //timerProvider = Provider.of<DataProvider>(context);
    decrementTimer(0.1);
    return Scaffold(
      backgroundColor: Colors.deepPurple[300],
      appBar: AppBar(
        //leading: const Icon(Icons.list),
        /*actions: [const Text(
           "MSG",
            style: TextStyle(color: Colors.white, fontSize: 15),
          )],*/
        title: const Text("E Z M A T H (level 1)"),
        centerTitle: true,
        titleTextStyle: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,),
      body: Column(
        children: [
          // level progress, player needs 5 correct answers in a row to proceed to next level
          /*Container(
            height: 30,
            color: Colors.grey[200],
            /*child: Text(
                'Timer Value: ${timerProvider.seconds_increment} seconds\n'
                + 'Timer Value: ${timerProvider.seconds_decrement} seconds')*/
          ),*/
          (seconds_decrement>0)
          ?
          Align(
            alignment: Alignment.center,
            child: CustomProgressBar(
                width: 400,
                height: 20,
                progress: seconds_decrement),
          )
          :
          SizedBox(width: 1,),
          // question
          Expanded(
            child: Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // question
                    questionGenerator(),
                    // answer box
                    Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[400],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          userAnswer,
                          style: whiteTextStyle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          // number pad
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: GridView.builder(
                itemCount: numberPad.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemBuilder: (context, index) {
                  return MyButton(
                    child: numberPad[index],
                    onTap: () {
                      buttonTapped(numberPad[index]);
                      },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
