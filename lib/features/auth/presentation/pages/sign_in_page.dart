import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconly/iconly.dart';
import 'package:musium/features/auth/presentation/bloc/auth_event.dart';
import 'package:musium/features/auth/presentation/bloc/log_in/log_in_bloc.dart';
import 'package:musium/features/auth/presentation/bloc/log_in/log_in_state.dart';
import 'package:musium/features/auth/presentation/pages/auth_page.dart';
import 'package:musium/features/auth/presentation/pages/sign_up_page.dart';
import '../../../../core/common/colors/app_colors.dart';
import '../../../../core/common/sizes/sizes.dart';
import '../../../../core/common/widgets/action_app_bar_wg.dart';
import '../../../../core/common/widgets/custom_text_field_wg.dart';
import '../../../../core/common/widgets/default_button_wg.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/responsiveness/app_responsive.dart';
import '../../../../core/route/rout_generator.dart';
import '../../../../core/utils/logger.dart';
import '../../../main_page.dart';
import '../../data/data_sources/local/auth_local_data_source.dart';
import '../widgets/auth_or_continue_with_wg.dart';
import '../widgets/auth_sign_in_up_choice_wg.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isFocusedEmail = false;
  bool _isFocusedPassword = false;
  bool _obscureText = true;
  final authLocalDataSource = sl<AuthLocalDataSource>();


  @override
  void initState() {
    super.initState();

    _passwordFocusNode.addListener(() {
      setState(() {
        _isFocusedPassword = _passwordFocusNode.hasFocus;
      });
    });

    _emailFocusNode.addListener(() {
      setState(() {
        _isFocusedEmail = _emailFocusNode.hasFocus;
      });
    });
  }
  void saveRememberMe(String email, String password) {
    authLocalDataSource
        .saveRememberMe(email, password)
        .then((_) {
      LoggerService.info("Remember Me saved : $email - $password");
    })
        .catchError((error) {
      LoggerService.error("Error saving Remember Me: $error");
    });
  }

  void signInUser() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    BlocProvider.of<LoginUserBloc>(
      context,
    ).add(LogInUser(email: email, password: password));
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ActionAppBarWg(
        onBackPressed: () {
          AppRoute.go(AuthPage());
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: scaffoldPadding24,
          child: Column(
            children: [
              Image.asset(
                "assets/images/logo.jpg",
                height: appH(200),
                width: appW(200),
              ),
              SizedBox(height: appH(20)),
              Text(
                "Login to your account",
                maxLines: 2,
                textAlign: TextAlign.left,
                style: TextStyle(color: AppColors.grey, fontSize: appH(35)),
              ),
              SizedBox(height: appH(20)),
              Column(
                spacing: appH(23),
                children: [
                  CustomTextFieldWg(
                    isFocused: _isFocusedEmail,
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    prefixIcon: IconlyBold.message,
                    hintText: "Email",
                    onTap: () {
                      setState(() {
                        _isFocusedEmail = true;
                      });
                    },
                  ),
                  CustomTextFieldWg(
                    isFocused: _isFocusedPassword,
                    obscureText: _obscureText,
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    prefixIcon: IconlyBold.lock,
                    hintText: "Password",
                    trailingWidget: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      icon: Icon(
                        _obscureText ? IconlyBold.hide : IconlyBold.show,
                        size: appH(20),
                        color:
                            _isFocusedPassword
                                ? AppColors.neonGreen
                                : AppColors.grey,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _isFocusedPassword = true;
                      });
                    },
                  ),

                  BlocConsumer<LoginUserBloc, LoginUserState>(
                    listener: (context, state) {
                      if (state is LoginUserSuccess) {
                        saveRememberMe(
                          _emailController.text,
                          _passwordController.text,
                        );
                        AppRoute.go(MainPage());
                      } else if (state is LoginUserError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is LoginUserLoading) {
                        return Center(
                          child: SpinKitFadingCircle(
                            color: AppColors.neonGreen,
                            size: 60.0,
                          ),
                        );
                      } else {
                        return DefaultButtonWg(
                          title: "Sign In",
                          onPressed: signInUser,
                        );
                      }
                    },
                  ),

                  TextButton(
                    onPressed: () {
                      // AppRoute.go(ForgotPassword());
                    },
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: appH(16),
                      ),
                    ),
                  ),
                ],
              ),
              AuthOrContinueWithWg(
                onTapFacebook: () {},
                onTapGoogle: () {},
                onTapApple: () {},
              ),
              SizedBox(height: appH(20)),
              AuthSignInUpChoiceWg(
                text: "Don't have an account?",
                onPressed: () {
                  AppRoute.replace(SignUpPage());
                },
                buttonText: "Sign Up",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
