import 'dart:convert';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dtreatyflutter/data_storage/data_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ResultScreen extends StatefulWidget {
  final String prediction;
  final String imagePath;

  const ResultScreen({
    super.key,
    required this.prediction,
    required this.imagePath,
  });

  @override
  ResultScreenState createState() => ResultScreenState();
}

class ResultScreenState extends State<ResultScreen> {
  List<dynamic>? diseasesData;
  // bool saving = false;

  @override
  void initState() {
    super.initState();
    _loadDiseasesData();
  }

  Future<void> _loadDiseasesData() async {
    String jsonText = await rootBundle.loadString('assets/treatments.json');
    List<dynamic> data = json.decode(jsonText);
    setState(() {
      diseasesData = data;
    });
  }

  Map<String, dynamic>? findDiseaseByName(String name) {
    return diseasesData?.firstWhere(
        (element) => element['disease_name'] == name,
        orElse: () => null);
  }

  @override
  Widget build(BuildContext context) {
    if (diseasesData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    Map<String, dynamic>? disease = findDiseaseByName(widget.prediction);
    if (disease == null) {
      return Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Image.file(
                File(widget.imagePath),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 25.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('No information found for ${widget.prediction}',
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              fontSize: 24.0, color: Colors.white),
                        )),
                    const SizedBox(height: 8.0),
                    Text(
                        DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              fontSize: 16.0, color: Colors.white),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    String symptoms = disease['symptoms'];
    String treatment = disease['treatment'];

    return WillPopScope(
      onWillPop: () async {
        _showFeedbackDialog(context, widget.prediction);
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Image.file(
                    File(widget.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 25.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.prediction,
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  fontSize: 24.0, color: Colors.white),
                            )),
                        const SizedBox(height: 8.0),
                        Text(
                            DateFormat('yyyy-MM-dd – kk:mm')
                                .format(DateTime.now()),
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Symptoms:',
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(height: 8.0),
                    Text(symptoms,
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(fontSize: 16.0),
                        )),
                    const SizedBox(height: 20.0),
                    Text('Treatment:',
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(height: 8.0),
                    Text(treatment,
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(fontSize: 16.0),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context, String prediction) {
    bool saving = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Use StatefulBuilder to handle local state
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: saving
                  ? const Text('Saving please wait..')
                  : const Text('Confirmation'),
              content: saving
                  ? const SpinKitFadingCircle(
                      color: Colors.green,
                      size: 30,
                    )
                  : const Text('Was this Prediction Helpful?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Correct use of pop
                    Navigator.of(context).pop();
                  },
                  child: const Text('NO'),
                ),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      saving = true; // Update the local saving state
                    });
                    await DataService.savePrediction(prediction);
                    setState(() {
                      saving = false;
                    });
                    Navigator.of(context)
                        .pop(); // Close the dialog after saving
                    Navigator.of(context)
                        .pop(); // Close the screen after saving
                  },
                  child: const Text('YES'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // void _showFeedbackDialog(BuildContext context, String prediction) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return LoadingDialog(
  //         onSave: () async {
  //           await DataService.savePrediction(prediction);
  //         },
  //       );
  //     },
  //   );
  // }
}
