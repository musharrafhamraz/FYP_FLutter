import 'package:dtreatyflutter/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'treatment_screen.dart';
import 'package:google_fonts/google_fonts.dart';

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
      model: "assets/latest_model/model.tflite",
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
        ));
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
          'Dtreaty',
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
            const Center(child: CircularProgressIndicator()),
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
