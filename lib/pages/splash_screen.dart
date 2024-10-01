import 'package:dtreatyflutter/auth/login_screen.dart';
// import 'package:dtreatyflutter/inference_page.dart';
import 'package:dtreatyflutter/network/network_utils.dart';
import 'package:dtreatyflutter/pages/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/naviagtion_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _checkUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    bool isConnected = await NetworkUtils.isConnected();

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );

      // test code
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => PlantDiseaseIdentifier()),
      // );
    } else if (!isConnected) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Background Pattern
            Positioned.directional(
                textDirection: TextDirection.ltr,
                child: Image.asset("./assets/images/splash1.png")),
            // Main Content
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Top Padding
                  // Texts
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "BOOST",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "AGRICULTURE",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "PRODUCTION\nTHROUGH",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "→ MECHANIZATION",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  // Bottom Button
                  const SizedBox(height: 50),
                  NaviagtionButton(
                    buttonText: "TRY FOR FREE",
                    icon: Icons.arrow_outward_outlined,
                    left: 25.0,
                    onPressed: () {
                      _checkUser();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
