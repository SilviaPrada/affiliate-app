import 'package:affiliate_app/component/background_widget.dart';
import 'package:affiliate_app/constant/color.dart';
import 'package:affiliate_app/constant/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:affiliate_app/pages/login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double screenWidth = size.width;

    double bottomOffset;

    if (screenWidth < 500) {
      bottomOffset = 200;
    } else if (screenWidth < 600) {
      bottomOffset = 100;
    } else if (screenWidth < 700) {
      bottomOffset = 80;
    } else if (screenWidth < 800) {
      bottomOffset = 30;
    } else {
      bottomOffset = 0;
    }

    return Scaffold(
      body: Stack(
        children: [
          BackgroundWidget(bottomOffset: bottomOffset),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome", style: AppTextStyle.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      "Members Affiliate Application.\nLogin to access",
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColors.darkGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
              Padding(
                padding: EdgeInsets.only(bottom: 50.0, right: 30),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Continue",
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColors.darkGrey,
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
