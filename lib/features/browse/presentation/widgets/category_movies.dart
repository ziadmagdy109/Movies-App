import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/theme/app_colors.dart';

class CategoryMovies extends StatelessWidget {
  const CategoryMovies({
    super.key,
    required this.isSelected,
    required this.text,
    required this.onTap,
  });
  final bool isSelected;
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondColor : Colors.transparent,

          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(width: 1.5.w, color: AppColors.secondColor),
        ),
        child: Center(
          child: Text(
            text,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight(700),
              color: isSelected ? AppColors.mainColor : AppColors.secondColor,
            ),
          ),
        ),
      ),
    );
  }
}
