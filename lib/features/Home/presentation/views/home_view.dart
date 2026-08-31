import 'package:flutter/material.dart';
import 'package:movies_app/core/theme/app_colors.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Text("HomeView", style: TextStyle(color: AppColors.mainText)),
        ),
      ),
    );
  }
}
