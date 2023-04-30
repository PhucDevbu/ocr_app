import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../model/image_app.dart';
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
        actions: [
          IconButton(
              onPressed: () => _uploadImageToFirebase(context, savedImage),
              icon: Icon(Icons.save))
        ],
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

  Future<void> _uploadImageToFirebase(
      BuildContext context, File imageFile) async {
    // Hiển thị Dialog với CircularProgressIndicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20.0),
                Text('Uploading image...'),
              ],
            ),
          ),
        );
      },
    );

    // Tải lên ảnh lên Firebase Storage
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child("profilepictures")
        .child(Uuid().v1());
    UploadTask uploadTask = storageReference.putFile(imageFile);
    TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() => print('Image uploaded'));

    // Đóng Dialog

    // Lấy URL của tệp tin ảnh đã tải lên
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    print('Download URL: $downloadUrl');
    ImageApp imageApp = ImageApp(
        title: _titleController.text,
        url: downloadUrl,
        createAt: DateTime.now().toString(),
        uId: FirebaseAuth.instance.currentUser!.uid);
    FirebaseFirestore.instance.collection("images").add(imageApp.toMap());
    Fluttertoast.showToast(msg: 'Up Success');
    Navigator.pop(context);
    Navigator.pop(context);
    // Thực hiện các thao tác tiếp theo với URL của tệp tin ảnh đã tải lên
  }
}
