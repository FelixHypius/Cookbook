import 'dart:typed_data';
import 'package:cookbook/base_widgets/base_future_builder.dart';
import 'package:cookbook/base_widgets/base_input_field.dart';
import 'package:cookbook/base_widgets/base_loading_page.dart';
import 'package:cookbook/util/colors.dart';
import 'package:cookbook/util/custom_page_route.dart';
import 'package:cookbook/util/custom_snackbar.dart';
import 'package:cookbook/util/custom_text_style.dart';
import 'package:flutter/material.dart';
import '../base_widgets/base_scaffold.dart';
import '../base_widgets/base_drawer.dart';
import '../base_widgets/base_bottom_navigation_bar.dart';
import '../specific_widgets/specific_ingredient_list.dart';
import '../base_widgets/base_button.dart';
import '../util/input_checks.dart';
import '../database/database_service.dart';
import '../specific_widgets/specific_section_dropdown_button.dart';
import '../specific_widgets/specific_image_picker.dart';

class EditRecipePage extends StatefulWidget{
  final int recipeId;
  const EditRecipePage({super.key, required this.recipeId});

  @override
  EditRecipePageState createState() => EditRecipePageState();
}

class EditRecipePageState extends State<EditRecipePage> {
  final InputCheck check = InputCheck();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<SpecImagePickerState> _imagePickerKey = GlobalKey<SpecImagePickerState>();
  final GlobalKey<SpecIngredientListState> _ingredientListKey = GlobalKey<SpecIngredientListState>();
  final GlobalKey<SpecSectionDropdownButtonState> _sectionDropdownKey = GlobalKey<SpecSectionDropdownButtonState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _recipeController = TextEditingController();
  final DatabaseService dbs = DatabaseService();

  void display (String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(message)
    );
  }

  Future<void> _save() async {
    // Ensure all inputs are correct.
    if (!check.isText(_nameController.text)) {
      display('Please enter a valid recipe title.');
      return;
    }
    if (((_imagePickerKey.currentState as SpecImagePickerState).image == null &&
        (_imagePickerKey.currentState as SpecImagePickerState).url == null)){
      display('Please upload a picture for your recipe.');
      return;
    }
    if (!(_ingredientListKey.currentState as SpecIngredientListState).save()) {
      // Errors given in method.
      return;
    }
    if (_recipeController.text=='' || _recipeController.text.isEmpty) {
      display('Please provide a recipe instruction.');
      return;
    }
    if ((_sectionDropdownKey.currentState as SpecSectionDropdownButtonState).selectedSection == null) {
      display('Please select a valid recipe section.');
      return;
    }
    // Try to upload => Transfer to loading page.
    final String title = _nameController.text;
    final List<Map<String,String>> ingredientList = (_ingredientListKey.currentState as SpecIngredientListState).inputs;
    final String section = (_sectionDropdownKey.currentState as SpecSectionDropdownButtonState).selectedSection!;
    final String description = _recipeController.text;
    final String? imageUrl = (_imagePickerKey.currentState as SpecImagePickerState).url;
    final Uint8List? imageList = (_imagePickerKey.currentState as SpecImagePickerState).image;
    final int recId = widget.recipeId;

    final result = await Navigator.push(
      context,
      CustomPageRoute(
        page: BaseLoadingPage(
          context: context,
          kind: 'recipe',
          imageUrl: imageUrl,
          imageList: imageList,
          title: title,
          ingredientList: ingredientList,
          description: description,
          section: section,
          recId: recId,
        ),
        direction: 'none'
      )
    );
    if (result != null && result is String) {
      display(result);
    }
  }


  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      scaffoldKey: _scaffoldKey,
      drawer: BaseDrawer(
        scaffoldKey: _scaffoldKey,
        currentIndex: 7,
      ),
      bottomnavigationbar: BaseBottomNavigationBar(
        initialSelectedIndex: 0,
        currentIndex: 7,
        scaffoldKey: _scaffoldKey,
      ),
      body: SingleChildScrollView(
          child: BaseFutureBuilder(
            func: dbs.get('recipes/${widget.recipeId.toString()}'),
            build: (context, recipeMap) {
              _nameController.text = recipeMap['title'];
              _recipeController.text = recipeMap['description'];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: MyColors.myBlack,
                          border: Border.all(
                              color: MyColors.myGrey,
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: SpecImagePicker(key: _imagePickerKey, imgUrl: recipeMap['imageUrl'],),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: BaseInputField(
                      control: _nameController,
                      hintText: 'Enter recipe title',
                      fillColour: MyColors.myBlack,
                      normalColour: MyColors.myBlack,
                      focusedColour: MyColors.myBlack,
                      textColour: MyColors.myWhite,
                      textAlignment: TextAlign.center,
                      textSize: 20,
                      paddingHeight: 5,
                      hintColour: MyColors.myGrey,
                      maxRows: 1,
                    ),
                  ),
                  SizedBox(
                      height: 20
                  ),
                  Divider(
                    color: MyColors.myGrey,
                    thickness: 2,
                    height: 5,
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 15, left: 5, right: 5, bottom: 15),
                      child: SpecIngredientList(key: _ingredientListKey, ingredients: recipeMap['ingredients'])
                  ),
                  Divider(
                    color: MyColors.myGrey,
                    thickness: 2,
                    height: 5,
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 5, right: 5, bottom: 15),
                      child: BaseInputField(
                        hintText: 'Please enter the steps for your recipe..',
                        control: _recipeController,
                        fillColour: MyColors.myBlack,
                        focusedColour: MyColors.myBlack,
                        normalColour: MyColors.myBlack,
                        textColour: MyColors.myWhite,
                        maxRows: null,
                      )
                  ),
                  Divider(
                    color: MyColors.myGrey,
                    thickness: 2,
                    height: 0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5, right: 5, top: 10),
                    child: SpecSectionDropdownButton(key: _sectionDropdownKey, preSelectionId: recipeMap['section'].toString(),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5, right: 5, top: 20),
                    child: SizedBox(
                      width: 70,
                      height: 30,
                      child: BaseButton(
                        func: _save,
                        icon: Icon(Icons.save_rounded, size: 25, color: MyColors.myWhite,),
                        text: Text('save', style: CustomTextStyle(size: 15, tallness: 2), textAlign: TextAlign.center,),
                        border: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.5)
                        ),
                        align: MainAxisAlignment.start,
                        padding: EdgeInsets.only(left: 5),
                        sizeSpace: 2,
                      ),
                    ),
                  )
                ],
              );
            }
          )

      ),
    );
  }
}