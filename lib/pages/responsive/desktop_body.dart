import 'package:flutter/material.dart';

class MyDesktopBody extends StatelessWidget {
  const MyDesktopBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      appBar: AppBar(
        title: const Text('D E S K T O P'),
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Row(
        children: [
          // first column
          Expanded(
            child: Column(
              children: [
                // video screen
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      height: 250,
                      color: Colors.deepPurple[400],
                    ),
                  ),
                ),
            
                // comment sections form screen
                Expanded(
                  child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.deepPurple[300],
                          height: 120,
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),

          // Second column for desktop recommeded vids
          Container(
            width: 100,
            color: Colors.deepPurple[300],
          )
        ],
      ),
    );
  }
}
