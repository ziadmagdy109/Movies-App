import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movies_app/core/gen/assets.gen.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/widgets/custom_button.dart';
import 'package:movies_app/features/MovieDetails/presentation/cubit/movies_details_state.dart';
import 'package:movies_app/features/MovieDetails/presentation/widgets/cast_item.dart';
import 'package:movies_app/features/MovieDetails/presentation/widgets/genres_item.dart';
import 'package:movies_app/features/MovieDetails/presentation/widgets/movie_info_row.dart';
import 'package:movies_app/features/MovieDetails/repo/movie_details_repo.dart';
import 'package:movies_app/main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../service/movie_details_web_service.dart';
import '../cubit/movies_details_cubit.dart';
import '../cubit/suggestions_cubit.dart';
import '../cubit/suggestions_state.dart';
import '../widgets/suggestion_movie.dart';

class MovieDetailsView extends StatefulWidget {
  const MovieDetailsView({super.key});

  @override
  State<MovieDetailsView> createState() => _MovieDetailsViewState();
}

class _MovieDetailsViewState extends State<MovieDetailsView> {
  bool isWatchList = false;
  @override
  Widget build(BuildContext context) {
    final movieId = ModalRoute.of(context)!.settings.arguments as int;
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<MoviesDetailsCubit>(
            create: (context) => MoviesDetailsCubit(
              movieDetailsRepository: MovieDetailsRepo(
                moviesWebService: MovieDetailsWebService(),
              ),
            )..getMovieDetails(movieId),
          ),
          BlocProvider<SuggestionsCubit>(
            create: (context) => SuggestionsCubit(
              movieDetailsRepository: MovieDetailsRepo(
                moviesWebService: MovieDetailsWebService(),
              ),
            )..getSuggestions(movieId),
          ),
        ],
        child: BlocConsumer<MoviesDetailsCubit, MoviesDetailsState>(
          listener: (context, state) {
            if (state is MoviesDetailsLoading) {
              EasyLoading.show(status: 'loading...');
            } else if (state is MoviesDetailsLoaded) {
              EasyLoading.dismiss();
            } else if (state is MoviesDetailsFailure) {
              EasyLoading.dismiss();
              Fluttertoast.showToast(
                msg: state.msg,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          },
          builder: (context, state) {
            if (state is MoviesDetailsLoaded) {
              final movieDetails = state.moviesDetails;
              List<String> screenShots = [
                movieDetails.large_screenshot_image1,
                movieDetails.large_screenshot_image2,
                movieDetails.large_screenshot_image3,
              ];
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    surfaceTintColor: Colors.transparent,
                    leading: GestureDetector(
                      onTap: () => navigatorKey.currentState!.pop(),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.white,
                        size: 30.sp,
                      ),
                    ),
                    actionsPadding: EdgeInsets.only(right: 16),
                    actions: [
                      GestureDetector(
                        child: isWatchList
                            ? Assets.icons.bookMark.svg()
                            : Assets.icons.bookmarkempty.image(
                                width: 20.w,
                                height: 29.h,
                              ),
                        onTap: () {
                          setState(() {
                          isWatchList = !isWatchList;

                          });
                        },
                      ),
                    ],
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
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            left: 16.w,
                            right: 16.w,
                            bottom: 14.h,
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final url = Uri.parse(movieDetails.url);
                                    EasyLoading.show(status: 'Opening film...');
                                    try {
                                      EasyLoading.dismiss();
                                      final launched = await launchUrl(
                                        url,
                                        mode: LaunchMode.externalApplication,
                                      );
                                      if (!launched) {
                                        Fluttertoast.showToast(
                                          msg: 'Could not open trailer',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                        );
                                      }
                                    } catch (e) {
                                      Fluttertoast.showToast(
                                        msg: 'Could not open trailer',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                      );
                                    }
                                  },
                                  child: Assets.icons.openTrial.svg(),
                                ),
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
                                  movieDetails.year.toString(),
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight(700),
                                    color: AppColors.greyDark,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                CustomButton(
                                  text: "Watch",
                                  textColor: AppColors.mainText,
                                  onPressed: () async {
                                    final url = Uri.parse(
                                      'https://www.imdb.com/title/${movieDetails.imdb_code}/',
                                    );
                                    EasyLoading.show(
                                      status: 'Opening trailer...',
                                    );
                                    try {
                                      final launched = await launchUrl(
                                        url,
                                        mode: LaunchMode.externalApplication,
                                      );
                                      EasyLoading.dismiss();
                                      if (!launched) {
                                        Fluttertoast.showToast(
                                          msg: 'Could not open trailer',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                        );
                                      }
                                    } catch (e) {
                                      Fluttertoast.showToast(
                                        msg: 'Could not open trailer',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                      );
                                    }
                                  },
                                  backgroundColor: AppColors.red,
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: MovieInfoRow(
                                        text: movieDetails.like_count
                                            .toString(),
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
                          BlocConsumer<SuggestionsCubit, SuggestionsState>(
                            listener: (context, state) {
                              if (state is SuggestionsFailure) {
                                Fluttertoast.showToast(
                                  msg: 'Failed To Load Data',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is SuggestionsLoading) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is SuggestionsLoaded) {
                                final suggestions = state.suggestionMovies;
                                return GridView.builder(
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
                                  itemCount: suggestions.length,
                                  itemBuilder: (context, index) =>
                                      SuggestionMovie(movie: suggestions[index]),
                                );
                              }
                              return SizedBox();
                            },
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
                            itemCount: movieDetails.cast!.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10.h),
                            itemBuilder: (context, index) {
                              if (movieDetails.cast!.isNotEmpty) {
                                return CastItem(
                                  actorName:
                                      movieDetails.cast![index].name ?? '',
                                  actorImage:
                                      movieDetails.cast![index].urlSmallImage ??
                                      '',
                                  characterName:
                                      movieDetails.cast![index].characterName ??
                                      '',
                                );
                              }
                              return SizedBox();
                            },
                          ),
                          Text(
                            "Genres",
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
                            itemCount: movieDetails.genres.length,
                            itemBuilder: (context, index) =>
                                GenresItem(genres: movieDetails.genres[index]),
                          ),
                          SizedBox(height: 100.h),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
