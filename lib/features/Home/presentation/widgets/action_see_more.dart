import 'package:flutter/material.dart';
import 'package:movies_app/core/theme/app_colors.dart';

class ActionSeeMore extends StatelessWidget {
  final String category;
  const ActionSeeMore({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          category,
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.white),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "See More",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.secondColor,
                ),
              ),
              SizedBox(width: 6),
              Icon(Icons.arrow_forward, color: Colors.amber, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}
