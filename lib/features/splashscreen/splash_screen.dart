import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movies_app/core/gen/assets.gen.dart';
import 'package:movies_app/core/routing/app_route_name.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      navigatorKey.currentState!.pushReplacementNamed(AppRouteName.explore);
    },);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          Assets.icons.splashicon.image(),
          Spacer(),
          Assets.icons.routelogo.image(width: 140,height: 180)
        ],
      ),
    );
  }
}
