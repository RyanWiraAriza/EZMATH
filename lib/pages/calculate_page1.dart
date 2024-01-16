import 'dart:async';
import 'dart:math';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
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

class CalculatePage1 extends StatefulWidget {
  const CalculatePage1({super.key});

  @override
  State<CalculatePage1> createState() => _CalculatePage1State();
}

class Query{
  String user='';
  String text='';

}

class _CalculatePage1State extends State<CalculatePage1> {

  final _openAI = OpenAI.instance.build(
    token: OPENAI_API_KEY,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(
        seconds: 5,
      ),
    ),
    enableLog: true,
  );



  final List<String> _messages = <String>[];

  Future<String> getQuestionResponse(String system,String user) async {
    /*setState(() {
      _messages.insert(0, m);
      _messages.insert(1,m);
    });*/

    // Initial list with two Messages objects
    List<Messages> initialMessages = [
      Messages(role: Role.system, content: system),
      Messages(role: Role.user, content: user),
    ];
    /*
    List<Messages> messagesTemplate = _messages.reversed.map((m) {

        if (m.user == _currentUser) {
          return Messages(role: Role.user, content: m.text);
        } else{
          return Messages(role: Role.system, content: m.text);
        }

    }).toList();

    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      temperature: 0.2,
      messages: initialMessages,
      maxToken: 200,
    );
    final response = await _openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      if (element.message != null) {
        /*
        setState(() {
          _messages.insert(0, element.message!.content);
        });*/
        return element.message!.content;
      }
    }
    return "Get question response error";*/

    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      temperature: 0.2,
      messages: initialMessages,
      maxToken: 200,
    );

    try {
      final response = await _openAI.onChatCompletion(request: request);
      for (var element in response!.choices) {
        if (element.message != null) {
          return element.message!.content;
        }
      }
      return "Get question response error";
    } catch (e) {

      // Handle rate limit exceeded error
      if (e is Exception) {
        print("Error: $e");

        // Check if the error response has a status code
        //if (e.response?.statusCode == 429) {
        print("Rate limit exceeded. Waiting for 20 seconds.");
        correct = false;
        return level1_question = '$numberA${operators[operatorIndex]}$numberB';
        // await Future.delayed(Duration(seconds: 20));
        // Retry the request after waiting
        // return getQuestionResponse(system, user);
      }
      // Handle other errors
      return "Error occurred";
    }
  }

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
  bool correct=true;
  // GO TO NEXT QUESTION
  void goToNextQuestion() {
    // dismiss alert dialog
    //Navigator.of(context).pop();

    // reset values
    setState(() {
      userAnswer = '';
      correct = true;
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
      correct = false;
    });
  }

  Future<Text> questionGenerator() async {
    if (seconds_decrement <= 0) {
      setState(() {
        allowPlay = false;
        keju(); // Make sure to handle asynchronous operations correctly
        if (highScore < currentScore) {
          highScore = currentScore;
          print('New HighScore: $highScore');
          // update new score
          updateHighScoreInFirestore(currentEmail, highScore);
        }
        // reset current score once uploaded
        currentScore = 0;
      });
    }

    if(correct) {
      String systemQuery =
          'Instruction:\n'
          'You are a computer system that only generate the math question in numbers format: [number] [operator] [number]\n'
          'Only allow output format of numbers, +, -, /, *, %, and brackets.\n'
          '---------------------------------------------------------------------------------------------\n'
          'Avoid:\n'
          'Responding with general AI alphabetic words response\n'
          'Responding with unnecessary output other than the question itself\n'
          'Using = or ?\n'
          '---------------------------------------------------------------------------------------------\n'
          'Query:\n'
          'generate 1 random math question with random difficulty using either combination of +, -, /, *, %, and '
          'brackets and maximum of 3 terms max and 2 terms minimum\n'
          '---------------------------------------------------------------------------------------------\n'
          'Format:\n'
          '[The Math question term]\n'
          '---------------------------------------------------------------------------------------------\n'
          'Example:\n'
          '8*2\n';

      String userQuery =
          '---------------------------------------------------------------------------------------------';

        level1_question = await getQuestionResponse(systemQuery, userQuery);
        correct = false;
    }
    return Text(
      level1_question + ' = ',
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
        title: const Text("E Z M A T H (level 2)"),
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
          //question
          FutureBuilder<Text>(
            future: questionGenerator(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Expanded(
                  child: Container(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          snapshot.data ?? Text("Error loading question"),
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
                );
              } else {
                return CircularProgressIndicator();
              }
            },
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
