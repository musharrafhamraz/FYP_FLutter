import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'dart:io';

class PlantDiseaseIdentifier extends StatefulWidget {
  const PlantDiseaseIdentifier({super.key});

  @override
  _PlantDiseaseIdentifierState createState() => _PlantDiseaseIdentifierState();
}

class _PlantDiseaseIdentifierState extends State<PlantDiseaseIdentifier> {
  File? _image;
  String _prediction = '';

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    String? res = await Tflite.loadModel(
      model: "assets/latest_model/model.tflite",
      labels: "assets/model/labelss.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
    if (res == null || res.isEmpty || res.contains('error')) {
      _showErrorDialog(context, 'Model Loading Failed',
          'The model could not be loaded. Please try again.');
    }
  }

  Uint8List imageToByteListUint8(img.Image image, int inputSize) {
    var convertedBytes = Uint8List(1 * 3 * inputSize * inputSize);
    var byteIndex = 0;
    for (var y = 0; y < inputSize; y++) {
      for (var x = 0; x < inputSize; x++) {
        var pixel = image.getBytes();
        convertedBytes[byteIndex++] = pixel[0]; // Red
        convertedBytes[byteIndex++] = pixel[1]; // Green
        convertedBytes[byteIndex++] = pixel[2]; // Blue
      }
    }
    return convertedBytes;
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final img.Image image = img.decodeImage(await imageFile.readAsBytes())!;
      final int inputSize = 224; // Example input size (should match the model)
      final Uint8List preprocessedImage =
          imageToByteListUint8(image, inputSize);

      setState(() {
        _image = imageFile;
      });

      _predictImage(preprocessedImage);
    }
  }

  Future<void> _predictImage(Uint8List imageBytes) async {
    var output = await Tflite.runModelOnBinary(
      binary: imageBytes,
      numResults: 5,
      threshold: 0.5,
      asynch: true,
    );

    if (output != null && output.isNotEmpty) {
      setState(() {
        _prediction = output.first['label'];
      });
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Disease Identifier'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _image == null ? Text('No image selected.') : Image.file(_image!),
          SizedBox(height: 20),
          Text(
            _prediction.isEmpty ? 'Prediction will appear here.' : _prediction,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Pick Image'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
