import 'package:flutter/material.dart';
import 'package:movies_app/core/gen/assets.gen.dart';
import 'package:movies_app/core/routing/app_route_name.dart';
import 'package:movies_app/core/theme/app_strings.dart';
import 'package:movies_app/features/onboarding/on_boarding_screen.dart';
import 'package:movies_app/main.dart';

class _OnBoardingData {
  final Widget image;
  final String title;
  final String subtitle;
  final Gradient gradient;

  const _OnBoardingData({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });
}

LinearGradient _overlayGradient(Color base) {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      base.withOpacity(0.0),
      base.withOpacity(0.8),
      base.withOpacity(1.0),
    ],
    stops: const [0.0, 0.5, 0.91],
  );
}

class OnBoardingScreens extends StatefulWidget {
  const OnBoardingScreens({super.key});

  @override
  State<OnBoardingScreens> createState() => _OnBoardingScreensState();
}

class _OnBoardingScreensState extends State<OnBoardingScreens> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  late final List<_OnBoardingData> _rawPages = [
    _OnBoardingData(
      image: Assets.images.marvelimage.image(fit: BoxFit.fill),
      title: AppStrings.firstOnBoardingText,
      subtitle: AppStrings.firstOnBoardingSubText,
      gradient: _overlayGradient(const Color(0xFF084250)),
    ),
    _OnBoardingData(
      image: Assets.images.oppenheimer.image(fit: BoxFit.fill),
      title: AppStrings.secondOnBoardingText,
      subtitle: AppStrings.secondOnBoardingSubText,
      gradient: _overlayGradient(const Color(0xFF85210E)),
    ),
    _OnBoardingData(
      image: Assets.images.badboys.image(fit: BoxFit.fill),
      title: AppStrings.thirdOnBoardingText,
      subtitle: AppStrings.thirdOnBoardingSubText,
      gradient: _overlayGradient(const Color(0xFF1A1A2E)),
    ),
    _OnBoardingData(
      image: Assets.images.ratemovie.image(fit: BoxFit.fill),
      title: AppStrings.fourthOnBoardingText,
      subtitle: AppStrings.fourthOnBoardingSubText,
      gradient: _overlayGradient(const Color(0xFF2B1A33)),
    ),
    _OnBoardingData(
      image: Assets.images.startboarding.image(fit: BoxFit.fill),
      title: AppStrings.fifthOnBoardingText,
      subtitle: "",
      gradient: _overlayGradient(const Color(0xFF121312)),
    ),
  ];

  void _goToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToPreviousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onFinish() {
    navigatorKey.currentState!.pushReplacementNamed(AppRouteName.login);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int lastIndex = _rawPages.length - 1;

    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: _rawPages.length,
        onPageChanged: (index) => setState(() => currentPage = index),
        itemBuilder: (context, index) {
          final bool isFirst = index == 0;
          final bool isLast = index == lastIndex;
          final _OnBoardingData raw = _rawPages[index];

          return OnBoardingScreen(
            image: raw.image,
            title: raw.title,
            subtitle: raw.subtitle,
            gradient: raw.gradient,
            onNext: isLast ? _onFinish : _goToNextPage,
            showBackButton: !isFirst,
            onBack: isFirst ? null : _goToPreviousPage,
            isLast: isLast,
          );
        },
      ),
    );
  }
}
