import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docx_template/docx_template.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:ocr_app/screen/text_to_speech_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../model/result.dart';
import 'edit_text_page.dart';

class DetailsResult extends StatefulWidget {
  final RecognizedText recognizedText;
  const DetailsResult({super.key, required this.recognizedText});

  @override
  State<DetailsResult> createState() => _DetailsResultState();
}

class _DetailsResultState extends State<DetailsResult> {
  late TextEditingController _textController;
  late TextEditingController _dialogController;
  @override
  void initState() {
    _textController = TextEditingController();
    String resultText = '';
    for (TextBlock block in widget.recognizedText.blocks) {
      for (TextLine line in block.lines) {
        resultText += line.text + '\n';
      }
    }

    _textController.text = resultText;
    _dialogController = TextEditingController();
    if (_textController.text != "") {
      Result result = Result(
          text: _textController.text,
          url: "",
          createAt: DateTime.now().toString(),
          uId: FirebaseAuth.instance.currentUser!.uid);
      FirebaseFirestore.instance.collection("results").add(result.toMap());
    }

    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _dialogController.dispose();
    super.dispose();
  }

  Future<void> shareTxtFile(String content, String name) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$name.txt');
    await file.writeAsString(content);
    await Share.shareFiles([file.path], text: 'Share via');
  }

  Future<void> shareWordFile(String content, String name) async {
    final data = await rootBundle.load('assets/template.docx');
    final bytes = data.buffer.asUint8List();

    final template = await DocxTemplate.fromBytes(bytes);
    Content c = Content();
    c.add(TextContent("docname", content));
    final d = await template.generate(c);
    final directory = await getApplicationDocumentsDirectory();
    final of = File('${directory.path}/$name.docx');
    if (d != null) await of.writeAsBytes(d);
    await Share.shareFiles([of.path], text: 'Share Word file');
  }

  Future<void> editText() async {
    // Navigate to a new screen where the user can edit the text
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTextPage(controller: _textController),
      ),
    ).then((value) => setState(() {}));

    // Update the text with the new value returned from the editor screen
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text("Result")),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    _textController.text,
                    style: TextStyle(fontSize: 16.sp),
                    maxLines: null,
                  ),
                  ElevatedButton(
                    onPressed: editText,
                    child: const Text('Edit Text'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(
                              ClipboardData(text: _textController.text))
                          .then((value) {
                        // Thông báo copy thành công
                        Fluttertoast.showToast(msg: 'Copied to clipboard');
                      });
                    },
                    child: const Text('Copy'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TextToSpeechPage(
                            text: _textController.text,
                          ),
                        ),
                      );
                    },
                    child: const Text('Text to speech'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Enter Name File'),
                            content: TextField(
                              controller: _dialogController,
                              decoration:
                                  InputDecoration(hintText: "Enter text here"),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  shareTxtFile(_textController.text,
                                      _dialogController.text);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Text to txt'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Enter Name File'),
                            content: TextField(
                              controller: _dialogController,
                              decoration:
                                  InputDecoration(hintText: "Enter text here"),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  shareWordFile(_textController.text,
                                      _dialogController.text);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Text to word'),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
