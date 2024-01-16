import 'package:easymath/pages/intro_screens/intro_page_1.dart';
import 'package:easymath/pages/intro_screens/intro_page_2.dart';
import 'package:easymath/pages/intro_screens/intro_page_3.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  // controller to keep track which page we're on
  final _controller = PageController();
  int currentPage = 0;

  //keep track of if we are on the last page or not
  bool onLastPage = false;
  //keep track of if we are on the first page or not
  bool onFirstPage = true;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children:[
          PageView(
            controller: _controller,
            onPageChanged: (index){
              setState(() {
                currentPage = index;
                onLastPage = (index == 2);
                onFirstPage = (index == 0);
              });
            },
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          //dot indicators
          Container(
                alignment: const Alignment(0,0.7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // skip
                    // if on first page then button_skip if not button_prev
                    //checking if first and last page is not currently showed
                    onFirstPage
                    ?GestureDetector(
                      onTap: (){
                        _controller.jumpToPage(2);
                      },
                      child: const Text('skip'),
                    )
                    :GestureDetector(
                      onTap: (){
                        _controller.jumpToPage(currentPage-1);
                      },
                      child: const Text('prev'),
                    ),

                    // dot indicator
                    SmoothPageIndicator(
                        controller: _controller,
                        count: 3,
                        effect: JumpingDotEffect(
                          activeDotColor: Colors.deepPurple.shade100,
                          dotColor: Colors.deepPurple.shade50,
                          dotHeight: 30,
                          dotWidth: 30,
                          verticalOffset: 30,
                          jumpScale: 2,
                        )),

                    // next or done
                    // if last page is true ?gesture if not :gesture
                    onLastPage
                    ?GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, "/loginchecking");
                      },
                      child: const Text('done'),
                    )
                    :GestureDetector(
                      onTap: (){
                        _controller.nextPage(
                          duration: const Duration(microseconds: 500),
                          curve: Curves.easeIn,
                        );
                      },
                      child: const Text('next'),
                    ),

                  ],
                )
          ),
        ],
      ),
    );
  }
}

