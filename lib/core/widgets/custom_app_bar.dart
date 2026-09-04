import 'package:flutter/material.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/main.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;

  const CustomAppBar({super.key, this.title, this.leading, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.transparent,
      centerTitle: true,
      elevation: 0,
      leadingWidth: 38,
      leading: GestureDetector(
        onTap: () => navigatorKey.currentState!.pop(),
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: leading,
        ),
      ),
      title: title == null
          ? null
          : Text(title!, style: TextStyle(color: AppColors.secondColor)),
      actions: actions,
      actionsPadding: const EdgeInsets.only(right: 16),
    );
  }
}
