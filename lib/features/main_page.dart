import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:musium/features/home/presentation/pages/home_page.dart';
import 'package:musium/features/library/presentation/pages/library_page.dart';
import '../core/common/colors/app_colors.dart';
import '../core/responsiveness/app_responsive.dart';
import 'explore/presentation/pages/explore_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> pages = [HomePage(), ExplorePage(), LibraryPage()];

  static const List<MyCustomBottomNavBarItem> tabs = [
    MyCustomBottomNavBarItem(
      icon: Icon(IconlyLight.home),
      activeIcon: Icon(IconlyBold.home),
      label: "Home",
    ),
    MyCustomBottomNavBarItem(
      icon: Icon(IconlyLight.search),
      activeIcon: Icon(IconlyBold.search),
      label: "Explore",
    ),
    MyCustomBottomNavBarItem(
      icon: Icon(IconlyLight.folder),
      activeIcon: Icon(IconlyBold.folder),
      label: "Library",
    ),
  ];

  void goOtherTab(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: IndexedStack(index: _currentIndex, children: pages),
        bottomNavigationBar: SizedBox(
          height: appH(83),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            iconSize: appW(20),
            backgroundColor: AppColors.background,
            currentIndex: _currentIndex,
            selectedItemColor: AppColors.neonGreen,
            unselectedItemColor: AppColors.white,
            onTap: goOtherTab,
            selectedLabelStyle: TextStyle(
              color: AppColors.neonGreen,
              fontSize: appH(15),
            ),
            unselectedLabelStyle: TextStyle(
              color: AppColors.grey,
              fontSize: appH(13),
            ),
            items: tabs,
          ),
        ),
      ),
    );
  }
}

class MyCustomBottomNavBarItem extends BottomNavigationBarItem {
  const MyCustomBottomNavBarItem({
    required super.icon,
    super.label,
    Widget? activeIcon,
  }) : super(activeIcon: activeIcon ?? icon);
}
