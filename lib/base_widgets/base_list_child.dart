import 'package:cookbook/util/custom_text_style.dart';
import 'package:flutter/material.dart';
import '../util/colors.dart';
import '../util/navigation.dart';

class BaseListChild extends GestureDetector{
  final String text;
  final int id;
  final BuildContext contxt;

  BaseListChild({
    super.key,
    required this.text,
    required this.id,
    required this.contxt,
  }) : super (
    onTap: () {
      navigateToPage(contxt, 9, 8, sectionId: id);
    },
    child: Container(
      decoration: BoxDecoration(
        color: MyColors.myBlack,
        border: Border.all(
          color: MyColors.myGrey,
          width: 2
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(text, style: CustomTextStyle(size: 20,),),
    ),
  );
}