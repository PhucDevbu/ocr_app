import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import 'package:ocr_app/screen/text_to_speech_page.dart';

import 'edit_text_page.dart';

class DetailsResult extends StatefulWidget {
  final RecognizedText recognizedText;
  const DetailsResult({super.key, required this.recognizedText});

  @override
  State<DetailsResult> createState() => _DetailsResultState();
}

class _DetailsResultState extends State<DetailsResult> {
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

    String resultText = '';
    for (TextBlock block in widget.recognizedText.blocks) {
      for (TextLine line in block.lines) {
        resultText += line.text + '\n';
      }
    }

    _textController.text = resultText;
    _delta = quill.Delta()..insert(_textController.text);
    _controller.document =
        quill.Document.fromDelta(_delta.concat(quill.Delta()..insert('\n')));
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Result")),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: quill.QuillEditor.basic(
                controller: _controller,
                readOnly: true, // true for view only mode
              ),
            ),
            ElevatedButton(
              onPressed: editText,
              child: const Text('Advanced Text Editor'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TextToSpeechPage(
                      text: _controller.document.toPlainText(),
                    ),
                  ),
                );
              },
              child: const Text('Text to speech'),
            ),
          ]),
        ),
      ),
    );
  }
}
