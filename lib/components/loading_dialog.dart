import 'package:flutter/material.dart';

class LoadingDialog extends StatefulWidget {
  final Future<void> Function() onSave;

  const LoadingDialog({super.key, required this.onSave});

  @override
  LoadingDialogState createState() => LoadingDialogState();
}

class LoadingDialogState extends State<LoadingDialog> {
  bool _isSaving = true;

  @override
  void initState() {
    super.initState();
    _saveData();
  }

  Future<void> _saveData() async {
    await widget.onSave();
    setState(() {
      _isSaving = false;
    });
    Navigator.of(context).pop(); // Close dialog after saving
    Navigator.of(context).pop(); // Close screen after saving
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Thank You\nWe are on it.'),
      content: _isSaving
          ? const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(image: AssetImage('assets/images/comingsoon.png')),
                SizedBox(
                  height: 30,
                ),
                Text('We apologize for keep you waiting..'),
                SizedBox(
                  height: 30,
                ),
                CircularProgressIndicator(),
              ],
            )
          : const Text('Data saved successfully!'),
    );
  }
}
