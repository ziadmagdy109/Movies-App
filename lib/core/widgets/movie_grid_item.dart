import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/routing/app_route_name.dart';
import 'package:movies_app/features/Home/data/models/movies.dart';
import 'package:movies_app/features/library/data/models/saved_movie.dart';
import 'package:movies_app/features/library/presentation/cubit/user_library_cubit.dart';
import 'package:movies_app/features/library/presentation/cubit/user_library_state.dart';
import 'package:movies_app/main.dart';

import '../gen/assets.gen.dart';

class MovieGridItem extends StatelessWidget {
  final Movies? movies;
  const MovieGridItem({super.key, this.movies});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigatorKey.currentState?.pushNamed(AppRouteName.movieDetails,arguments: movies?.id);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            movies?.largeCoverImage.isNotEmpty == true
                ? Image.network(movies!.largeCoverImage, fit: BoxFit.cover)
                : Assets.images.marvelgridimg.image(),
            Positioned(
              top: 8.h,
              right: 8.w,
              child: movies == null
                  ? const SizedBox()
                  : BlocBuilder<UserLibraryCubit, UserLibraryState>(
                      builder: (context, state) {
                        final bool isFavorite = context
                            .read<UserLibraryCubit>()
                            .isFavorite(movies!.id);
                        return GestureDetector(
                          onTap: () {
                            context
                                .read<UserLibraryCubit>()
                                .toggleFavorite(SavedMovie.fromMovies(movies!));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.75),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: isFavorite
                                ? Assets.icons.bookMark.svg(
                                    width: 16.w,
                                    height: 16.h,
                                  )
                                : Assets.icons.bookmarkempty.image(
                                    width: 16.w,
                                    height: 16.h,
                                  ),
                          ),
                        );
                      },
                    ),
            ),
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
                      movies?.rating.toString() ?? '',
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
