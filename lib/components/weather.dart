import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<WeatherData> weatherData;

  // New code....

  Future<String> _getAddressFromLatLng() async {
    try {
      // Get the current position of the device
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Use the coordinates to get the address
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      print(position.longitude + position.latitude);

      // Get the first result from the placemarks list
      Placemark place = placemarks[0];

      // Construct the address
      String address = '${place.locality}, ${place.country}';

      return address;
    } catch (e) {
      print(e);
      return 'Unable to determine the location';
    }
  }

  String _address = 'Fetching location...';

  @override
  void initState() {
    super.initState();
    weatherData = WeatherService().fetchWeatherData(35.92, 74.30);
    _fetchLocation(); // Replace with desired coordinates
  }

  Future<void> _fetchLocation() async {
    String address = await _getAddressFromLatLng();
    setState(() {
      _address = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<WeatherData>(
        future: weatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final weather = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _address,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '+${weather.temperature.toStringAsFixed(0)}°',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'H: ${weather.highestTemp.toStringAsFixed(1)}°',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'L: ${weather.lowestTemp.toStringAsFixed(1)}°',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 30.0,
                      ),
                      Image.network(
                        'https://cdn-icons-png.flaticon.com/512/1163/1163661.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Humidity',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${weather.humidity}%',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Precipitation',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${weather.precipitation} mm',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Pressure',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${weather.pressure} hPa',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Wind',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${weather.windSpeed} m/s',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const Text('No data');
          }
        },
      ),
    );
  }
}

class WeatherData {
  final double temperature;
  final double lowestTemp;
  final double highestTemp;
  final int humidity;
  final double precipitation;
  final int pressure;
  final double windSpeed;

  WeatherData({
    required this.temperature,
    required this.lowestTemp,
    required this.highestTemp,
    required this.humidity,
    required this.precipitation,
    required this.pressure,
    required this.windSpeed,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: json['current']['temp'],
      lowestTemp: json['daily'][0]['temp']['min'],
      highestTemp: json['daily'][0]['temp']['max'],
      humidity: json['current']['humidity'],
      precipitation: json['daily'][0]['rain'] ??
          0.0, // Use 0.0 if rain data is not available
      pressure: json['current']['pressure'],
      windSpeed: json['current']['wind_speed'],
    );
  }
}

class WeatherService {
  final String apiKey = '432a8658a6991c2c948f1125de99c13d';
  final String baseUrl = 'https://api.openweathermap.org/data/3.0/onecall';

  Future<WeatherData> fetchWeatherData(double lat, double lon) async {
    final response = await http.get(
      Uri.parse('$baseUrl?lat=$lat&lon=$lon&units=metric&appid=$apiKey'),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return WeatherData.fromJson(json);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
