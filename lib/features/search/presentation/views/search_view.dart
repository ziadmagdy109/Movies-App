import 'package:flutter/material.dart';
import 'package:movies_app/core/theme/app_colors.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Text(
            "SearchView",
            style: TextStyle(color: AppColors.mainText),
          ),
        ),
      ),
    );
  }
}
