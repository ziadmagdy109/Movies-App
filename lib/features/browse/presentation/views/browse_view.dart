import 'package:flutter/material.dart';
import 'package:movies_app/core/theme/app_colors.dart';

class BrowseView extends StatelessWidget {
  const BrowseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Text(
            "BrowseView",
            style: TextStyle(color: AppColors.mainText),
          ),
        ),
      ),
    );
  }
}
