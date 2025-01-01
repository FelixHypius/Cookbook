import 'dart:async';
import 'package:cookbook/base_widgets/base_input_field.dart';
import 'package:cookbook/base_widgets/base_listview.dart';
import 'package:cookbook/util/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../base_widgets/base_scaffold.dart';
import '../base_widgets/base_drawer.dart';
import '../base_widgets/base_bottom_navigation_bar.dart';
import '../base_widgets/base_stream_builder.dart';
import '../database/database_service.dart';
import '../database/local_database_service.dart';
import '../util/colors.dart';
import '../util/custom_text_style.dart';

class SectionList extends StatefulWidget{

  const SectionList({super.key});

  @override
  SectionListState createState() => SectionListState();
}

class SectionListState extends State<SectionList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final lDbs = LocalDatabaseService();
  final dbs = DatabaseService();
  String _searchQuery = '';
  late StreamController<List<dynamic>> _controller;
  late Stream<List<dynamic>> _stream;
  DateFormat format = DateFormat('dd.MM.yyyy HH:mm:ss');

  @override
  void initState() {
    super.initState();
    _controller = StreamController<List<dynamic>>();
    _stream = _controller.stream;
    _fetchAndListen();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  DateTime parseDateTime(String? dateString) {
    try {
      if (dateString != null && dateString.isNotEmpty) {
        return format.parse(dateString);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
              'Error: Date string is null or empty.'
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
            'Error parsing DateTime: $e'
        ),
      );
    }
    return DateTime.now();
  }

  Future<void> _fetchAndListen() async {
    // Check if there is local data available.
    final latestLocal = await lDbs.getTimeStamp();
    final latestOnline = await dbs.latestUpdateTime;
    bool needSync = false;

    if (latestLocal != null) {
      final DateTime local = format.parse(latestLocal);
      final DateTime online = parseDateTime(latestOnline);
      // Check if database timestamp is younger than local timestamp.
      if (online.isAfter(local)) {
        // Fetch initial data and save locally
        needSync = true;
      } else {
        final localData = await lDbs.getSectionsData();
        _controller.add(localData);
      }
    } else {
      needSync = true;
    }

    if (needSync) {
      try {
        final snapshot = await dbs.sectionList;
        if (snapshot != null) {
          List<dynamic> data = snapshot.value as List<dynamic>;
          _controller.add(data);
          await lDbs.setSectionsData(snapshot, latestOnline??DateTime.now().toString());
        }
      } catch (e) {
        _controller.addError(e);
      }
    }

    // Listen for changes and save those locally
    final ref = FirebaseDatabase.instance.ref().child('sections');
    ref.onValue.listen((event) async {
      List<dynamic> data = event.snapshot.value as List<dynamic>;
      _controller.add(data);
      if (event.snapshot.exists) {
        await lDbs.setSectionsData(event.snapshot, latestOnline??DateTime.now().toString());
      }
    });
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
                    final List<dynamic> sections = List<dynamic>.from(valueList);
                    if (sections[0] == null) sections.remove(sections[0]);
                    final String uid = FirebaseAuth.instance.currentUser!.uid;
                    // Delete all sections without ownership.
                    sections.removeWhere((section) => section == null || section['owner'] != uid);
                    return BaseListView(
                      values: sections,
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


