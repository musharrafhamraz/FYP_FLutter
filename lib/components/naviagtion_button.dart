import 'package:flutter/material.dart';

class NaviagtionButton extends StatelessWidget {
  final String buttonText;
  final IconData icon;
  final VoidCallback onPressed;
  final double left;

  const NaviagtionButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    required this.icon,
    required this.left,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1.0),
      child: Center(
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightGreen, // Background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
            ),
            padding: EdgeInsets.only(
              top: 5.0,
              left: left,
              right: 5.0,
              bottom: 5.0,
            ),
          ),
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                buttonText,
                style: const TextStyle(color: Colors.black54, fontSize: 16),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                    border: Border.all(width: 2.0, color: Colors.black),
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.black),
                child: Icon(
                  icon,
                  size: 35.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
