import 'package:affiliate_app/constant/color.dart';
import 'package:affiliate_app/constant/textstyle.dart';
import 'package:flutter/material.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final bool isEnabled;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    required this.items,
    required this.value,
    required this.onChanged,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.bodyMedium.copyWith(
            color: AppColors.darkGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: isEnabled ? onChanged : null,
          decoration: InputDecoration(
            prefixIcon: Icon(prefixIcon, color: AppColors.darkGrey),
            hintText: hintText,
            hintStyle: AppTextStyle.bodyMedium.copyWith(color: AppColors.grey),
            border: const UnderlineInputBorder(),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          icon: const Icon(
            Icons.arrow_drop_down_rounded,
            color: AppColors.darkGrey,
          ),
          dropdownColor: Colors.white,
        ),
      ],
    );
  }
}
