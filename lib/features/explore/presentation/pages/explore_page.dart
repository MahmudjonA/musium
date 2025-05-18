import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:musium/core/common/colors/app_colors.dart';
import 'package:musium/core/responsiveness/app_responsive.dart';
import 'package:musium/features/explore/presentation/widgets/decoration_container.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final decorationContainer1 = [
    {"image": "assets/images/pop.png", "title": "Pop Mix", "color": Colors.red},
    {
      "image": "assets/images/chill.png",
      "title": "Chill Mix",
      "color": Colors.yellow,
    },
    {
      "image": "assets/images/lofi.png",
      "title": "Lo-Fi Beats",
      "color": Colors.blue,
    },
    {
      "image": "assets/images/coffee.png",
      "title": "Coffee & Jazz",
      "color": Colors.brown,
    },
  ];
  final decorationContainer2 = [
    {"image": "assets/images/pop.png", "title": "Pop Mix", "color": Colors.red},
    {
      "image": "assets/images/chill.png",
      "title": "Chill Mix",
      "color": Colors.yellow,
    },
    {
      "image": "assets/images/lofi.png",
      "title": "Lo-Fi Beats",
      "color": Colors.blue,
    },
    {
      "image": "assets/images/coffee.png",
      "title": "Coffee & Jazz",
      "color": Colors.brown,
    },
    {
      "image": "assets/images/lofi.png",
      "title": "Lo-Fi Beats",
      "color": Colors.blue,
    },
    {
      "image": "assets/images/coffee.png",
      "title": "Coffee & Jazz",
      "color": Colors.brown,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.jpg',
              width: appW(50),
              height: appH(50),
            ),
            SizedBox(width: appW(15)),
            Text(
              'Search',
              style: TextStyle(
                color: Colors.white,
                fontSize: appH(27),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: appH(20),
          left: appW(20),
          right: appW(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: appH(50),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.containerColor,
                  borderRadius: BorderRadius.circular(appW(25)),
                ),
                child: TextField(
                  style: TextStyle(color: AppColors.white),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      IconlyLight.search,
                      color: AppColors.grey,
                      size: appH(25),
                    ),
                    hintText: 'Search for music, artists, albums...',
                    hintStyle: TextStyle(
                      color: AppColors.grey,
                      fontSize: appH(20),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: appW(15),
                      vertical: appH(14),
                    ),
                  ),
                ),
              ),
              SizedBox(height: appH(20)),
              Text(
                "Your Top Genres",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: appH(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: appH(10)),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: decorationContainer1.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.7,
                ),
                itemBuilder: (context, index) {
                  final item = decorationContainer1[index];
                  return DecorationContainer(
                    image: item["image"] as String,
                    title: item["title"] as String,
                    color: item["color"] as Color,
                  );
                },
              ),
              SizedBox(height: appH(20)),
              Text(
                "Browse All",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: appH(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: appH(10)),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: decorationContainer2.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.7,
                ),
                itemBuilder: (context, index) {
                  final item = decorationContainer2[index];
                  return DecorationContainer(
                    image: item["image"] as String,
                    title: item["title"] as String,
                    color: item["color"] as Color,
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
