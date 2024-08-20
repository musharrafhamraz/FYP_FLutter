import 'package:dtreatyflutter/data_storage/read_data.dart';
import 'package:flutter/material.dart';

class PredictionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Local Database.'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: ReadDataService.getLocalPredictions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final predictions = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    final prediction = predictions[index];
                    return ListTile(
                      title: Text(prediction['prediction']),
                      subtitle: Text(
                          'Lat: ${prediction['latitude']}, Lon: ${prediction['longitude']}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
