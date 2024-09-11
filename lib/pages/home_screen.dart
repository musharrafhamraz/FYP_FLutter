import 'package:dtreatyflutter/auth/login_screen.dart';
// import 'package:dtreatyflutter/data_storage/local_data_sync.dart';
// import 'package:dtreatyflutter/pages/read_local_data.dart';
// import 'package:dtreatyflutter/pages/read_local_data.dart';
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
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          // Wrap content with SingleChildScrollView
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          child: Column(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.27,
                  child: const WeatherScreen()),
              const SizedBox(
                height: 30.0,
              ),
              const CommonDisease(),
              const SizedBox(
                height: 20.0,
              ),
              const AgricultureFacts(),
              // const Spacer(),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: NaviagtionButton(
                      icon: Icons.arrow_outward_outlined,
                      left: 25.0,
                      buttonText: "START TREATMENT",
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/camera');
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: NaviagtionButton(
                      icon: Icons.logout_outlined,
                      left: 1.0,
                      buttonText: "",
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Do you want to Logout?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('No'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                ),
                                TextButton(
                                  child: const Text('Yes'),
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),

              // NaviagtionButton(
              //   icon: Icons.arrow_outward_outlined,
              //   left: 25.0,
              //   buttonText: "SYNC DATA",
              //   onPressed: () {
              //     // Create an instance of LocalDataSync
              //     LocalDataSync localDataSync = LocalDataSync();

              //     // Call the syncDataToFirebase method on the instance
              //     localDataSync.syncDataToFirebase();
              //   },
              // ),
              // NaviagtionButton(
              //   icon: Icons.arrow_outward_outlined,
              //   left: 25.0,
              //   buttonText: "Read Data",
              //   onPressed: () {
              //     Navigator.of(context).pushReplacement(
              //       MaterialPageRoute(
              //           builder: (context) => PredictionsScreen()),
              //     );
              //   },
              // ),

              // NaviagtionButton(
              //   buttonText: "See Local Data",
              //   onPressed: () async {
              //     await FirebaseAuth.instance.signOut();
              //     Navigator.of(context).pushReplacement(
              //       MaterialPageRoute(
              //           builder: (context) => PredictionsScreen()),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
