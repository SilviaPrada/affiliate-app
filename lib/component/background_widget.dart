import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final double bottomOffset;

  const BackgroundWidget({super.key, this.bottomOffset = 0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            bottom: bottomOffset,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/images/bgImage.jpg",
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
