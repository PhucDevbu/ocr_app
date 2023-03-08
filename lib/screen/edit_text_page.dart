import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class EditTextPage extends StatefulWidget {
  final quill.QuillController controller;

  const EditTextPage({super.key, required this.controller});

  @override
  _EditTextPageState createState() => _EditTextPageState();
}

class _EditTextPageState extends State<EditTextPage> {
  late quill.QuillController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Text'),
      ),
      body: Column(
        children: [
          quill.QuillToolbar.basic(controller: _controller),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: quill.QuillEditor.basic(
                  controller: _controller,
                  readOnly: false, // true for view only mode
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Return the edited text to the previous screen
          Navigator.pop(context, _controller.document.toDelta().toJson());
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
