import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/common_disease_details.dart';

const data = [
  {
    "id": "5",
    "title": "Powdery Mildew",
    "subtitle":
        "Powdery mildew appears as white powdery patches on leaves, stems, and flowers.",
    "buttonTxt": "Details",
    "img": "assets/images/powderyMildew.jpg",
    "details":
        "Powdery mildew is a fungal disease caused by various species of fungi in the order Erysiphales. It thrives in warm, humid conditions and can affect a wide range of plants including roses, cucumbers, squash, and lilacs. The white powdery patches typically develop on the upper surface of leaves, although they can also occur on stems and flowers. As the disease progresses, the affected leaves may become distorted and eventually die. Control measures include planting resistant varieties, ensuring good air circulation around plants, and applying fungicides if necessary."
  },
  {
    "id": "2",
    "title": "Leaf Spot",
    "subtitle":
        "Leaf spot manifests as dark or discolored spots on leaves, often with a defined border.",
    "buttonTxt": "Details",
    "img": "assets/images/leaf-spot.jpg",
    "details":
        "Leaf spot is a common fungal disease caused by various species of fungi, including Alternaria, Septoria, and Cercospora. It often occurs during periods of high humidity and can affect a wide range of plants, including vegetables, ornamentals, and trees. Leaf spot typically appears as dark or discolored spots on leaves, which may have a defined border. In severe cases, the spots may coalesce, causing extensive leaf damage and defoliation. Control measures include removing and destroying infected plant material, practicing good garden hygiene, and applying fungicides as needed."
  },
  {
    "id": "3",
    "title": "Rust",
    "subtitle":
        "Rust appears as orange, yellow, or brown powdery or pustular growths on leaves and stems.",
    "buttonTxt": "Details",
    "img": "assets/images/rust.jpg",
    "details":
        "Rust is a fungal disease caused by various species of fungi in the order Pucciniales. It affects a wide range of plants, including ornamentals, vegetables, and grains. Rust typically appears as orange, yellow, or brown powdery or pustular growths on leaves and stems. These growths contain masses of spores that can spread the disease to nearby plants. Rust infections can weaken plants, reduce yields, and affect the aesthetic appeal of ornamental plants. Control measures include planting resistant varieties, removing and destroying infected plant material, and applying fungicides if necessary."
  },
  {
    "id": "4",
    "title": "Anthracnose",
    "subtitle":
        "Anthracnose causes dark, sunken lesions on leaves, stems, and fruits.",
    "buttonTxt": "Details",
    "img": "assets/images/anthredc.jpg",
    "details":
        "Anthracnose is a fungal disease caused by various species of fungi in the genus Colletotrichum. It affects a wide range of plants, including trees, shrubs, and vegetables. Anthracnose typically appears as dark, sunken lesions on leaves, stems, and fruits. These lesions may have a water-soaked appearance in wet conditions and can eventually lead to tissue death. Anthracnose infections can weaken plants, reduce yields, and affect the quality of fruits and vegetables. Control measures include practicing good garden hygiene, removing and destroying infected plant material, and applying fungicides as needed."
  },
  {
    "id": "1",
    "title": "Root Rot",
    "subtitle":
        "Root rot results in rotting roots, often accompanied by wilting, yellowing, or stunted growth above ground.",
    "buttonTxt": "Details",
    "img": "assets/images/rootRot.jpg",
    "details":
        "Root rot is a common problem caused by various pathogens, including fungi, bacteria, and water molds. It affects a wide range of plants, including trees, shrubs, and vegetables. Root rot typically occurs in waterlogged or poorly drained soil, where oxygen levels are low and pathogens thrive. Symptoms of root rot include rotting roots, often with a foul odor, as well as wilting, yellowing, or stunted growth above ground. Control measures include improving soil drainage, avoiding overwatering, and planting resistant varieties. In severe cases, affected plants may need to be removed and replaced."
  }
];

class CommonDisease extends StatelessWidget {
  const CommonDisease({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 235.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, index) {
          final disease = data[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                DetailScreen.routeName,
                arguments: disease,
              );
            },
            child: SizedBox(
              // padding: const EdgeInsets.all(12.0),
              width: 250.0,
              height: 200.0,
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      child: AspectRatio(
                        aspectRatio: 1.5,
                        child: Hero(
                          tag: disease['title']!,
                          child: Image.asset(
                            disease['img']!,
                            height: 150.0,
                            width: 150.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(disease['title']!,
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: CircleAvatar(
                                backgroundColor: Colors.lightGreen,
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
