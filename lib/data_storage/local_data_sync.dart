import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dtreatyflutter/data_storage/read_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSync {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to sync local data to Firebase
  Future<void> syncDataToFirebase() async {
    // Step 1: Retrieve locally saved predictions using the method from ReadDataService
    List<Map<String, dynamic>> localPredictions =
        await ReadDataService.getLocalPredictions();

    if (localPredictions.isEmpty) {
      print('No local data to sync.');
      return;
    }

    for (Map<String, dynamic> localData in localPredictions) {
      // Step 2: Check for duplicates in Firebase
      bool isDuplicate = await _checkForDuplicates(localData);

      if (!isDuplicate) {
        // Step 3: Upload data to Firebase
        await _uploadToFirebase(localData);
        print('Data uploaded: $localData');
      } else {
        print('Duplicate data found, skipping upload.');
      }
    }

    // Optional: Step 4: Clear or update the locally saved data
    await _clearLocalData();
    print('Local data sync complete.');
  }

  // Function to check for duplicates in Firebase
  Future<bool> _checkForDuplicates(Map<String, dynamic> localData) async {
    String collectionName =
        'your_collection_name'; // Update with your collection name

    QuerySnapshot snapshot = await _firestore
        .collection(collectionName)
        .where('uniqueField',
            isEqualTo: localData['uniqueField']) // Ensure the field exists
        .get();

    return snapshot.docs.isNotEmpty;
  }

  // Function to upload data to Firebase
  Future<void> _uploadToFirebase(Map<String, dynamic> data) async {
    String collectionName =
        'your_collection_name'; // Update with your collection name

    await _firestore.collection(collectionName).add(data);
  }

  // Function to clear local data after successful sync
  Future<void> _clearLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(
        'localData'); // Assuming 'localData' was the key used to store data
  }
}
