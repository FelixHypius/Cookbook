import 'package:flutter/material.dart';
import '../util/colors.dart';
import '../util/custom_text_style.dart';

class IntroPage extends StatefulWidget{
  final VoidCallback onIntroComplete;

  const IntroPage({super.key, required this.onIntroComplete});

  @override
  IntroPageState createState() => IntroPageState();
}

class IntroPageState extends State<IntroPage> {
  bool first = true;
  double potPosition = 0;
  double pageOpacity = 1;

  void animatePot(){
    setState(() {
      potPosition = MediaQuery.of(context).size.height + 100;
    });
    Future.delayed(Duration(milliseconds: 600), () {
      setState(() {
        pageOpacity = 0;
      });
    });
    Future.delayed(Duration(milliseconds: 1000), () {
      widget.onIntroComplete();
    });
  }

  void onVerticalSwipe(DragEndDetails details) {
    if (details.velocity.pixelsPerSecond.dy < 0) {
      // Swipe up detected
      animatePot();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    potPosition = first ? MediaQuery.of(context).size.height * 0.275 : potPosition;
    first = false;

    return GestureDetector(
      onVerticalDragEnd: onVerticalSwipe,
      child: AnimatedOpacity(
        opacity: pageOpacity,
        duration: Duration(milliseconds: 400),
        child: Scaffold(
          backgroundColor: MyColors.myBlack,
          body: Stack(
            children: [
              Positioned(
                top: screenHeight*0.08,
                child: SizedBox(
                  width: screenWidth,
                  height: screenHeight * 0.5,
                  child: Text(
                    "Felix's\nCookbook",
                    textAlign: TextAlign.center,
                    style: CustomTextStyle(size: screenWidth*0.15)
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  width: screenWidth,
                  height: screenHeight * 0.3,
                  decoration: const BoxDecoration(color: MyColors.myWhite),
                ),
              ),
              Positioned(
                left: 8,
                right: 8,
                bottom: 0,
                child: Container(
                  width: screenWidth,
                  height: screenHeight * 0.3,
                  decoration: const BoxDecoration(color: MyColors.myGrey),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: screenHeight*0.2,
                child: Container(
                  width: screenWidth,
                  height: screenHeight * 0.2,
                  decoration: BoxDecoration(
                    color: MyColors.myRed,
                    borderRadius: BorderRadius.all(Radius.elliptical(screenHeight*0.475, screenHeight*0.2)),
                    border: Border.all(
                      color: MyColors.myWhite,
                      width: 10
                    )
                  ),
                )
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 700),
                bottom: potPosition, // Control the pot's position
                left: 0,
                right: 0,
                child: Stack(
                  children: [
                    Positioned(
                      child: Container(
                        width: screenWidth,
                        height: screenHeight * 0.2,
                        decoration: BoxDecoration(
                            color: MyColors.myGrey,
                            borderRadius: BorderRadius.all(Radius.elliptical(screenHeight*0.475, screenHeight*0.2)),
                            border: Border.all(
                                color: MyColors.myWhite,
                                width: 10
                            )
                        ),
                      ),
                    ),
                    Positioned(
                      left: screenWidth*0.15,
                      child: Container(
                        width: screenWidth*0.7,
                        height: screenHeight * 0.125,
                        decoration: BoxDecoration(
                            color: MyColors.myGrey,
                            borderRadius: BorderRadius.all(Radius.elliptical(screenHeight*0.325, screenHeight*0.125)),
                            border: Border.all(
                                color: MyColors.myWhite,
                                width: 10
                            )
                        ),
                      ),
                    ),
                    Positioned(
                      left: screenWidth*0.425,
                      child: Container(
                        width: screenWidth*0.15,
                        height: screenHeight * 0.06,
                        decoration: BoxDecoration(
                            color: Color(0xFF353535),
                            borderRadius: BorderRadius.all(Radius.elliptical(screenHeight*0.1, screenHeight*0.045)),
                            border: Border.all(
                                color: Color(0xFF353535),
                                width: 10
                            )
                        ),
                      ),
                    )
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
