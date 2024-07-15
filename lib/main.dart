import 'package:flutter/material.dart';
import 'pages/splash_screen.dart';
import 'pages/home_screen.dart';
import 'pages/camera_screen.dart';
import 'pages/common_disease_details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => WillPopScope(
              onWillPop: () async {
                // Implement logic to handle back button press on home screen
                return await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('The Chef'),
                    content:
                        const Text('Are you sure you want to exit DTreaty?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(
                            context, false), // Stay on home screen
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, true), // Exit app
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
              },
              child: const HomeScreen(), // Wrap HomeScreen with WillPopScope
            ),
        '/camera': (context) => CameraScreen(),
        DetailScreen.routeName: (context) => DetailScreen(),
      },
    );
  }
}
