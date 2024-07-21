import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AgricultureFacts extends StatefulWidget {
  const AgricultureFacts({Key? key}) : super(key: key);

  @override
  _AgricultureFactsState createState() => _AgricultureFactsState();
}

class _AgricultureFactsState extends State<AgricultureFacts> {
  final List<String> facts = [
    "Agriculture employs over 1 billion people worldwide, making it the second largest source of employment after the services sector.",
    "Organic farming reduces pollution and soil erosion, increases soil fertility, and uses less energy compared to conventional farming.",
    "Vertical farming allows crops to be grown in stacked layers, maximizing space usage and minimizing land use in urban areas.",
    "Crop rotation improves soil health and reduces pests and diseases by alternating the types of crops grown in each field.",
    "Hydroponics is a method of growing plants without soil, using mineral nutrient solutions in water to feed the plants.",
    "The domestication of wheat began around 10,000 years ago in the Fertile Crescent, marking the start of agriculture.",
    "Drip irrigation saves water by delivering it directly to the plant roots, reducing evaporation and runoff compared to traditional methods.",
    "Precision agriculture uses GPS and IoT devices to optimize field-level management regarding crop farming practices and resource use efficiency.",
    "Agroforestry integrates trees and shrubs into crop and animal farming systems to create environmental, economic, and social benefits.",
    "The Green Revolution in the mid-20th century introduced high-yield crop varieties, boosting food production in developing countries.",
    "Conservation tillage reduces soil erosion and water loss, and increases organic matter retention in agricultural fields.",
    "Agritourism allows visitors to experience farm life, promoting local agriculture and generating additional income for farmers.",
    "Aquaponics combines fish farming and hydroponics, using fish waste to nourish plants, creating a sustainable farming system.",
    "Cover crops are planted to protect and enrich soil during off-seasons, reducing erosion and improving soil health.",
    "GMOs (genetically modified organisms) are used to create crops with enhanced traits, such as pest resistance and improved nutrition.",
    "No-till farming minimizes soil disturbance, preserving soil structure, moisture, and reducing erosion and carbon emissions.",
    "Permaculture focuses on creating sustainable and self-sufficient agricultural ecosystems through design principles inspired by nature.",
    "Biodynamic farming treats farms as unified organisms, integrating crops and livestock, and using organic methods and lunar cycles.",
    "Urban agriculture includes the practice of cultivating, processing, and distributing food in or around urban areas.",
    "Integrated pest management uses a combination of biological, cultural, physical, and chemical tools to manage pests sustainably.",
    "Intercropping involves growing two or more crops in proximity, improving biodiversity, and reducing pest and disease incidence.",
  ];

  int currentFactIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startFactChangeTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startFactChangeTimer() {
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      setState(() {
        currentFactIndex = (currentFactIndex + 1) % facts.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 200.0,
        child: Card(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AnimatedSwitcher(
              duration: const Duration(seconds: 2),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Text(
                key: ValueKey<int>(currentFactIndex),
                facts[currentFactIndex],
                style: GoogleFonts.nunito(
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
