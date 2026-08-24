import 'package:flutter/material.dart';
import 'package:movies_app/core/theme/app_colors.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Divider(
            indent: 80,
            endIndent: 10,
            color: AppColors.secondColor,
          ),
        ),
        Text(
          "OR",
          style: theme.textTheme.titleSmall!.copyWith(
            color: AppColors.secondColor,
          ),
        ),
        Expanded(
          child: Divider(
            indent: 10,
            endIndent: 80,
            color: AppColors.secondColor,
          ),
        ),
      ],
    );
  }
}
