import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconly/iconly.dart';
import 'package:musium/features/auth/presentation/bloc/auth_event.dart';
import 'package:musium/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:musium/features/auth/presentation/bloc/register/register_state.dart';
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

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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

    BlocProvider.of<RegisterUserBloc>(
      context,
    ).add(RegisterUser(email: email, password: password));
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _emailController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ActionAppBarWg(
        onBackPressed: () {
          AppRoute.close();
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
                "Create an account",
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

                  BlocConsumer<RegisterUserBloc, RegisterUserState>(
                    listener: (context, state) {
                      if (state is RegisterUserSuccess) {
                        saveRememberMe(
                          _emailController.text,
                          _passwordController.text,
                        );
                        AppRoute.go(MainPage());
                      } else if (state is RegisterUserError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is RegisterUserLoading) {
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
                  SizedBox(height: appH(30)),
                ],
              ),
              AuthOrContinueWithWg(
                onTapFacebook: () {},
                onTapGoogle: () {},
                onTapApple: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
