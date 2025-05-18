import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musium/core/common/colors/app_colors.dart';
import 'package:musium/core/responsiveness/app_responsive.dart';
import 'package:musium/core/route/rout_generator.dart';
import 'package:musium/features/auth/presentation/bloc/auth_event.dart';
import 'package:musium/features/auth/presentation/bloc/log_in/log_in_bloc.dart';
import 'package:musium/features/auth/presentation/bloc/log_in/log_in_state.dart';
import 'package:musium/features/main_page.dart';
import '../../../../core/di/service_locator.dart';
import '../../data/data_sources/local/auth_local_data_source.dart';
import 'onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<void> _checkRemembered(BuildContext context) async {
    final authLocal = sl<AuthLocalDataSource>();
    final data = await authLocal.getRemembered();

    final email = data['email'];
    final password = data['password'];

    if (email != null &&
        email.isNotEmpty &&
        password != null &&
        password.isNotEmpty) {
      BlocProvider.of<LoginUserBloc>(
        context,
      ).add(LogInUser(email: email, password: password));
    } else {
      AppRoute.go(const OnboardingPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        _checkRemembered(context);
      });
    });
    return BlocListener<LoginUserBloc, LoginUserState>(
      listener: (context, state) {
        if (state is LoginUserSuccess) {
          if (!mounted) return;
          AppRoute.go(const MainPage());
        } else if (state is LoginUserError) {
          AppRoute.go(const OnboardingPage());
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.jpg',
                width: appW(400),
                height: appH(400),
              ),
              SizedBox(height: appH(20)),
              const Text(
                'Musium',
                style: TextStyle(
                  color: AppColors.neonGreen,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: appH(20)),
            ],
          ),
        ),
      ),
    );
  }
}
