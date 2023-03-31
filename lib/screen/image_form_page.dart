import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocr_app/model/image.dart';
import 'package:provider/provider.dart';

import '../provider/image_file_provider.dart';
import '../widget/image_input.dart';

class ImageFormPage extends StatefulWidget {
  static const routeName = "ImageFormPage";
  const ImageFormPage({super.key});

  @override
  State<ImageFormPage> createState() => _ImageFormPageState();
}

class _ImageFormPageState extends State<ImageFormPage> {
  final _titleController = TextEditingController();
  File savedImage = File("");
  void savedImages(File image) {
    savedImage = image;
  }

  void onSave() {
    if (_titleController.text.isEmpty || savedImage == null) {
      return;
    } else {
      Provider.of<ImageFile>(context, listen: false)
          .addImagePlace(_titleController.text, savedImage);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Form'),
        actions: [IconButton(onPressed: onSave, icon: Icon(Icons.save))],
      ),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.all(16.sp),
          child: TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp),
          child: ImageInput(
            imageSaveAt: savedImages,
          ),
        )
      ]),
    );
  }
}
