import 'package:cookbook/base_widgets/base_input_field.dart';
import 'package:cookbook/database/database_service.dart';
import 'package:flutter/material.dart';
import '../base_widgets/base_future_builder.dart';
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
  final DatabaseService dbs = DatabaseService();

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
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
              Navigator.pop(context);
            }
          },
          child: Column(
            children: [
              BaseInputField(
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
                  child: BaseFutureBuilder(
                    func: dbs.getRecipeList(widget.sectionId),
                    build: (context, recipeMapList) {
                      if (recipeMapList == null || recipeMapList.isEmpty) return Center(child: Text('No recipes available.', style: CustomTextStyle(size: 15, colour: MyColors.myRed),));
                      if (recipeMapList[0] == null) recipeMapList.remove(recipeMapList[0]);
                      return BaseGridView(
                        values: recipeMapList,
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
