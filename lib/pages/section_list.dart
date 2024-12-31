import 'dart:async';
import 'package:cookbook/base_widgets/base_input_field.dart';
import 'package:cookbook/base_widgets/base_listview.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../base_widgets/base_scaffold.dart';
import '../base_widgets/base_drawer.dart';
import '../base_widgets/base_bottom_navigation_bar.dart';
import '../base_widgets/base_stream_builder.dart';
import '../util/colors.dart';
import '../util/custom_text_style.dart';

class SectionList extends StatefulWidget{

  const SectionList({super.key});

  @override
  SectionListState createState() => SectionListState();
}

class SectionListState extends State<SectionList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _searchQuery = '';
  late StreamController<DataSnapshot> _controller;
  late Stream<DataSnapshot> _stream;

  @override
  void initState() {
    super.initState();
    _controller = StreamController<DataSnapshot>();
    _stream = _controller.stream;
    _fetchAndListen();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  Future<void> _fetchAndListen() async {
    final ref = FirebaseDatabase.instance.ref().child('sections');

    // Emit the initial data
    try {
      final snapshot = await ref.get();
      if (snapshot.exists) {
        _controller.add(snapshot);  // Initial fetch
      }
      // Start listening to changes
      ref.onValue.listen((event) {
        _controller.add(event.snapshot); // Updates after the initial fetch
      });
    } catch (error) {
      _controller.addError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        scaffoldKey: _scaffoldKey,
        drawer: BaseDrawer(
          scaffoldKey: _scaffoldKey,
          currentIndex: 8,
        ),
        bottomnavigationbar: BaseBottomNavigationBar(
          scaffoldKey: _scaffoldKey,
          currentIndex: 8,
          initialSelectedIndex: 0,
        ),
        body: Column(
          children: [
            BaseInputField(
              borderWidth: 0,
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
                  streamm: _stream,
                  buildd: (context, valueList) {
                    if (valueList == null || valueList.isEmpty) return Center(child: Text('No sections available.', style: CustomTextStyle(size: 15, colour: MyColors.myRed),));
                    final List<dynamic> values = List<dynamic>.from(valueList);
                    if (values[0] == null) values.remove(values[0]);
                    return BaseListView(
                      values: values,
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


