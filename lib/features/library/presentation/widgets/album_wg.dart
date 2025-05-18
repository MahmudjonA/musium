import 'package:flutter/material.dart';

import '../../../../core/common/colors/app_colors.dart';
import '../../../../core/responsiveness/app_responsive.dart';

class AlbumWg extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const AlbumWg({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: appH(20)),
      child: Row(
        children: [
          Image.network(image, width: appH(66), height: appH(66)),
          SizedBox(width: appH(20)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: appH(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: appH(7)),
              Text(
                subtitle,
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: appH(15),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
