import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import '../model/database.dart';
import '../model/image_app.dart';

class ImageFile with ChangeNotifier {
  // List<MyImage> _items = [];
  // List<MyImage> get items {
  //   return [..._items];
  // }

  // Future<void> addImagePlace(String title, File image) async {
  //   final newImage = MyImage(image: image, title: title);
  //   _items.add(newImage);
  //   notifyListeners();
  //   DataHelper.insert("images", newImage.toMap());
  // }

  // MyImage findImage(String imageId) {
  //   return _items.firstWhere((image) => image.id == imageId);
  // }

  // Future<void> fetchImage() async {
  //   final list = await DataHelper.getData('images');
  //   _items =
  //       List.generate(list.length, (index) => MyImage.fromMap(list[index]));
  //   notifyListeners();
  // }

  // Future<void> deleteImage(MyImage image) async {
  //   await DataHelper.deleteImage('images', image.id ?? 0);
  //   // _items.removeWhere((item) => item.id == image.id);
  //   fetchImage();
  //   notifyListeners();
  // }

  Future<void> saveImage(File image,String title, String createAt,String uId) async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child("profilepictures")
        .child(Uuid().v1())
        .putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    String url = await taskSnapshot.ref.getDownloadURL();

    ImageApp imageApp =
        ImageApp(title: title, url: url, createAt: createAt, uId: uId);
    FirebaseFirestore.instance.collection("image").add(imageApp.toMap());
    Fluttertoast.showToast(msg: 'Up Success');
    notifyListeners();
  }
}
