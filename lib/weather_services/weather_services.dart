import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherData {
  final double temperature;
  final double lowestTemp;
  final double highestTemp;
  final int humidity;
  final double precipitation;
  final int pressure;
  final double windSpeed;
  final String mainCondition;

  WeatherData({
    required this.temperature,
    required this.lowestTemp,
    required this.highestTemp,
    required this.humidity,
    required this.precipitation,
    required this.pressure,
    required this.windSpeed,
    required this.mainCondition,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      mainCondition: json['current']['weather'][0]['main'],
      temperature: json['current']['temp'],
      lowestTemp: json['daily'][0]['temp']['min'],
      highestTemp: json['daily'][0]['temp']['max'],
      humidity: json['current']['humidity'],
      precipitation: json['daily'][0]['rain'] ?? 0.0,
      pressure: json['current']['pressure'],
      windSpeed: json['current']['wind_speed'],
    );
  }
}

class WeatherService {
  static final WeatherService _instance = WeatherService._internal();
  WeatherData? _cachedWeatherData;

  factory WeatherService() {
    return _instance;
  }

  WeatherService._internal();

  final String apiKey = '432a8658a6991c2c948f1125de99c13d';
  final String baseUrl = 'https://api.openweathermap.org/data/3.0/onecall';

  Future<WeatherData> fetchWeatherData(double lat, double lon) async {
    if (_cachedWeatherData != null) {
      return _cachedWeatherData!;
    }

    final response = await http.get(
      Uri.parse('$baseUrl?lat=$lat&lon=$lon&units=metric&appid=$apiKey'),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      _cachedWeatherData = WeatherData.fromJson(json);
      return _cachedWeatherData!;
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
