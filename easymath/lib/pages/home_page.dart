import 'package:easymath/pages/chat_page.dart';
import 'package:easymath/pages/scoreboard_page.dart';
import 'package:flutter/material.dart';
import 'calculate_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPageIndex = 0;
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        onPageChanged: (index){
          setState(() {
            _selectedPageIndex = index;
          });
        },
        children: const [
          CalculatePage(),
          ChatPage(),
          ScoreboardPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculate',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat GPT',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.scoreboard),
            label: 'Scoreboard',
            backgroundColor: Colors.black,
          ),
        ],
        currentIndex: _selectedPageIndex,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.white,
        onTap: (index){
          setState(() {
            _selectedPageIndex = index;
            _pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          });
        },
      ),
    );
  }
}
