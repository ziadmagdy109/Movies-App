import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movies_app/core/routing/app_route_name.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/theme/app_theme.dart';

import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GoogleSignIn.instance.initialize(
    serverClientId:
        "85025048975-bmhhjqi9d64752kbtitpbjqlb9dev0ge.apps.googleusercontent.com",
  );//Aud
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        theme: AppTheme.themeData,
        initialRoute: AppRouteName.initial,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
      ),
    );
  }
}
