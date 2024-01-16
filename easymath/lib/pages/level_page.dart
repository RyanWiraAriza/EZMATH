import 'package:easymath/pages/responsive/desktop_body.dart';
import 'package:easymath/pages/responsive/dimensions.dart';
import 'package:easymath/pages/responsive/mobile_body.dart';
import 'package:easymath/pages/responsive/responsive_layout.dart';
import 'package:flutter/material.dart';

class LevelPage extends StatefulWidget {
  const LevelPage({super.key});

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  @override
  Widget build(BuildContext context){
    final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      //appBar: AppBar(title: Text("L E V E L"),backgroundColor: Theme.of(context).colorScheme.inversePrimary,centerTitle: true,),
      backgroundColor: currentWidth < mobileWidth ? Colors.deepPurple[300] : Colors.green[300],
      body: const ResponsiveLayout(
        mobileBody: MyMobileBody(),
        desktopBody: MyDesktopBody(),
      ),
    );
  }
}

