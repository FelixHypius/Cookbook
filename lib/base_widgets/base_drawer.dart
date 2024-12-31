import 'dart:math';

import 'package:cookbook/util/colors.dart';
import 'package:cookbook/util/custom_text_style.dart';
import 'package:flutter/material.dart';
import '../util/navigation.dart';

class BaseDrawer extends StatelessWidget{
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int currentIndex;

  const BaseDrawer({
    super.key,
    required this.scaffoldKey,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final List<Text> textWidgets = [
      Text('Add recipe', style: CustomTextStyle(size: 18, colour: MyColors.myWhite)),
      Text('Add section', style: CustomTextStyle(size: 18, colour: MyColors.myWhite)),
      Text('Edit section', style: CustomTextStyle(size: 18, colour: MyColors.myWhite)),
      Text('Create list', style: CustomTextStyle(size: 18, colour: MyColors.myWhite)),
      Text('Settings', style: CustomTextStyle(size: 18, colour: MyColors.myGrey)),
    ];

    double maxWidth = 0.0;
    for (var textWidget in textWidgets) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: textWidget.data,
          style: textWidget.style,
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      maxWidth = max(maxWidth, textPainter.size.width);
    }

    return Drawer(
      width: min(MediaQuery.of(context).size.width * 0.5, maxWidth+60),
      backgroundColor: MyColors.myBlack,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 30,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                GestureDetector(
                  onTap: () {
                    scaffoldKey.currentState?.closeDrawer();
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 16,
                      right: 16,
                      bottom: 16,
                    ),
                    alignment: Alignment.topRight,
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: MyColors.myWhite,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: textWidgets[0],
                  onTap: (){
                    navigateToPage(context, 3, currentIndex, scaffoldState: scaffoldKey.currentState);
                  },
                ),
                ListTile(
                  title: textWidgets[1],
                  onTap: (){
                    navigateToPage(context, 6, currentIndex, scaffoldState: scaffoldKey.currentState);
                  },
                ),
                ListTile(
                  title: textWidgets[2],
                  onTap: (){
                    navigateToPage(context, 8, currentIndex, scaffoldState: scaffoldKey.currentState);
                  },
                ),
                ListTile(
                  title: textWidgets[3],
                  onTap: (){
                    navigateToPage(context, 2, currentIndex, scaffoldState: scaffoldKey.currentState);
                  },
                ),
                ListTile(
                  title: textWidgets[4],
                  onTap: (){
                    navigateToPage(context, 10, currentIndex, scaffoldState: scaffoldKey.currentState);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8, left: 8),
            child: Text(
              'Version 1.1.3',
              style: CustomTextStyle(size: 10, colour: MyColors.myGrey,),
            ),
          )
        ],
      )
    );
  }
}