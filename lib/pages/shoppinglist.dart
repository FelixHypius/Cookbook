import 'package:flutter/material.dart';

import '../base_widgets/base_bottom_navigation_bar.dart';
import '../base_widgets/base_drawer.dart';
import '../base_widgets/base_scaffold.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  ShoppingListState createState() => ShoppingListState();
}

class ShoppingListState extends State<ShoppingList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      scaffoldKey: _scaffoldKey,
      drawer: BaseDrawer(
        scaffoldKey: _scaffoldKey,
        currentIndex: 2,
      ),
      bottomnavigationbar: BaseBottomNavigationBar(
        scaffoldKey: _scaffoldKey,
        currentIndex: 2,
        initialSelectedIndex: 2,
      ),
      body: SizedBox()
    );
  }
}

