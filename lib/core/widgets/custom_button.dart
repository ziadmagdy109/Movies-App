import 'package:flutter/material.dart';
import 'package:movies_app/core/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 56,
    this.borderRadius = 14,
    this.backgroundColor = AppColors.secondColor,
    this.textColor = AppColors.mainColor,
    this.icon,
  });

  final String text;
  final VoidCallback? onPressed;

  final double height;
  final double borderRadius;

  final Color backgroundColor;
  final Color textColor;

  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[icon!, const SizedBox(width: 8)],
            Text(
              text,
              style: theme.textTheme.titleLarge!.copyWith(
                height: 1.2,
                color: textColor,
                fontWeight: FontWeight(700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
