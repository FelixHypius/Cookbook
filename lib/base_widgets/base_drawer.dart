import 'package:flutter/material.dart';
import '../util/navigation.dart';

class BaseDrawer extends StatelessWidget{
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int currentIndex;

  const BaseDrawer({
    super.key,
    required this.scaffoldKey,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.5,
      backgroundColor: Color(0xFFD9D9D9),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          GestureDetector(
            onTap: () {
              scaffoldKey.currentState?.closeDrawer();
            },
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                right: 16,
                bottom: 16,
              ),
              alignment: Alignment.topRight,
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF656565),
              ),
            ),
          ),
          ListTile(
            title: const Text('Add recipe'),
            onTap: (){
              navigateToPage(context, 3, currentIndex, scaffoldState: scaffoldKey.currentState);
            },
          ),
          ListTile(
            title: const Text('Add section'),
            onTap: (){
              navigateToPage(context, 6, currentIndex, scaffoldState: scaffoldKey.currentState);
            },
          ),
        ],
      ),
    );
  }
}