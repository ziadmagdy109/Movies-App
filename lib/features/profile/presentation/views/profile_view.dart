import 'package:flutter/material.dart';
import 'package:movies_app/core/theme/app_colors.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Text(
            "ProfileView",
            style: TextStyle(color: AppColors.mainText),
          ),
        ),
      ),
    );
  }
}
