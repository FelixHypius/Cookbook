import 'package:cookbook/util/colors.dart';
import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Widget? drawer;
  final Widget? bottomnavigationbar;

  const BaseScaffold({
    super.key,
    required this.body,
    this.scaffoldKey,
    this.drawer,
    this.bottomnavigationbar,
  });

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
          padding: EdgeInsets.only(top: 10, right: 10, bottom: 5, left: 10),
          child: body,
        ),
      ),
    );
  }
}
