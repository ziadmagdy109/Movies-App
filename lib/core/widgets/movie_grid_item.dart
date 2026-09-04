import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/routing/app_route_name.dart';
import 'package:movies_app/main.dart';

import '../gen/assets.gen.dart';

class MovieGridItem extends StatelessWidget {
  const MovieGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigatorKey.currentState?.pushNamed(AppRouteName.movieDetails);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Assets.images.marvelgridimg.image(fit: BoxFit.cover),
            Positioned(
              top: 8.h,
              left: 8.w,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '7.7',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 3),
                    Assets.icons.star.svg(width: 15.w, height: 15.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
