import 'package:cookbook/util/custom_text_style.dart';
import 'package:flutter/material.dart';
import '../util/colors.dart';

class BaseFutureBuilder extends FutureBuilder{
  final Future<dynamic> func;
  final Widget Function(BuildContext, dynamic) build;

  BaseFutureBuilder({
    super.key,
    required this.func,
    required this.build,
  }) : super (
    future: func,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator(strokeWidth: 2, color: MyColors.myRed,));
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text('Error: No Data available.', style: CustomTextStyle(size: 15, colour: MyColors.myRed),));
      } else {
        return build(context, snapshot.data!);
      }
    }
  );
}