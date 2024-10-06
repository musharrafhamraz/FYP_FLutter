import 'package:dtreatyflutter/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'treatment_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
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
      model: "assets/models/model_unquant.tflite",
      labels: "assets/models/labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
    print(res);
  }

  Future<void> _classifyImage(String path) async {
    var recognitions = await Tflite.runModelOnImage(
      path: path,
      numResults: 5,
    );
    setState(() {
      if (recognitions?.isNotEmpty == true) {
        double confidence = recognitions!.first['confidence'];
        if (confidence > 0.7) {
          // Set an appropriate confidence threshold
          _prediction = recognitions.first['label'];
        } else {
          _prediction = 'Not A Leaf';
        }
      } else {
        _prediction = 'No Prediction';
      }
    });
    if (_prediction == 'Not A Leaf' || _prediction == 'No Prediction') {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: Colors.amber[400],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Warning!',
                    style: TextStyle(color: Colors.amber),
                  ),
                ],
              ),
              content: const Text(
                'I only work with leaves.',
                style: TextStyle(
                    color: Color.fromRGBO(239, 181, 6, 1),
                    fontWeight: FontWeight.w500),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.amber),
                  ),
                )
              ],
            );
          });
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              prediction: _prediction ?? 'No Prediction',
              imagePath: path,
            ),
          ));
    }
  }

  Future<void> _captureAndClassify() async {
    try {
      final image = await _controller?.takePicture();
      if (image != null) {
        await _classifyImage(image.path);
      }
    } catch (e) {
      print(e);
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
      appBar: AppBar(
        title: Text(
          'D t r e a t y',
          style: GoogleFonts.openSans(
              textStyle:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 25)),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            icon: const Icon(Icons.arrow_back_ios_new_sharp)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
            Center(
                child: SpinKitWaveSpinner(
              color: const Color(0xFF2A9D2E),
              waveColor: Colors.green,
              trackColor: Colors.green.shade200,
              size: 70,
            )),
          const SizedBox(
            height: 20,
          ),
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
    );
  }
}
