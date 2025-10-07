import 'package:affiliate_app/constant/color.dart';
import 'package:affiliate_app/constant/textstyle.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showSearch;
  final VoidCallback? onBack;
  final VoidCallback? onLogout;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.showSearch = false,
    this.onBack,
    this.onLogout,
    this.bottom,
  });

  @override
  Size get preferredSize => Size.fromHeight(showSearch ? 120 : 65);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leadingWidth: showBackButton ? 60 : 0,
      leading: showBackButton
          ? Center(
              child: InkWell(
                onTap: onBack ?? () => Navigator.pop(context),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ),
            )
          : null,
      title: Text(
        title,
        style: AppTextStyle.heading1.copyWith(color: Colors.white),
      ),
      elevation: 0,
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bgLogin.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      actions: [
        if (onLogout != null)
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: onLogout,
              child: Center(
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
      ],
      bottom: bottom,
    );
  }
}
