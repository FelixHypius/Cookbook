import 'package:cookbook/base_widgets/base_future_builder.dart';
import 'package:cookbook/base_widgets/base_table.dart';
import 'package:cookbook/database/database_service.dart';
import 'package:cookbook/base_widgets/base_shade.dart';
import 'package:cookbook/util/colors.dart';
import 'package:cookbook/util/custom_text_style.dart';
import 'package:flutter/material.dart';
import '../base_widgets/base_scaffold.dart';
import '../base_widgets/base_drawer.dart';
import '../base_widgets/base_bottom_navigation_bar.dart';
import '../util/navigation.dart';

class RecipePage extends StatefulWidget{
  final int recipeId;
  const RecipePage({super.key, required this.recipeId});

  @override
  RecipePageState createState() => RecipePageState();
}

class RecipePageState extends State<RecipePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DatabaseService dbs = DatabaseService();

  List<dynamic> formatEntries(List<dynamic> ingredients) {
    List<dynamic> entries = [];
    for (var ingredient in ingredients) {
      String qtyUnit = '${ingredient['qtyT']} ${ingredient['unitT']}';
      String ingredientName = ingredient['ingT'];
      entries.add([qtyUnit, ingredientName]);
    }
    return entries;
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
        initialSelectedIndex: 1,
        currentIndex: 5,
        scaffoldKey: _scaffoldKey,
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
            Navigator.pop(context);
          }
        },
        child: SingleChildScrollView(
            child: BaseFutureBuilder(
              func: dbs.get('recipes/${widget.recipeId.toString()}'),
              build: (context, recipeMap) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: MyColors.myBlack,
                          border: Border.all(
                            color: MyColors.myWhite,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.network(
                                  recipeMap['imageUrl'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: SpecShade(
                                  fade: 0.3,
                                  size: 0.2,
                                  rise: 0,
                                  colour: MyColors.myBlack,
                                ),
                              ),
                            ),
                          ],
                        )
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 15),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            recipeMap['title'],
                            style: CustomTextStyle(size: 20),
                          ),
                        )
                    ),
                    Divider(
                      color: MyColors.myWhite,
                      thickness: 2,
                      height: 5,
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 15, left: 5, right: 5, bottom: 5),
                        child: BaseTable(
                          entries: formatEntries(recipeMap['ingredients']),
                          colSize: [1, 2.5],
                          spaceAfter: 10,
                        ),
                    ),
                    Divider(
                      color: MyColors.myWhite,
                      thickness: 2,
                      height: 5,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 5, top: 15),
                        child: Text(
                          recipeMap['description'].replaceAll(r'\n', '\n'),
                          style: CustomTextStyle(size: 15),
                        )
                    ),
                  ],
                );
              },
            )
        ),
      )
    );
  }
}