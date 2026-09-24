import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movies_app/core/routing/app_route_name.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/services/auth_preferences.dart';
import 'package:movies_app/core/theme/app_theme.dart';
import 'package:movies_app/features/Home/data/repository/movies_repository.dart';
import 'package:movies_app/features/Home/data/service/movies_web_service.dart';
import 'package:movies_app/features/Home/presentation/cubit/movies_cubit.dart';
import 'package:movies_app/features/Layout/presentation/cubit/layout_cubit.dart';
import 'package:movies_app/features/Layout/presentation/views/layout_view.dart';
import 'package:movies_app/features/library/data/repository/user_library_repository.dart';
import 'package:movies_app/features/library/presentation/cubit/user_library_cubit.dart';
import 'package:movies_app/features/Splash/splash_screen.dart';

import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GoogleSignIn.instance.initialize(
    serverClientId:
        "85025048975-bmhhjqi9d64752kbtitpbjqlb9dev0ge.apps.googleusercontent.com",
  ); //Aud
  final Widget home;
  if (await AuthPreferences.isLoggedIn()) {
    home = MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LayoutCubit()),
        BlocProvider(
          create: (context) => MoviesCubit(
            moviesRepository: MoviesRepository(
              moviesWebService: MoviesWebService(),
            ),
          )..getMovies("Action"),
        ),
      ],
      child: LayoutView(),
    );
  } else {
    home = const SplashScreen();
  }
  runApp(MyApp(home: home));
}

class MyApp extends StatelessWidget {
  final Widget? home;
  const MyApp({super.key, this.home});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserLibraryCubit>(
          create: (context) => UserLibraryCubit(
            repository: UserLibraryRepository(),
          ),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          theme: AppTheme.themeData,
          initialRoute: home == null ? AppRouteName.initial : null,
          home: home,
          onGenerateRoute: AppRoutes.onGenerateRoute,
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}