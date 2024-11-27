import 'package:cookbook/util/colors.dart';
import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Widget? drawer;
  final Widget? bottomnavigationbar;

  const BaseScaffold({
    Key? key,
    required this.body,
    this.scaffoldKey,
    this.drawer,
    this.bottomnavigationbar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: drawer,
      bottomNavigationBar: bottomnavigationbar,
      backgroundColor: MyColors.myBlack,
      drawerEnableOpenDragGesture: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: body,
        ),
      ),
    );
  }
}
