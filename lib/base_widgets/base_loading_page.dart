import 'package:flutter/material.dart';
import '../database/database_service.dart';
import '../pages/home.dart';
import '../util/colors.dart';
import '../util/custom_page_route.dart';
import '../util/custom_text_style.dart';
import '../util/input_checks.dart';
import 'base_bottom_navigation_bar.dart';
import 'base_drawer.dart';
import 'base_scaffold.dart';
import 'dart:typed_data';
import '../util/image_compression.dart' as comp;

class BaseLoadingPage extends StatelessWidget {
  final InputCheck check = InputCheck();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DatabaseService dbs = DatabaseService();
  // Initialize variables to check.
  final String? imageUrl;
  final Uint8List? imageList;
  final String title;
  final List<Map<String,String>>? ingredientList;
  final String? description;
  final String? section;
  final int? secId;
  final int? recId;
  // Context
  final BuildContext context;
  final String kind;

  BaseLoadingPage({
    super.key,
    required this.title,
    required this.context,
    required this.kind,
    this.recId,
    this.secId,
    this.ingredientList,
    this.description,
    this.section,
    this.imageUrl,
    this.imageList
  });

  Future<String> _uploadImg(String category, int? id) async {
    String cCategory = '${category}s';
    String url = '';
    // If imageList, try to upload
    if (imageList != null) {
      final compressedImage = await comp.compress(imageList!, 204800);
      if (id == null) {
        url = await dbs.uploadImg(compressedImage, category: cCategory);
      } else {
        url = await dbs.uploadImg(compressedImage, category: cCategory, id: id);
      }
      if (url.contains('Upload failed with state')) {
        failed(url);
      }
      return url;
    } else if (imageUrl != null){
      url = imageUrl!;
    }
    return url;
  }

  void failed (String error) {
    Navigator.pop(context, error);
  }
  
  Future<void> save() async {
    String result = '';
    // Try uploading recipe/section.
    if (kind == 'recipe') {
      // Try uploading image.
      final url = await _uploadImg(kind, recId);
      // Differentiate between editing and creating.
      if (recId != null) {
        result = await dbs.editRecipe(title: title, img: url, recipeID: recId!, sec: section!, ing: ingredientList!, description: description!);
      } else {
        result = await dbs.uploadRecipe(title: title, img: url, ing: ingredientList!, description: description!, sec: section!);
      }
    } else if (kind == 'section') {
      // Try uploading image.
      final url = await _uploadImg(kind, secId);
      // Differentiate between editing and creating.
      if (secId != null) {
        result = await dbs.editSection(title: title, img: url, sectionId: secId!);
      } else {
        result = await dbs.uploadSection(title: title, img: url);
      }
    }
    // Handle errors.
    if (result == 'success') {
      // Navigate to homepage
      Navigator.pushAndRemoveUntil(
        context,
        CustomPageRoute(page: const Homepage(), direction: 'none'),
            (route) => false,  // This will remove all previous routes
      );
    } else {
      failed(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    save();
    return BaseScaffold(
        scaffoldKey: _scaffoldKey,
        drawer: BaseDrawer(
          scaffoldKey: _scaffoldKey,
          currentIndex: 11,
        ),
        bottomnavigationbar: BaseBottomNavigationBar(
          initialSelectedIndex: 0,
          currentIndex: 11,
          scaffoldKey: _scaffoldKey,
        ),
        body: Center(
          child: Container(
            color: MyColors.myBlack,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircularProgressIndicator(color: MyColors.myRed, strokeWidth: 5,),
                Text('Waiting for upload..', style: CustomTextStyle(size: 20, colour: MyColors.myRed))
              ],
            ),
          ),
        )
    );
  }
}