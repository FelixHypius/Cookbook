import 'dart:io';

import 'package:cookbook/util/colors.dart';
import 'package:cookbook/base_widgets/base_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';

class SpecImagePicker extends StatefulWidget {
  const SpecImagePicker({super.key});

  @override
  SpecImagePickerState createState() => SpecImagePickerState();
}

class SpecImagePickerState extends State<SpecImagePicker> {
  File? _image;
  final picker = ImagePicker();

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  File? get image {
    if (_image!=null) {
      return _image;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if(_image!=null)
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.file(
              _image!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          )
        else
          SizedBox(),
        SizedBox(
          height: 80,
          width: 80,
          child: CustomButton(
            func: getImageFromGallery,
            icon: Icon(Icons.add_rounded, size: 80, color: MyColors.myWhite,),
            thickness: 6,
          ),
        )
      ],
    );
  }
}