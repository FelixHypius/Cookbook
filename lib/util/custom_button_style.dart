import 'package:flutter/material.dart';

class CustomButtonStyle extends ButtonStyle{
  final Color backColor;
  final Color borderColor;

  CustomButtonStyle({
    required this.backColor,
    required this.borderColor
  }) : super(
    minimumSize: WidgetStateProperty.all(Size(double.infinity, 50)),
    backgroundColor: WidgetStateProperty.all(backColor),
    side: WidgetStateProperty.all(BorderSide(color: borderColor, width: 3)),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}