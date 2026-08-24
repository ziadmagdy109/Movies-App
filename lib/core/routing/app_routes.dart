import 'package:flutter/material.dart';
import 'package:movies_app/features/Auth/presentation/views/forget_password_view.dart';
import 'package:movies_app/features/Auth/presentation/views/login_view.dart';
import 'package:movies_app/features/Auth/presentation/views/register_view.dart';
import 'package:movies_app/features/onboarding/explore_page.dart';
import 'package:movies_app/features/onboarding/on_boarding_screens.dart';

import '../../features/splashscreen/splash_screen.dart';
import 'app_route_name.dart';

abstract class AppRoutes {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteName.initial:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case AppRouteName.onBoarding:
        return MaterialPageRoute(
          builder: (context) => const OnBoardingScreens(),
        );

      case AppRouteName.explore:
        return MaterialPageRoute(builder: (context) => const ExplorePage());
      case AppRouteName.login:
        return MaterialPageRoute(builder: (context) => const LoginView());
      case AppRouteName.register:
        return MaterialPageRoute(builder: (context) => const RegisterView());
      case AppRouteName.forgetPassword:
        return MaterialPageRoute(
          builder: (context) => const ForgetPasswordView(),
        );
      default:
        return null;
    }
  }
}
