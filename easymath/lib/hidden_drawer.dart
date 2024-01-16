import 'package:easymath/pages/level_page.dart';
import 'package:easymath/pages/scoreboard_page.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> _pages = [];

  final myTextStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Colors.white
  );
  final myTextStyleSelected = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 25,
      color: Colors.white
  );


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*
    _pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Level Selection',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: Colors.white,
        ),
        LevelPage(),
        /*
        GestureDetector(
            onTap: (){
              if(mounted)Navigator.pushNamed(context, "/levelpage");
            },),*/
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Scoreboard',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: Colors.white,
        ),
        ScoreboardPage(),
        /*
        GestureDetector(
            onTap: (){
              if(mounted)Navigator.pushNamed(context, "/scoreboardpage");
            },),*/
      ),
    ];*/
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    /*return HiddenDrawerMenu(
        screens: _pages,
        backgroundColorMenu: Colors.deepPurple.shade200,
        backgroundColorAppBar: Colors.deepPurple,
        backgroundColorContent: Colors.white,
        slidePercent: 40,
        initPositionSelected: 0);*/
  }
}
