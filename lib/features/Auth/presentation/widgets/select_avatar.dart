import 'package:flutter/material.dart';
import 'package:movies_app/core/gen/assets.gen.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_strings.dart';

class SelectAvatar extends StatelessWidget {
  const SelectAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      spacing: 24,
      children: [
        Expanded(child: Assets.images.gamer12.image()),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Assets.images.gamer1.image(),
              SizedBox(height: 10),
              Text(
                AppStrings.avatar,
                style: theme.textTheme.titleMedium!.copyWith(
                  color: AppColors.mainText,
                ),
              ),
            ],
          ),
        ),
        Expanded(child: Assets.images.gamer11.image()),
      ],
    );
  }
}
