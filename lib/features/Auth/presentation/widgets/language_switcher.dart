import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies_app/core/gen/assets.gen.dart';
import 'package:movies_app/core/theme/app_colors.dart';

class LanguageSwitcher extends StatelessWidget {
  final bool isEnglish = true;

  const LanguageSwitcher({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 90,
        height: 40,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          border: Border.all(color: AppColors.secondColor, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Assets.icons.lr.svg(), Assets.icons.eg.svg()],
            ),
            Container(
              width: 34,
              height: 34,
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amber, width: 2),
              ),
              child: ClipOval(
                child: SvgPicture.asset(
                  isEnglish ? Assets.icons.lr.path : Assets.icons.eg.path,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
