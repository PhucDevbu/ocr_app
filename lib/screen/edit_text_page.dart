import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditTextPage extends StatefulWidget {
  final TextEditingController controller;

  const EditTextPage({super.key, required this.controller});

  @override
  State<EditTextPage> createState() => _EditTextPageState();
}

class _EditTextPageState extends State<EditTextPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Text'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: TextStyle(fontSize: 16.sp),
                controller: widget.controller,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Edit Text',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Return the edited text to the previous screen
          Navigator.pop(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
