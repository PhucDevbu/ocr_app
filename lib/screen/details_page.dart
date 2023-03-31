import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ocr_app/main.dart';
import 'package:ocr_app/model/image.dart' as ima;
import 'package:ocr_app/screen/text_to_speech_page.dart';

import 'edit_text_page.dart';

class DetailsPage extends StatefulWidget {
  static const routeName = 'DetailsPage';
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late TextEditingController _textController;
  late quill.QuillController _controller;
  quill.Delta _delta = quill.Delta()..insert('');
  @override
  void initState() {
    _textController = TextEditingController();
    _controller = quill.QuillController(
      document:
          quill.Document.fromDelta(_delta.concat(quill.Delta()..insert('\n'))),
      selection: TextSelection.collapsed(offset: _delta.length),
    );
    super.initState();
  }

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
      _delta = quill.Delta()..insert(_textController.text);
      _controller.document =
          quill.Document.fromDelta(_delta.concat(quill.Delta()..insert('\n')));
    }
  }

  Future<void> editText() async {
    // Navigate to a new screen where the user can edit the text
    final List<dynamic>? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTextPage(controller: _controller),
      ),
    );

    // Update the text with the new value returned from the editor screen
    if (result != null) {
      setState(() {
        _delta = quill.Delta.fromJson(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageId = ModalRoute.of(context)?.settings.arguments as ima.MyImage;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
            // TextField(
            //   style: TextStyle(fontSize: 12.sp),
            //   controller: _textController,
            //   maxLines: null,
            //   decoration: InputDecoration(
            //     hintText: 'Recognized Text',
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: quill.QuillEditor.basic(
                controller: _controller,
                readOnly: true, // true for view only mode
              ),
            ),
            ElevatedButton(
              onPressed: editText,
              child: Text('Advanced Text Editor'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TextToSpeechPage(text: _controller.document.toPlainText(),),
                  ),
                );
              },
              child: Text('Text to speech'),
            ),
          ]),
        ),
      ),
    );
  }
}
