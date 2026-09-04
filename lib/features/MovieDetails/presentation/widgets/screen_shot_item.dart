import 'package:flutter/material.dart';
import 'package:movies_app/core/gen/assets.gen.dart';

class ScreenShotItem extends StatelessWidget {
  const ScreenShotItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(child: Assets.images.screenshot1.image());
  }
}
