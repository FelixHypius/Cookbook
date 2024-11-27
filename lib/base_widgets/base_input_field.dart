import 'package:flutter/material.dart';
import '../util/colors.dart';
import '../util/custom_text_style.dart';

class BaseInputField extends TextField{
  final String? hintText;
  final TextEditingController? control;
  final IconData? icon;
  final bool? obscure;
  final Color? fillColour;
  final Color? focusedColour;
  final Color? normalColour;
  final Color? textColour;
  final Color? iconColour;
  final TextAlign? textAlignment;
  final double? textSize;
  final double? paddingWidth;
  final Color? hintColour;
  final double? borderWidth;
  final double? paddingHeight;
  final int? maxRows;
  // If it is a searchbar:
  final ValueChanged<String>? onChange;

  BaseInputField({
    super.key,
    this.hintText,
    this.icon,
    this.control,
    this.obscure,
    this.fillColour,
    this.focusedColour,
    this.iconColour,
    this.normalColour,
    this.textColour,
    this.textAlignment,
    this.textSize,
    this.paddingWidth,
    this.hintColour,
    this.onChange,
    this.borderWidth,
    this.paddingHeight,
    this.maxRows
  }) : super(
    onChanged: onChange,
    style: CustomTextStyle(
      size: textSize ?? 15,
      colour: textColour ?? MyColors.myBlack,
    ),
    cursorColor: MyColors.myRed,
    textAlign: textAlignment ?? TextAlign.left,
    expands: false,
    maxLines: maxRows,
    controller: control,
    obscureText: obscure ?? false,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: paddingHeight ?? 15, horizontal: paddingWidth ?? 0),
      isDense: paddingHeight != null ? true : false,
      prefixIcon: icon != null
          ? Icon(icon, color: iconColour ?? MyColors.myGrey,)
          : null,
      fillColor: fillColour ?? MyColors.myWhite,
      filled: true,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: focusedColour ?? MyColors.myRed,
              width: borderWidth ?? 2
          )
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: normalColour ?? MyColors.myGrey,
              width: borderWidth ?? 2
          )
      ),
      hintText: hintText,
      hintStyle: CustomTextStyle(
        size: textSize ?? 15,
        colour: hintColour ?? MyColors.myGrey,
      ),
    ),
  );
}