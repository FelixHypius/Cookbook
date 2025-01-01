import 'package:flutter/material.dart';
import '../util/colors.dart';
import '../util/custom_text_style.dart';

class BaseStreamBuilder extends StreamBuilder {
  final Stream<dynamic> streamm;
  final Widget Function(BuildContext, dynamic) buildd;

  BaseStreamBuilder ({
    super.key,
    required this.streamm,
    required this.buildd,
  }) : super (
    stream: streamm,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator(strokeWidth: 2, color: MyColors.myBrightRed,));
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData) {
        return Center(child: Text('Error: No data available.', style: CustomTextStyle(size: 15, colour: MyColors.myRed),));
      } else {
        return buildd(context, snapshot.data);
      }
    }
  );
}