import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../../../../core/common/colors/app_colors.dart';
import '../../../../core/responsiveness/app_responsive.dart';

class CustomChoiceChipWg extends StatelessWidget {
  final int selectedIndex;
  final int index;
  final String label;
  final bool showIcon;
  final void Function(bool)? onSelected;

  const CustomChoiceChipWg({
    super.key,
    required this.index,
    required this.label,
    required this.selectedIndex,
    required this.onSelected,
    this.showIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: appW(12)),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color:
                selectedIndex == index ? AppColors.background : AppColors.white,
            fontSize: appH(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        selected: selectedIndex == index,
        selectedColor: AppColors.neonGreen,
        backgroundColor: AppColors.background,
        showCheckmark: false,
        avatar:
            showIcon
                ? Icon(
                  IconlyBold.star,
                  color:
                      selectedIndex == index ? AppColors.white : AppColors.grey,
                )
                : null,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.grey),
          borderRadius: BorderRadius.circular(100),
        ),
        onSelected: onSelected,
      ),
    );
  }
}
