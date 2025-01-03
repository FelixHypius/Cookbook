import 'package:cookbook/base_widgets/base_future_builder.dart';
import 'package:cookbook/base_widgets/base_input_field.dart';
import 'package:cookbook/util/colors.dart';
import 'package:cookbook/util/custom_snackbar.dart';
import 'package:cookbook/util/custom_text_style.dart';
import 'package:cookbook/util/navigation.dart';
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
import '../util/image_compression.dart' as comp;

class EditRecipePage extends StatefulWidget{
  final int recipeId;
  const EditRecipePage({super.key, required this.recipeId});

  @override
  EditRecipePageState createState() => EditRecipePageState();
}

class EditRecipePageState extends State<EditRecipePage> {
  InputCheck check = InputCheck();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<SpecImagePickerState> _imagePickerKey = GlobalKey<SpecImagePickerState>();
  final GlobalKey<SpecIngredientListState> _ingredientListKey = GlobalKey<SpecIngredientListState>();
  final GlobalKey<SpecSectionDropdownButtonState> _sectionDropdownKey = GlobalKey<SpecSectionDropdownButtonState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _recipeController = TextEditingController();
  final DatabaseService dbs = DatabaseService();
  bool _isLoading = false;
  int recipeId = -1;

  @override
  void initState(){
    super.initState();
    recipeId = widget.recipeId;
  }

  Future<void> _save() async {
    setState(() {
      _isLoading = true;
    });

    // Ensure recipe has title.
    if (check.isText(_nameController.text) &&
        (_sectionDropdownKey.currentState as SpecSectionDropdownButtonState).selectedSection != null &&
        !((_imagePickerKey.currentState as SpecImagePickerState).image == null && (_imagePickerKey.currentState as SpecImagePickerState).url == null) &&
        _recipeController.text!='')  {
      // Ensure all controllers are closed.
      if ((_ingredientListKey.currentState as SpecIngredientListState).save()) {
        // Save to db.
        String title = _nameController.text;
        List<Map<String,String>> ingredientList = (_ingredientListKey.currentState as SpecIngredientListState).inputs;
        String section = (_sectionDropdownKey.currentState as SpecSectionDropdownButtonState).selectedSection!;
        String description = _recipeController.text;
        if ((_imagePickerKey.currentState as SpecImagePickerState).image != null) {
          String? imageUrl = await uploadImage();
          if (imageUrl != null) {
            dbs.editRecipe(title: title, img: imageUrl, ing: ingredientList, sec: section, description: description, recipeID: recipeId);
            setState(() {
              _isLoading = false;
            });
            navigateToPage(context, 1, 7);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar(
                    'Your image could not be uploaded.'
                )
            );
          }
        } else {
          String oldUrl = (_imagePickerKey.currentState as SpecImagePickerState).url!;
          dbs.editRecipe(title: title, img: (oldUrl), ing: ingredientList, sec: section, description: description, recipeID: recipeId);
          setState(() {
            _isLoading = false;
          });
          navigateToPage(context, 1, 7);
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } else if ((_sectionDropdownKey.currentState as SpecSectionDropdownButtonState).selectedSection == null) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
            'Please select a valid recipe section.'
        ),
      );
    } else if ((_imagePickerKey.currentState as SpecImagePickerState).image == null && (_imagePickerKey.currentState as SpecImagePickerState).url == null) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
            'Please upload a picture for your recipe.'
        ),
      );
    } else if (_recipeController.text == '') {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
            'Please provide a recipe instruction.'
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
            'Please enter a valid recipe title.'
        ),
      );
    }
  }

  Future<String?> uploadImage() async {
    final imagePickerState = _imagePickerKey.currentState;
    if (imagePickerState?.image == null) return null;

    try {
      final compressedImage = await comp.compress(imagePickerState!.image!, 204800);
      return dbs.uploadImg(compressedImage, category: "recipes");
    } catch (e) {
      print('Error uploading image: ${e.toString()}');
      return null;
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
              if(_nameController.text.isEmpty) {
                _nameController.text = recipeMap['title'];
              }
              if(_recipeController.text.isEmpty) {
                _recipeController.text = recipeMap['description'];
              }
              return Stack(
                children: [
                  Column(
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
                  ),
                  if (_isLoading)
                    Positioned.fill(
                      child: Container(
                        color: MyColors.myBlack,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircularProgressIndicator(color: MyColors.myRed, strokeWidth: 5,),
                            Text('Waiting for recipe upload', style: CustomTextStyle(size: 20, colour: MyColors.myRed))
                          ],
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