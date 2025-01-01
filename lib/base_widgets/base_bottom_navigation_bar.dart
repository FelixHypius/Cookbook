import 'package:cookbook/util/colors.dart';
import 'package:flutter/material.dart';
import '../util/navigation.dart';

class BaseBottomNavigationBar extends StatefulWidget {
  final int initialSelectedIndex;
  final int currentIndex;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final double? height;

  const BaseBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.scaffoldKey,
    required this.initialSelectedIndex,
    this.height,
  });

  @override
  BaseBottomNavigationBarState createState() => BaseBottomNavigationBarState();
}

class BaseBottomNavigationBarState extends State<BaseBottomNavigationBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialSelectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    navigateToPage(context, index, widget.currentIndex, scaffoldState: widget.scaffoldKey.currentState);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height??61,
      child: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu_rounded, size: 28,), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_rounded), label: ""),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 25,
        backgroundColor: MyColors.myBlack,
        unselectedItemColor: MyColors.myWhite,
        selectedItemColor: MyColors.myRed,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
    );
  }
}