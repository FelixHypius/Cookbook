import 'package:cookbook/base_widgets/base_input_field.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../base_widgets/base_scaffold.dart';
import '../base_widgets/base_drawer.dart';
import '../base_widgets/base_bottom_navigation_bar.dart';
import '../base_widgets/base_gridview.dart';
import '../base_widgets/base_stream_builder.dart';
import '../util/colors.dart';
import '../util/custom_text_style.dart';

class Homepage extends StatefulWidget{

  const Homepage({super.key});

  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        scaffoldKey: _scaffoldKey,
        drawer: BaseDrawer(
          scaffoldKey: _scaffoldKey,
          currentIndex: 1,
        ),
        bottomnavigationbar: BaseBottomNavigationBar(
          scaffoldKey: _scaffoldKey,
          currentIndex: 1,
          initialSelectedIndex: 1,
        ),
        body: Column(
          children: [
            BaseInputField(
              onChange: (query) {
                setState(() {
                  _searchQuery = query.toLowerCase(); // Update the search query
                });},
              hintText: 'Search for categories..',
              icon: Icons.search_rounded,
            ),
            Container(
              height: 15,
            ),
            Expanded(
              child: BaseStreamBuilder(
                streamm: FirebaseDatabase.instance.ref().child('sections').onValue,
                buildd: (context, valueList) {
                  if (valueList == null || valueList.isEmpty) return Center(child: Text('No sections available.', style: CustomTextStyle(size: 15, colour: MyColors.myRed),));
                  final List<dynamic> values = List<dynamic>.from(valueList);
                  if (values[0] == null) values.remove(values[0]);
                  return BaseGridView(
                    values: values,
                    parent: 'sections',
                    searchQuery: _searchQuery,
                  );
                },
              )
            ),
          ],
        )
    );
  }
}

