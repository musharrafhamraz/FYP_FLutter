import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/splash_screen.dart';
import 'pages/home_screen.dart';
import 'pages/camera_screen.dart';
import 'pages/common_disease_details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => WillPopScope(
              onWillPop: () async {
                return await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Dtreaty'),
                    content:
                        const Text('Are you sure you want to exit DTreaty?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
              },
              child: const HomeScreen(),
            ),
        '/camera': (context) => const CameraScreen(),
        DetailScreen.routeName: (context) => DetailScreen(),
      },
    );
  }
}
