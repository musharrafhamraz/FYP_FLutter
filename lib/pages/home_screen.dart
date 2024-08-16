import 'package:dtreatyflutter/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/weather.dart';
import '../components/common_disease.dart';
import '../components/naviagtion_button.dart';
import '../components/facts_renderer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // Wrap content with SingleChildScrollView
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          child: Column(
            children: [
              const WeatherScreen(),
              const SizedBox(
                height: 30.0,
              ),
              const CommonDisease(),
              const SizedBox(
                height: 20.0,
              ),
              const AgricultureFacts(),
              // const Spacer(),
              NaviagtionButton(
                buttonText: "START TREATMENT",
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/camera');
                },
              ),
              NaviagtionButton(
                buttonText: "Log Out",
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
