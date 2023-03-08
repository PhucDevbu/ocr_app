import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ocr_app/model/database.dart';

class MyImage {
  int? id;
  final String title;
  final File image;

  MyImage({this.id, required this.title, required this.image});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image.path,
    };
  }

  static MyImage fromMap(Map<String, dynamic> map) {
    return MyImage(
        id: map['id'], title: map['title'], image: File(map['image']));
  }
}

class ImageFile with ChangeNotifier {
  List<MyImage> _items = [];
  List<MyImage> get items {
    return [..._items];
  }

  Future<void> addImagePlace(String title, File image) async {
    final newImage = MyImage(image: image, title: title);
    _items.add(newImage);
    notifyListeners();
    DataHelper.insert("images", newImage.toMap());
  }

  MyImage findImage(String imageId) {
    return _items.firstWhere((image) => image.id == imageId);
  }

  Future<void> fetchImage() async {
    final list = await DataHelper.getData('images');
    _items =
        List.generate(list.length, (index) => MyImage.fromMap(list[index]));
    notifyListeners();
  }

  Future<void> deleteImage(MyImage image) async {
    await DataHelper.deleteImage('images', image.id ?? 0);
    // _items.removeWhere((item) => item.id == image.id);
    fetchImage();
    notifyListeners();
  }
}
