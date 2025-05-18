import 'package:flutter/material.dart';
import 'package:musium/features/main_page.dart';
import 'core/responsiveness/app_responsive.dart';
import 'core/route/rout_generator.dart';
import 'features/auth/presentation/pages/splash_page.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppResponsive.init(context);
    return MaterialApp(
      navigatorKey: AppRoute.navigatorKey,
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
      // home:MainPage()
    );
  }
}
