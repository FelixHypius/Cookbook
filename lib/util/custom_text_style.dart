import 'package:flutter/material.dart';
import 'colors.dart';

class CustomTextStyle extends TextStyle{
  final double size;
  final Color? colour;
  final FontWeight? weight;
  final bool? underlined;
  final double? tallness;

  const CustomTextStyle({
    this.weight,
    required this.size,
    this.colour,
    this.underlined = false,
    this.tallness
  }) : super(
    height: tallness,
    fontSize: size,
    fontFamily: 'CookbookFonts',
    color: colour ?? MyColors.myWhite,
    fontWeight: weight ?? FontWeight.normal,
    decoration: underlined == true ? TextDecoration.underline : TextDecoration.none
  );
}