import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movies_app/core/gen/assets.gen.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/widgets/custom_button.dart';
import 'package:movies_app/core/widgets/movie_grid_item.dart';
import 'package:movies_app/features/MovieDetails/presentation/cubit/movies_details_state.dart';
import 'package:movies_app/features/MovieDetails/presentation/widgets/cast_item.dart';
import 'package:movies_app/features/MovieDetails/presentation/widgets/genres_item.dart';
import 'package:movies_app/features/MovieDetails/presentation/widgets/movie_info_row.dart';
import 'package:movies_app/features/MovieDetails/repo/movie_details_repo.dart';
import 'package:movies_app/main.dart';

import '../../../Home/data/repository/movies_repository.dart';
import '../../service/movie_details_web_service.dart';
import '../cubit/movies_details_cubit.dart';

class MovieDetailsView extends StatelessWidget {
  const MovieDetailsView({super.key});

  @override
  Widget build(BuildContext context) {

    final movieId = ModalRoute.of(context)!.settings.arguments as int;
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: BlocProvider(
        create: (context) => MoviesDetailsCubit(
          movieDetailsRepository: MovieDetailsRepo(
            moviesWebService: MovieDetailsWebService(),
          ),
        )..getMovieDetails(movieId),
        child: BlocConsumer<MoviesDetailsCubit, MoviesDetailsState>(
          listener: (context, state) {
            if (state is MoviesDetailsLoading) {
              EasyLoading.show(status: 'loading...');
            }
          },
          builder: (context, state) {
            if (state is MoviesDetailsLoaded) {
              EasyLoading.dismiss();
              final movieDetails = state.moviesDetails;
              List<String> screenShots = [
                movieDetails.large_screenshot_image1,
                movieDetails.large_screenshot_image2,
                movieDetails.large_screenshot_image3,
              ];
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    leading: GestureDetector(
                      onTap: () => navigatorKey.currentState!.pop(),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.white,
                        size: 30.sp,
                      ),
                    ),
                    actionsPadding: EdgeInsets.only(right: 16),
                    actions: [Assets.icons.bookMark.svg()],
                    expandedHeight: 450.h,
                    pinned: true,
                    stretch: true,
                    backgroundColor: AppColors.navbarColor,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      background: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              movieDetails.large_cover_image,
                            ),
                          ),
                          Positioned(
                            left: 16.w,
                            right: 16.w,
                            bottom: 14.h,
                            child: Column(
                              children: [
                                Assets.icons.openTrial.svg(),
                                SizedBox(height: 120.h),
                                Text(
                                  movieDetails.title_long,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight(700),
                                    color: AppColors.mainText,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  "2022",
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight(700),
                                    color: AppColors.greyDark,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                CustomButton(
                                  text: "Watch",
                                  textColor: AppColors.mainText,
                                  onPressed: () {},
                                  backgroundColor: AppColors.red,
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: MovieInfoRow(
                                        text: movieDetails.like_count.toString(),
                                        widget: Assets.icons.favourite.svg(
                                          height: 12.h,
                                          width: 12.w,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: MovieInfoRow(
                                        text: movieDetails.runtime.toString(),
                                        widget: Assets.icons.clock.svg(
                                          height: 12.h,
                                          width: 12.w,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: MovieInfoRow(
                                        text: movieDetails.rating.toString(),
                                        widget: Assets.icons.star.svg(
                                          height: 12.h,
                                          width: 12.w,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Screen Shots",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: 24.sp,
                              fontWeight: FontWeight(700),
                              color: AppColors.mainText,
                            ),
                          ),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            itemCount: 3,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10.h),
                            itemBuilder: (context, index) {
                              return Image.network(screenShots[index]);
                            },
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            "Similar",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: 24.sp,
                              fontWeight: FontWeight(700),
                              color: AppColors.mainText,
                            ),
                          ),
                          GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            gridDelegate:
                            SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 20,
                              childAspectRatio: 0.62,
                            ),
                            itemCount: 4,
                            itemBuilder: (context, index) => MovieGridItem(),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            "Summary",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: 24.sp,
                              fontWeight: FontWeight(700),
                              color: AppColors.mainText,
                            ),
                          ),
                          Text(
                            movieDetails.description_full,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: AppColors.mainText,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            "Cast",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: 24.sp,
                              fontWeight: FontWeight(700),
                              color: AppColors.mainText,
                            ),
                          ),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            itemCount: 4,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10.h),
                            itemBuilder: (context, index) {
                              if(movieDetails.cast!.isNotEmpty) {
                                return CastItem(
                                  actorName: movieDetails.cast![index].name ?? '',
                                  actorImage: movieDetails.cast![index].urlSmallImage ?? '',
                                  characterName: movieDetails.cast![index].characterName ?? '',
                                );
                              }
                              return SizedBox();
                            },
                          ),
                          Text(
                            "Gencres",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: 24.sp,
                              fontWeight: FontWeight(700),
                              color: AppColors.mainText,
                            ),
                          ),
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 16,
                              mainAxisExtent: 36,
                            ),
                            itemCount: 5,
                            itemBuilder: (context, index) => GenresItem(),
                          ),
                          SizedBox(height: 100.h),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            else if (state is MoviesDetailsFailure) {
              print(movieId);
              print(movieId.runtimeType);
              EasyLoading.dismiss();
              Fluttertoast.showToast(
                  msg: state.msg,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
            return SizedBox();

          },
        ),
      ),
    );
  }
}