import 'package:flutter/material.dart';
import 'package:movies_app/features/OnBoarding/widgets/on_boarding_modal_bottom.dart';

class OnBoardingScreen extends StatelessWidget {
  final Widget image;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final VoidCallback onNext;
  final bool showBackButton;
  final VoidCallback? onBack;
  final bool isLast;

  const OnBoardingScreen({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onNext,
    this.showBackButton = false,
    this.onBack,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        image,
        Container(decoration: BoxDecoration(gradient: gradient)),

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: OnBoardingModalBottom(
            isLast: isLast,
            title: title,
            subtitle: subtitle,
            onNext: onNext,
            showBackButton: showBackButton,
            onBack: onBack,
          ),
        ),
      ],
    );
  }
}
