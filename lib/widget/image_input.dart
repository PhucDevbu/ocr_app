import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageInput extends StatefulWidget {
  final Function imageSaveAt;
  const ImageInput({super.key, required this.imageSaveAt});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _imageFile;
  Future<void> _takePhoto() async {
    final ImagePicker _picker = ImagePicker();
    XFile? imageFile = await _picker.pickImage(source: ImageSource.camera);
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    if (imageFile == null) {
      return;
    }
    setState(() {
      _imageFile = File(imageFile.path);
    });
    final fileName = path.basename(imageFile.path);
    final saveImagepath =
        await _imageFile?.copy('${documentsDirectory.path}/$fileName');
    widget.imageSaveAt(saveImagepath);
  }

  Future<void> _takeImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    if (imageFile == null) {
      return;
    }
    setState(() {
      _imageFile = File(imageFile.path);
    });
    final fileName = path.basename(imageFile.path);
    final saveImagepath =
        await _imageFile?.copy('${documentsDirectory.path}/$fileName');
    widget.imageSaveAt(saveImagepath);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200.h,
          width: 325.w,
          decoration: BoxDecoration(
              border: Border.all(width: 2.w, color: Colors.black)),
          child: _imageFile != null
              ? Image.file(
                  _imageFile!,
                  fit: BoxFit.cover,
                )
              : Center(
                  child: Text('Add image'),
                ),
        ),
        TextButton.icon(
          onPressed: _takeImage,
          icon: Icon(Icons.image),
          label: Text('Add image from galery'),
        ),
        TextButton.icon(
          onPressed: _takePhoto,
          icon: Icon(Icons.camera),
          label: Text('Add image from camera'),
        )
      ],
    );
  }
}
