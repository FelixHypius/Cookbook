import 'package:cookbook/base_widgets/base_input_field.dart';
import 'package:cookbook/util/colors.dart';
import 'package:cookbook/util/custom_snackbar.dart';
import 'package:cookbook/util/custom_text_style.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../base_widgets/base_loading_page.dart';
import '../base_widgets/base_scaffold.dart';
import '../base_widgets/base_drawer.dart';
import '../base_widgets/base_bottom_navigation_bar.dart';
import '../base_widgets/base_button.dart';
import '../util/custom_page_route.dart';
import '../util/input_checks.dart';
import '../database/database_service.dart';
import '../specific_widgets/specific_image_picker.dart';

class AddSectionPage extends StatefulWidget{

  const AddSectionPage({super.key});

  @override
  AddSectionPageState createState() => AddSectionPageState();
}

class AddSectionPageState extends State<AddSectionPage> {
  InputCheck check = InputCheck();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<SpecImagePickerState> _imagePickerKey = GlobalKey<SpecImagePickerState>();
  final TextEditingController _nameController = TextEditingController();
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
    // Try to upload => Transfer to loading page.
    final String title = _nameController.text;
    final String? imageUrl = (_imagePickerKey.currentState as SpecImagePickerState).url;
    final Uint8List? imageList = (_imagePickerKey.currentState as SpecImagePickerState).image;

    final result = await Navigator.push(
        context,
        CustomPageRoute(
            page: BaseLoadingPage(
              context: context,
              kind: 'section',
              imageUrl: imageUrl,
              imageList: imageList,
              title: title,
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
        currentIndex: 6,
      ),
      bottomnavigationbar: BaseBottomNavigationBar(
        initialSelectedIndex: 0,
        currentIndex: 6,
        scaffoldKey: _scaffoldKey,
      ),
      body: SingleChildScrollView(
          child: Column(
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
                  child: SpecImagePicker(key: _imagePickerKey,),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: BaseInputField(
                  control: _nameController,
                  hintText: 'Enter section title',
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
      ),
    );
  }
}