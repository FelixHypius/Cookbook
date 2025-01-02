import 'package:cookbook/base_widgets/base_button.dart';
import 'package:cookbook/util/colors.dart';
import 'package:cookbook/util/custom_text_style.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import '../util/patch_notes.dart';

class UpdatesInfo extends StatelessWidget {
  UpdatesInfo({super.key});

  final patch = PatchNotes();
  
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      color: MyColors.myBlack,
      child: SafeArea(
          minimum: EdgeInsets.only(top: 80, left: 15, right: 15, bottom: 30),
          child: Container(
            color: MyColors.myBlack,
            child: Column(
              children: [
                Text(
                  'Patch notes',
                  style: CustomTextStyle(size: width/10),
                ),
                Text(
                  patch.version,
                  style: CustomTextStyle(size: width/25),
                ),
                SizedBox(
                  height: 20,
                ),
                Flexible(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Text(
                      patch.patchNotes,
                      style: CustomTextStyle(size: width/20),
                      textAlign: TextAlign.justify,

                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                BaseButton(
                  icon: Icon(
                    Icons.check_rounded,
                    color: MyColors.myWhite,
                  ),
                  text: Text(
                    'Understood.',
                    style: CustomTextStyle(size: width/20),
                  ),
                  border: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.5)),
                  length: MainAxisSize.min,
                  padding: EdgeInsets.only(left: 7, right: 10, top: 3, bottom: 3),
                  sizeSpace: 4,
                  func: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Homepage()),
                    );
                  },
                )
              ],
            ),
          )
      ),
    );
  }
}