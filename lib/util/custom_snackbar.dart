import 'package:cookbook/util/colors.dart';
import 'package:cookbook/util/custom_text_style.dart';
import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar{
  final String text;
  final int? time;

  CustomSnackBar(this.text, {super.key, this.time}) : super(
    content: Text(
      text,
      style: CustomTextStyle(size: 12),
    ),
    duration: Duration(milliseconds: time??1800),
    backgroundColor: MyColors.myDarkGrey
  );

}