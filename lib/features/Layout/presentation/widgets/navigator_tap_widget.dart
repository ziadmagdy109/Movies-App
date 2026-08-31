import 'package:flutter/material.dart';
import 'package:movies_app/core/theme/app_colors.dart';

class NavigatorTapWidget extends StatelessWidget {
  const NavigatorTapWidget({
    super.key,
    required this.onTap,
    required this.widget,
    required this.isSelected,
  });

  final void Function()? onTap;
  final Widget widget;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          isSelected ? AppColors.secondColor : AppColors.white,
          BlendMode.srcIn,
        ),
        child: widget,
      ),
    );
  }
}
