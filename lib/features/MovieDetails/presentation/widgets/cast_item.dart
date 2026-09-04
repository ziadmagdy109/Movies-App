import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/gen/assets.gen.dart';
import 'package:movies_app/core/theme/app_colors.dart';

class CastItem extends StatelessWidget {
  const CastItem({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      height: 60.h,
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppColors.navbarColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Assets.images.actor.image(
              width: 48.w,
              height: 48.h,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(width: 10.w),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  "Name : Hayley Atwell",
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight(400),
                    color: AppColors.mainText,
                    fontSize: 20.sp,
                  ),
                ),
              ),

              SizedBox(height: 6.h),

              Expanded(
                child: Text(
                  "Character : Captain Carter",
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight(400),
                    color: AppColors.mainText,
                    fontSize: 20.sp,
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
