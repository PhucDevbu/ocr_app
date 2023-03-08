import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ocr_app/model/image.dart' as ima;
import 'package:provider/provider.dart';

class DetailsPage extends StatefulWidget {
  static const routeName = 'DetailsPage';
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final _textController = TextEditingController();
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _OCRImage(ima.MyImage imageId) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageId.image.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      final inputImage = InputImage.fromFile(File(croppedFile.path));
      final textRecognizer = GoogleMlKit.vision
          .textRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognisedText =
          await textRecognizer.processImage(inputImage);

      String resultText = '';
      for (TextBlock block in recognisedText.blocks) {
        for (TextLine line in block.lines) {
          resultText += line.text + '\n';
        }
      }

      textRecognizer.close();

      _textController.text = resultText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageId = ModalRoute.of(context)?.settings.arguments as ima.MyImage;
    return Scaffold(
      appBar: AppBar(title: Text(imageId.title)),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2.w, color: Colors.black)),
              child: Image.file(
                imageId.image,
                fit: BoxFit.cover,
              )),
          SizedBox(
            height: 16.h,
          ),
          ElevatedButton(
            onPressed: () => _OCRImage(imageId),
            child: Text('Recognize Text'),
          ),
          SizedBox(height: 16),
          TextField(
            style: TextStyle(fontSize: 12.sp),
            controller: _textController,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Recognized Text',
              border: OutlineInputBorder(),
            ),
          ),
        ]),
      ),
    );
  }
}
