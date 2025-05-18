import 'package:flutter/material.dart';
import 'package:musium/core/route/rout_generator.dart';
import 'package:musium/features/home/presentation/pages/song_page.dart';

import '../../../../core/common/colors/app_colors.dart';
import '../../../../core/responsiveness/app_responsive.dart';

class MusicWg extends StatelessWidget {
  final String image;
  final String title;
  final String subTitle;
  final VoidCallback onTap;

  const MusicWg({
    super.key,
    required this.onTap,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        height: appH(60),
        child: Row(
          children: [
            Image.network(image, width: 55, height: 55),
            SizedBox(width: appW(20)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: appH(16),
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.more_vert, color: AppColors.white, size: 20),
                    ],
                  ),
                  SizedBox(height: appH(5)),
                  Text(
                    subTitle,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: appH(14),
                      fontWeight: FontWeight.w400,
                    ),
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
