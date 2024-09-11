// import 'package:dtreatyflutter/pages/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:tflite_v2/tflite_v2.dart';
// import 'treatment_screen.dart';
// import 'package:google_fonts/google_fonts.dart';

// class CameraScreen extends StatefulWidget {
//   const CameraScreen({super.key});
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   CameraController? _controller;
//   List<CameraDescription>? cameras;
//   bool _isCameraInitialized = false;
//   String? _prediction;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//     _loadModel();
//   }

//   Future<void> _initializeCamera() async {
//     cameras = await availableCameras();
//     if (cameras != null && cameras!.isNotEmpty) {
//       _controller = CameraController(cameras![0], ResolutionPreset.high);
//       await _controller?.initialize();
//       setState(() {
//         _isCameraInitialized = true;
//       });
//     }
//   }

//   Future<void> _loadModel() async {
//     String? res = await Tflite.loadModel(
//       model: "assets/models/converted_model.tflite",
//       labels: "assets/models/labels.txt",
//       numThreads: 1,
//       isAsset: true,
//       useGpuDelegate: false,
//     );
//     print(res);
//   }

// // new code
//   // Future<Uint8List> resizeImage(
//   //     Uint8List imageData, int targetWidth, int targetHeight) async {
//   //   final img.Image? image = img.decodeImage(imageData);

//   //   // Ensure the image is not null
//   //   if (image == null) {
//   //     throw Exception('Failed to decode image.');
//   //   }

//   //   // If the image is already the target size, return it directly
//   //   if (image.width == targetWidth && image.height == targetHeight) {
//   //     return imageData;
//   //   }

//   //   // Resize the image while maintaining aspect ratio
//   //   final resizedImage =
//   //       img.copyResize(image, width: targetWidth, height: targetHeight);

//   //   // Convert the resized image back to Uint8List
//   //   return img.encodePng(resizedImage);
//   // }

// // old code

//   Future<void> _classifyImage(String path) async {
//     var recognitions = await Tflite.runModelOnImage(
//       path: path,
//       numResults: 5,
//     );
//     setState(() {
//       _prediction = recognitions?.isNotEmpty == true
//           ? recognitions!.first['label']
//           : 'No Prediction';
//     });
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ResultScreen(
//             prediction: _prediction ?? 'No Prediction',
//             imagePath: path,
//           ),
//         ));
//   }

//   Future<void> _captureAndClassify() async {
//     try {
//       final image = await _controller?.takePicture();
//       if (image != null) {
//         await _classifyImage(image.path);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     Tflite.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Center(
//                   child: Text('Crop Doctor',
//                       style: GoogleFonts.openSans(
//                         textStyle: const TextStyle(
//                             fontSize: 27,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.lightGreen),
//                       )),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 if (_isCameraInitialized && _controller != null)
//                   Center(
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(40.0),
//                       child: SizedBox(
//                         height: MediaQuery.of(context).size.height * 0.73,
//                         width: MediaQuery.of(context).size.width * 0.9,
//                         child: AspectRatio(
//                           aspectRatio: _controller!.value.aspectRatio,
//                           child: CameraPreview(_controller!),
//                         ),
//                       ),
//                     ),
//                   )
//                 else
//                   const Center(child: CircularProgressIndicator()),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 InkWell(
//                   onTap: _captureAndClassify,
//                   child: Container(
//                     height: 80.0,
//                     width: 80.0,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20.0),
//                       color: Colors.black,
//                     ),
//                     child: const Icon(
//                       Icons.camera,
//                       color: Colors.white,
//                       size: 55.0,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Positioned(
//                 top: 13,
//                 left: 13,
//                 child: InkWell(
//                   onTap: () => Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const HomeScreen())),
//                   child: Container(
//                     height: 65.0,
//                     width: 65.0,
//                     decoration: BoxDecoration(
//                       color: Colors.black54,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: const Icon(
//                       Icons.arrow_back_ios_new,
//                       color: Colors.white,
//                       size: 34,
//                     ),
//                   ),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as img;
import 'treatment_screen.dart';
import 'home_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool _isCameraInitialized = false;
  String? _prediction;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _controller = CameraController(cameras![0], ResolutionPreset.high);
      await _controller?.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  Future<void> _loadModel() async {
    String? res = await Tflite.loadModel(
      model: "assets/model/latest_model.tflite",
      labels: "assets/model/labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
    if (res == null || res.isEmpty || res.contains('error')) {
      _showErrorDialog(context, 'Model Loading Failed',
          'The model could not be loaded. Please try again.');
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

  Future<Uint8List> _resizeImage(Uint8List imageData) async {
    final img.Image? image = img.decodeImage(imageData);

    if (image == null) {
      throw Exception('Failed to decode image.');
    }

    final resizedImage = img.copyResize(image, width: 224, height: 224);

    return Uint8List.fromList(img.encodeJpg(resizedImage));
  }

  Future<void> _classifyImage(String path) async {
    final imageBytes = File(path).readAsBytesSync();
    final resizedImageBytes = await _resizeImage(imageBytes);

    var recognitions = await Tflite.runModelOnBinary(
      binary: resizedImageBytes.buffer.asUint8List(),
      numResults: 5,
    );

    setState(() {
      _prediction = recognitions?.isNotEmpty == true
          ? recognitions!.first['label']
          : 'No Prediction';
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          prediction: _prediction ?? 'No Prediction',
          imagePath: path,
        ),
      ),
    );
  }

  Future<void> _captureAndClassify() async {
    try {
      final image = await _controller?.takePicture();
      if (image != null) {
        await _classifyImage(image.path);
      }
    } catch (e) {
      _showErrorDialog(context, 'Model Loading Failed', '$e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text('Crop Doctor',
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightGreen),
                      )),
                ),
                const SizedBox(height: 20),
                if (_isCameraInitialized && _controller != null)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.73,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: CameraPreview(_controller!),
                        ),
                      ),
                    ),
                  )
                else
                  const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 20),
                InkWell(
                  onTap: _captureAndClassify,
                  child: Container(
                    height: 80.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.black,
                    ),
                    child: const Icon(
                      Icons.camera,
                      color: Colors.white,
                      size: 55.0,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 13,
              left: 13,
              child: InkWell(
                onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen())),
                child: Container(
                  height: 65.0,
                  width: 65.0,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
