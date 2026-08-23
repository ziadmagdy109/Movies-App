import 'package:flutter/material.dart';
import 'package:movies_app/core/gen/assets.gen.dart';
import 'package:movies_app/core/routing/app_route_name.dart';
import 'package:movies_app/core/theme/app_strings.dart';
import 'package:movies_app/features/onboarding/widgets/button.dart';
import 'package:movies_app/main.dart';

import '../../core/theme/app_colors.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        Assets.images.groupmoviesposter.image(),

        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x001E1E1E),
                Color(0xCC121312),
                Color(0xFF121312),
              ],
              stops: [0.0, 0.5, 0.91],
            ),
          ),
        ),

        Positioned(
          left: 24,
          right: 24,
          bottom: 35,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppStrings.firstOnBoardingText,
                textAlign: TextAlign.center,
                style: theme.textTheme.displaySmall?.copyWith(
                  color: AppColors.mainText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.firstOnBoardingSubText,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.mainSubText,
                ),
              ),
              const SizedBox(height: 24),
              Button(
                text: AppStrings.explore,
                onPressed: () {
                navigatorKey.currentState!.pushReplacementNamed(AppRouteName.onBoarding);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
