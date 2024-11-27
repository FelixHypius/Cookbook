import 'package:cookbook/util/colors.dart';
import 'package:flutter/material.dart';
import '../util/navigation.dart';

class BaseBottomNavigationBar extends StatefulWidget {
  final int initialSelectedIndex;
  final int currentIndex;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const BaseBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.scaffoldKey,
    required this.initialSelectedIndex,
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
    print(widget.currentIndex);
    navigateToPage(context, index, widget.currentIndex, scaffoldState: widget.scaffoldKey.currentState);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.menu_rounded), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
      ],
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: 25,
      backgroundColor: MyColors.myWhite,
      unselectedItemColor: MyColors.myBlack,
      selectedItemColor: MyColors.myRed,
      onTap: _onItemTapped,
      currentIndex: _selectedIndex,
    );
  }
}