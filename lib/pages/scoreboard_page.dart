import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easymath/pages/get_email.dart';
import 'package:flutter/material.dart';

class ScoreboardPage extends StatefulWidget {
  const ScoreboardPage({super.key});

  @override
  State<ScoreboardPage> createState() => _ScoreboardPageState();
}

class _ScoreboardPageState extends State<ScoreboardPage> {
  int _selectedIndex=0;
  List<String> docIDs = [];

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('users')
        .orderBy('score',descending: true)
        .get()
        .then(
            (snapshot) => snapshot.docs.forEach((document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            }),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          leading: const SizedBox(width: 5),
        title: const Text("PLAYER SCORE"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        foregroundColor: Colors.white),
      body: Container(
        color: Colors.deepPurple[200],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FutureBuilder(
                  future: getDocId(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                        itemCount: docIDs.length,
                        itemBuilder: (context,index){
                          return ListTile(
                            title: GetData_Email(documentId: docIDs[index]),
                            tileColor: Colors.grey[200],
                            trailing: IconButton(
                              onPressed:  () {

                              },
                              icon: const Icon(Icons.settings),
                            ),
                          );
                        },
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

