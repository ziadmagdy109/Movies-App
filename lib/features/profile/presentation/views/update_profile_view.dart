import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/gen/assets.gen.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/widgets/custom_app_bar.dart';
import 'package:movies_app/core/widgets/custom_button.dart';
import 'package:movies_app/core/widgets/custom_text_form_field.dart';

class UpdateProfileView extends StatelessWidget {
  const UpdateProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: "Pick Avatar",
        leading: Assets.icons.arrowBack.svg(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 260.h),
              child: Column(
                children: [
                  Assets.images.gamer1.image(height: 150.h, width: 150.w),
                  SizedBox(height: 35.h),
                  CustomTextFormField(
                    prefixIcon: Assets.icons.user.svg(),
                    hintText: "John Safwat",
                  ),
                  SizedBox(height: 20.h),
                  CustomTextFormField(
                    prefixIcon: Assets.icons.phoneUser.svg(),
                    hintText: "01200000000000",
                  ),
                  SizedBox(height: 20.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Reset Password",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.mainText,
                      ),
                    ),
                  ),

                  // Spacer(),
                ],
              ),
            ),
            Positioned(
              bottom: 15.h,
              right: 0,
              left: 0,
              child: Column(
                children: [
                  CustomButton(
                    text: "Delete Account",
                    onPressed: () {},
                    backgroundColor: AppColors.red,
                    textColor: AppColors.mainText,
                  ),
                  SizedBox(height: 20.h),
                  CustomButton(
                    text: "Update Data",
                    onPressed: () {},
                    backgroundColor: AppColors.secondColor,
                    textColor: AppColors.mainColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
