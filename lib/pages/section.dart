import 'package:cookbook/base_widgets/base_input_field.dart';
import 'package:cookbook/base_widgets/base_stream_builder.dart';
import 'package:cookbook/database/data_sync_service.dart';
import 'package:flutter/material.dart';
import '../base_widgets/base_scaffold.dart';
import '../base_widgets/base_drawer.dart';
import '../base_widgets/base_bottom_navigation_bar.dart';
import '../base_widgets/base_gridview.dart';
import '../util/colors.dart';
import '../util/custom_text_style.dart';

class SectionPage extends StatefulWidget{
  final int sectionId;
  const SectionPage({super.key, required this.sectionId});

  @override
  SectionPageState createState() => SectionPageState();
}

class SectionPageState extends State<SectionPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _searchQuery = '';
  final dss = DataSyncService();

  @override
  void initState() {
    super.initState();
    dss.setSecId(widget.sectionId);
    dss.fetchAndListenRecipes();
  }

  @override
  void dispose() {
    dss.dispose();
    super.dispose();
  }

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
          currentIndex: 4,
          initialSelectedIndex: 1,
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
              Navigator.pop(context);
            }
          },
          child: Column(
            children: [
              BaseInputField(
                borderWidth: 0,
                onChange: (query) {
                  setState(() {
                    _searchQuery = query.toLowerCase(); // Update the search query
                  });},
                hintText: 'Search for recipes..',
                icon: Icons.search_rounded,
              ),
              Container(
                height: 15,
              ),
              Expanded(
                  child: BaseStreamBuilder(
                    streamm: dss.stream,
                    buildd: (context, valueList) {
                      if (valueList == null || valueList.isEmpty) {
                        return Center(
                          child: Text(
                            'No sections available.',
                            style: CustomTextStyle(size: 15, colour: MyColors.myRed),
                          ),
                        );
                      }
                      final List<dynamic> values = List<dynamic>.from(valueList);
                      if (values[0] == null) values.remove(values[0]);
                      return BaseGridView(
                        values: valueList,
                        parent: 'recipes',
                        searchQuery: _searchQuery,
                      );
                    },
                  )
              ),
            ],
          ),
        )
    );
  }
}
