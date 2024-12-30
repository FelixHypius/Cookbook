import 'package:cookbook/util/colors.dart';
import 'package:cookbook/base_widgets/base_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class SpecImagePicker extends StatefulWidget {
  final String? imgUrl;
  const SpecImagePicker({this.imgUrl, super.key});

  @override
  SpecImagePickerState createState() => SpecImagePickerState();
}

class SpecImagePickerState extends State<SpecImagePicker> {
  Uint8List? _image;
  String? imgUrl;
  final picker = ImagePicker();

  @override
  void initState(){
    super.initState();
    imgUrl = widget.imgUrl;
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _image = bytes;
      });
    }
  }

  Uint8List? get image => _image;

  String? get url => imgUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if(_image!=null)
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.memory(
              _image!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          )
        else if(imgUrl!=null && _image==null)
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              imgUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            )
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