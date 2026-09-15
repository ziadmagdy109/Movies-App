import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/routing/app_route_name.dart';
import 'package:movies_app/main.dart';

import '../../../../core/gen/assets.gen.dart';
import '../../model/suggestions_model.dart';
class SuggestionMovie extends StatelessWidget {
  final SuggestedMovieModel? movie;
  const SuggestionMovie({super.key, this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigatorKey.currentState?.pushNamed(AppRouteName.movieDetails,arguments: movie?.id);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            movie?.image.isNotEmpty == true
                ? Image.network(movie!.image, fit: BoxFit.cover)
                : Icon(Icons.error),
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
                      movie?.rating.toString() ?? '',
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
