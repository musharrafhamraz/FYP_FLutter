import 'dart:convert';
import 'package:dtreatyflutter/location/location_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dtreatyflutter/network/network_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_location/fl_location.dart';

class DataService {
  static final _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  static Future<void> savePrediction(String prediction) async {
    bool isConnected = await NetworkUtils.isConnected();
    Location? locationData = await LocationService.getCurrentLocation();
    User? user = FirebaseAuth.instance.currentUser;

    if (locationData == null) {
      // Handle location permission not granted
      return;
    }

    final coordinates = {
      'latitude': locationData.latitude,
      'longitude': locationData.longitude,
    };

    if (isConnected && user != null) {
      await saveToFirestore(prediction, coordinates);
    } else {
      await saveToLocalStorage(prediction, coordinates);
    }
  }

  static Future<void> saveToFirestore(
      String prediction, Map<String, double?> coordinates) async {
    await _firestore.collection('predictions').add({
      'prediction': prediction,
      'latitude': coordinates['latitude'],
      'longitude': coordinates['longitude'],
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> saveToLocalStorage(
      String prediction, Map<String, double?> coordinates) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = 'prediction_${DateTime.now().millisecondsSinceEpoch}';
    Map<String, dynamic> data = {
      'prediction': prediction,
      'latitude': coordinates['latitude'],
      'longitude': coordinates['longitude'],
    };
    await prefs.setString(key, json.encode(data));
  }
}
