import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/Auth/presentation/views/forget_password_view.dart';
import 'package:movies_app/features/Auth/presentation/views/login_view.dart';
import 'package:movies_app/features/Auth/presentation/views/register_view.dart';
import 'package:movies_app/features/Home/presentation/views/home_view.dart';
import 'package:movies_app/features/Layout/presentation/cubit/layout_cubit.dart';
import 'package:movies_app/features/Layout/presentation/views/layout_view.dart';
import 'package:movies_app/features/Browse/presentation/views/browse_view.dart';
import 'package:movies_app/features/MovieDetails/presentation/views/movie_details_view.dart';
import 'package:movies_app/features/OnBoarding/explore_page.dart';
import 'package:movies_app/features/OnBoarding/on_boarding_screens.dart';
import 'package:movies_app/features/Profile/presentation/views/profile_view.dart';
import 'package:movies_app/features/Search/presentation/views/search_view.dart';

import '../../features/Splash/splash_screen.dart';
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
      case AppRouteName.layout:
        return MaterialPageRoute(
          builder: (context) =>
              BlocProvider(create: (_) => LayoutCubit(), child: LayoutView()),
        );
      case AppRouteName.home:
        return MaterialPageRoute(builder: (context) => const HomeView());
      case AppRouteName.search:
        return MaterialPageRoute(builder: (context) => const SearchView());
      case AppRouteName.browse:
        return MaterialPageRoute(builder: (context) => BrowseView());
      case AppRouteName.profile:
        return MaterialPageRoute(builder: (context) => const ProfileView());
      case AppRouteName.movieDetails:
        return MaterialPageRoute(
          builder: (context) => const MovieDetailsView(),
        );
      default:
        return null;
    }
  }
}
