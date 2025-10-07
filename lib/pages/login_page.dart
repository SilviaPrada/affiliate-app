import 'package:affiliate_app/bloc/auth/auth_bloc.dart';
import 'package:affiliate_app/bloc/auth/auth_event.dart';
import 'package:affiliate_app/bloc/auth/auth_state.dart';
import 'package:affiliate_app/component/background_widget.dart';
import 'package:affiliate_app/component/custom_input_field.dart';
import 'package:affiliate_app/constant/color.dart';
import 'package:affiliate_app/constant/textstyle.dart';
import 'package:affiliate_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double screenWidth = size.width;

    double bottomOffset;

    if (screenWidth < 500) {
      bottomOffset = 290;
    } else if (screenWidth < 600) {
      bottomOffset = 240;
    } else if (screenWidth < 700) {
      bottomOffset = 200;
    } else if (screenWidth < 800) {
      bottomOffset = 160;
    } else {
      bottomOffset = 120;
    }
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              BackgroundWidget(bottomOffset: bottomOffset),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (state.error != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.error),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: AppColors.error,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                state.error!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: AppColors.error),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 80),
                    const Text("Log in", style: AppTextStyle.titleLarge),
                    Container(
                      width: 50,
                      height: 3,
                      color: AppColors.primary,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    const SizedBox(height: 30),
                    CustomInputField(
                      label: 'Email',
                      hintText: 'Enter your username',
                      prefixIcon: Icons.person_outlined,
                      controller: usernameCtrl,
                    ),
                    const SizedBox(height: 20),
                    CustomInputField(
                      label: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icons.lock_outline,
                      controller: passwordCtrl,
                      isPassword: true,
                    ),
                    const SizedBox(height: 50),
                    GestureDetector(
                      onTap: () {
                        context.read<AuthBloc>().add(
                          LoginRequested(usernameCtrl.text, passwordCtrl.text),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 35,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: AppTextStyle.bodyLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
