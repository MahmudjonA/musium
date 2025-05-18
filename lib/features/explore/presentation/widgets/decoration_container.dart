import 'package:flutter/material.dart';

import '../../../../core/responsiveness/app_responsive.dart';

class DecorationContainer extends StatelessWidget {
  final Color color;
  final String image;
  final String title;

  const DecorationContainer({
    super.key,
    required this.color,
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Transform.rotate(
              angle: 0.48,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  image,
                  height: appH(85),
                  width: appW(85),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: appH(16),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
