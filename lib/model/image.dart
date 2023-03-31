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

