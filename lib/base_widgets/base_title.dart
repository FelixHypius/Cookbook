import 'package:flutter/material.dart';
import '../util/custom_text_style.dart';

class BaseTitle extends Padding{
  final String text;
  final double screenHeight;
  final double screenWidth;

  BaseTitle({
    required this.text,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(
    padding: EdgeInsets.only(top: screenHeight * 0.08),
    child: Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: CustomTextStyle(
          size: screenWidth*0.15
        )
      ),
    ),
  );
}