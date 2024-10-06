import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dtreatyflutter/weather_services/weather_services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  WeatherScreenState createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen> {
  WeatherData? globalWeatherData;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      final data = await WeatherService().fetchWeatherData(35.92, 74.30);
      setState(() {
        globalWeatherData = data;
      });
    } catch (e) {
      // Handle error (you might want to show an error message to the user)
      print('Error fetching weather data: $e');
    }
  }

  // Weather Animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/animations/sunny_day.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/animations/clouds.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/animations/rain.json';
      case 'thunderstorm':
        return 'assets/animations/sun_with_rain.json';
      case 'clear':
        return 'assets/animations/sunny_day.json';
      default:
        return 'assets/sunny_day.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: globalWeatherData == null
          ? SpinKitWaveSpinner(
              color: const Color(0xFF2A9D2E),
              waveColor: Colors.green,
              trackColor: Colors.green.shade200,
              size: 70,
            )
          : _buildWeatherInfo(globalWeatherData!),
    );
  }

  Widget _buildWeatherInfo(WeatherData weather) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Color.fromRGBO(184, 3, 3, 1),
              ),
              const SizedBox(width: 8),
              Text("Gilgit, Pakistan",
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('+${weather.temperature.toStringAsFixed(0)}°',
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('H: ${weather.highestTemp.toStringAsFixed(1)}°',
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      )),
                  Text('L: ${weather.lowestTemp.toStringAsFixed(1)}°',
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      )),
                ],
              ),
              const SizedBox(
                width: 30.0,
              ),
              Lottie.asset(
                getWeatherAnimation(weather.mainCondition),
                width: 80,
                height: 80,
                fit: BoxFit.fill,
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherInfoColumn('Humidity', '${weather.humidity}%'),
              _buildWeatherInfoColumn(
                  'Precipitation', '${weather.precipitation} mm'),
              _buildWeatherInfoColumn('Pressure', '${weather.pressure} hPa'),
              _buildWeatherInfoColumn('Wind', '${weather.windSpeed} m/s'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherInfoColumn(String label, String value) {
    return Column(
      children: [
        Text(label,
            style: GoogleFonts.openSans(
              textStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            )),
        const SizedBox(height: 4),
        Text(value,
            style: GoogleFonts.openSans(
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            )),
      ],
    );
  }
}
