import 'package:flutter/material.dart';
import '../util/colors.dart';
import '../util/custom_text_style.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class BaseDropdownButton extends DropdownButton2 {
  final List<String> values;
  final Function(dynamic) func;
  final String currentValue;

  final Color? dropColor;
  final Color? borderColor;
  final Color? hintColor;
  final String? hintText;

  final double? paddingTop;
  final double? paddingLeft;
  final double? paddingRight;
  final double? paddingBottom;

  final double? menuHeight;

  BaseDropdownButton({
    super.key,
    required this.values,
    required this.func,
    required this.currentValue,
    this.dropColor,
    this.borderColor,
    this.hintColor,
    this.paddingTop,
    this.paddingBottom,
    this.paddingLeft,
    this.paddingRight,
    this.menuHeight,
    this.hintText,
  }) : super(
    value: currentValue,
    items: values.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          value,
          style: CustomTextStyle(size: 15, colour: hintText==value?hintColor??MyColors.myGrey:MyColors.myWhite),
        ),
      );
    }).toList(),
    onChanged: func,
    style: CustomTextStyle(size: 15, colour: hintText==currentValue?hintColor??MyColors.myGrey:MyColors.myWhite),
    buttonStyleData: ButtonStyleData(
      height: 42.5,
      width: double.infinity,
      padding: EdgeInsets.only(left: paddingLeft??10, right: paddingRight??0, top: paddingTop??5, bottom: paddingBottom??5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor??MyColors.myGrey,
          width: 1
        ),
        color: MyColors.myBlack
      )
    ),
    iconStyleData: IconStyleData(
      icon: Icon(Icons.arrow_drop_down_rounded),
      iconSize: 25,
      iconEnabledColor: MyColors.myGrey
    ),
    dropdownStyleData: DropdownStyleData(
      maxHeight: menuHeight??200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: MyColors.myGrey
        ),
        color: dropColor??MyColors.myBlack
      ),
      scrollbarTheme: ScrollbarThemeData(
        thickness: WidgetStateProperty.all<double>(4),
      ),
    ),
    menuItemStyleData: const MenuItemStyleData(
      height: 30,
      padding: EdgeInsets.only(left: 14, right: 14),
    ),
    isDense: true,
    underline: SizedBox()
  );
}
