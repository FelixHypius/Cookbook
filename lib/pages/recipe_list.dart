import 'package:cookbook/database/data_sync_service.dart';
import 'package:cookbook/database/local_database_service.dart';
import 'package:flutter/material.dart';
import '../base_widgets/base_bottom_navigation_bar.dart';
import '../base_widgets/base_button.dart';
import '../base_widgets/base_drawer.dart';
import '../base_widgets/base_scaffold.dart';
import '../base_widgets/base_stream_builder.dart';
import '../util/colors.dart';
import '../util/custom_text_style.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({super.key});

  @override
  RecipeListState createState() => RecipeListState();
}

class RecipeListState extends State<RecipeList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dss = DataSyncService();
  final lDbs = LocalDatabaseService();

  @override
  void initState() {
    super.initState();
    dss.fetchAndListenRecipeList();
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
        currentIndex: 2,
      ),
      bottomnavigationbar: BaseBottomNavigationBar(
        scaffoldKey: _scaffoldKey,
        currentIndex: 2,
        initialSelectedIndex: 2,
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            alignment: Alignment.center,
            child: Text(
              'Recipe list',
              style: CustomTextStyle(size: 40),
              textAlign: TextAlign.center,
            ),
          ),
          Flexible(
            child: BaseStreamBuilder(
              streamm: dss.stream,
              buildd: (context, valueList) {
                if (valueList == null || valueList.isEmpty) {
                  return Center(
                    child: Text(
                      'No recipes in grocery list.',
                      style: CustomTextStyle(size: 15, colour: MyColors.myRed),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: valueList.length,
                  itemBuilder: (context, index) {
                    final value = valueList[index];
                    return Row(
                      children: [
                        SizedBox(width: 15),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            '${value['qty'].toString()}x',
                            style: CustomTextStyle(size: 18),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              value['title'],
                              style: CustomTextStyle(size: 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_rounded,
                            color: MyColors.myRed,
                            size: 25,
                          ),
                          onPressed: () async {
                            await lDbs.removeOrReduceSelection(value['id']);
                            dss.fetchAndListenRecipeList();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          BaseButton(
            func: (){},
            icon: Icon(Icons.shopping_cart_rounded, size: 18, color: MyColors.myWhite,),
            text: Text('create grocery list', style: CustomTextStyle(size: 15, tallness: 2), textAlign: TextAlign.center,),
            border: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.5)
            ),
            align: MainAxisAlignment.end,
            length: MainAxisSize.min,
            padding: EdgeInsets.only(left: 7, right: 7),
            sizeSpace: 4,
          ),
        ],
      )
    );
  }
}
