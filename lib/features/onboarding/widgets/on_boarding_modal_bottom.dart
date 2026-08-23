import 'package:flutter/material.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_strings.dart';
import 'package:movies_app/features/onboarding/widgets/button.dart';

class OnBoardingModalBottom extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onNext;
  final bool showBackButton;
  final VoidCallback? onBack;
  final bool isLast;

  const OnBoardingModalBottom({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onNext,
    this.showBackButton = false,
    this.onBack,
    this.isLast=false,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
      decoration: const BoxDecoration(
        color: Color(0xFF121312),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.mainText,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.mainSubText,
            ),
          ),
          const SizedBox(height: 24),

          Button(
            text: isLast?AppStrings.finish:AppStrings.next,
            onPressed: onNext,
          ),
            const SizedBox(height: 12),

          showBackButton? GestureDetector(
              onTap: onBack,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.secondColor, width: 1.5),
                ),
                child: Text(
                  AppStrings.back,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.secondColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ):SizedBox(),

        ],
      ),
    );
  }
}