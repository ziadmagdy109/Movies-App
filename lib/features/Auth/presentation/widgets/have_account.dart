import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/core/theme/app_colors.dart';

class HaveAccount extends StatelessWidget {
  const HaveAccount({
    super.key,
    required this.onCreateAccount,
    required this.text,
  });
  final String text;
  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return RichText(
      text: TextSpan(
        text: "Don’t Have Account ? ",
        style: theme.textTheme.titleSmall!.copyWith(
          color: AppColors.mainText,
          fontWeight: FontWeight(400),
          height: 1.2,
        ),
        children: [
          TextSpan(
            text: text,
            style: theme.textTheme.titleSmall!.copyWith(
              color: AppColors.secondColor,
              fontWeight: FontWeight(400),
              height: 1.2,
            ),
            recognizer: TapGestureRecognizer()..onTap = onCreateAccount,
          ),
        ],
      ),
    );
  }
}
