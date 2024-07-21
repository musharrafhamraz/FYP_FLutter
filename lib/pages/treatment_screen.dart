import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Import for date and time formatting

class ResultScreen extends StatefulWidget {
  final String prediction;
  final String imagePath; // Add this

  const ResultScreen(
      {super.key, required this.prediction, required this.imagePath});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<dynamic>? diseasesData;

  @override
  void initState() {
    super.initState();
    _loadDiseasesData();
  }

  Future<void> _loadDiseasesData() async {
    // Load JSON file from assets
    String jsonText = await rootBundle.loadString('assets/treatments.json');
    // Decode JSON
    List<dynamic> data = json.decode(jsonText);
    setState(() {
      diseasesData = data;
    });
  }

  Map<String, dynamic>? findDiseaseByName(String name) {
    // Find disease by disease_name
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
      // Handle case where disease is not found
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

    return Scaffold(
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
    );
  }
}
