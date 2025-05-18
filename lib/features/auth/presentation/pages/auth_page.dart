import 'package:flutter/material.dart';
import 'package:musium/core/common/colors/app_colors.dart';
import 'package:musium/core/common/widgets/default_button_wg.dart';
import 'package:musium/core/responsiveness/app_responsive.dart';
import 'package:musium/core/route/rout_generator.dart';
import 'package:musium/features/auth/presentation/pages/sign_in_page.dart';

import '../widgets/auth_sign_in_button_wg.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          spacing: appH(14),
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.jpg',
              width: appW(400),
              height: appH(400),
            ),
            const Text(
              'Let’s get you in',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),

            AuthSignInButtonWg(
              image: Image.asset(
                "assets/images/facebook.png",
                height: appH(24),
                width: appW(24),
              ),
              text: "Continue with Facebook",
              onTap: () {},
            ),
            AuthSignInButtonWg(
              image: Image.asset(
                "assets/images/google.png",
                height: appH(24),
                width: appW(24),
              ),
              text: "Continue with Google",
              onTap: () {},
            ),
            AuthSignInButtonWg(
              image: Image.asset(
                "assets/images/apple.png",
                height: appH(24),
                width: appW(24),
              ),
              text: "Continue with Apple",
              onTap: () {},
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: appW(170), height: 1, color: AppColors.white),
                const SizedBox(width: 10),
                const Text(
                  "or",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                 SizedBox(width: appW(10)),
                Container(width: appW(170), height: 1, color: AppColors.white),
              ],
            ),
            DefaultButtonWg(
              title: "Log in with a password",
              onPressed: () {
                AppRoute.open(SignInPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
