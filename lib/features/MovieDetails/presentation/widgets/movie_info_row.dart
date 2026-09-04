import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/theme/app_colors.dart';

class MovieInfoRow extends StatelessWidget {
  const MovieInfoRow({super.key, required this.text, required this.widget});

  final String text;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      height: 28.h,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget,
          SizedBox(width: 10.w),
          Text(
            text,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight(700),
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
