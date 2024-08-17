import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ReadDataService {
  // Existing methods...

  static Future<List<Map<String, dynamic>>> getLocalPredictions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> keys = prefs.getKeys().toList();
    List<Map<String, dynamic>> predictions = [];

    for (String key in keys) {
      if (key.startsWith('prediction_')) {
        String? jsonString = prefs.getString(key);
        if (jsonString != null) {
          predictions.add(json.decode(jsonString));
        }
      }
    }

    return predictions;
  }
}
