import 'package:flutter/material.dart';
import '../util/colors.dart';

class BaseButton extends OutlinedButton {
  final Function func;
  final Icon? icon;
  final OutlinedBorder? border;
  final Text? text;
  final MainAxisAlignment? align;
  final EdgeInsetsGeometry? padding;
  final double? sizeSpace;
  final double? thickness;

  BaseButton ({
    super.key,
    required this.func,
    this.icon,
    this.text,
    this.border,
    this.align,
    this.padding,
    this.sizeSpace,
    this.thickness,
  }) : super (
    onPressed: ()  => func(),
    style: OutlinedButton.styleFrom(
      shape: border ?? CircleBorder(),
      side: BorderSide(color: MyColors.myWhite, width: thickness??1),
      padding: EdgeInsets.zero,
      minimumSize: Size.zero
    ),
    child: Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: align ?? MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(child: icon,),
          SizedBox(
            width: sizeSpace ?? 0,
          ),
          Container(child: text,),
        ],
      ),
    )
  );
}