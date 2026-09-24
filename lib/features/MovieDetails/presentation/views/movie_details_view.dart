import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movies_app/core/gen/assets.gen.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/widgets/custom_button.dart';
import 'package:movies_app/features/MovieDetails/model/cast_model.dart';
import 'package:movies_app/features/MovieDetails/model/movies_details.dart';
import 'package:movies_app/features/MovieDetails/presentation/cubit/movies_details_state.dart';
import 'package:movies_app/features/MovieDetails/presentation/widgets/cast_item.dart';
import 'package:movies_app/features/MovieDetails/presentation/widgets/genres_item.dart';
import 'package:movies_app/features/MovieDetails/presentation/widgets/movie_info_row.dart';
import 'package:movies_app/features/MovieDetails/repo/movie_details_repo.dart';
import 'package:movies_app/features/library/data/models/saved_movie.dart';
import 'package:movies_app/features/library/presentation/cubit/user_library_cubit.dart';
import 'package:movies_app/features/library/presentation/cubit/user_library_state.dart';
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
  late final MovieDetailsRepo _movieDetailsRepo;

  @override
  void initState() {
    super.initState();
    _movieDetailsRepo = MovieDetailsRepo(
      moviesWebService: MovieDetailsWebService(),
    );
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  int _resolveMovieId() {
    final RouteSettings? settings = ModalRoute.of(context)?.settings;
    final Object? args = settings?.arguments;
    if (args is int) return args;
    return 0;
  }

  void _onDetailsState(BuildContext context, MoviesDetailsState state) {
    if (state is MoviesDetailsLoading) {
      EasyLoading.show(status: 'Loading...');
    } else if (state is MoviesDetailsLoaded || state is MoviesDetailsFailure) {
      EasyLoading.dismiss();
    }
  }

  void _launchTrailer(MoviesDetails movieDetails) async {
    if (movieDetails.url.isEmpty) return;

    try {
      final bool launched = await launchUrl(
        Uri.parse(movieDetails.url),
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
  }

  Future<void> _launchWatchPage(MoviesDetails movieDetails, int movieId) async {
    final Uri url = Uri.parse(
      'https://www.imdb.com/title/${movieDetails.imdb_code}/',
    );
    final UserLibraryCubit userLibraryCubit =
        context.read<UserLibraryCubit>();
    EasyLoading.show(status: 'Opening trailer...');
    try {
      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      EasyLoading.dismiss();
      if (launched) {
        userLibraryCubit.addToHistory(
          SavedMovie.fromDetails(
            id: movieId,
            details: movieDetails,
          ),
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Could not open trailer',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
        msg: 'Could not open trailer',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final int movieId = _resolveMovieId();
    final ThemeData theme = Theme.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<MoviesDetailsCubit>(
          create: (context) {
            final cubit = MoviesDetailsCubit(
              movieDetailsRepository: _movieDetailsRepo,
            );
            if (movieId > 0) {
              cubit.getMovieDetails(movieId);
            }
            return cubit;
          },
        ),
        BlocProvider<SuggestionsCubit>(
          create: (context) {
            final cubit = SuggestionsCubit(
              movieDetailsRepository: _movieDetailsRepo,
            );
            if (movieId > 0) {
              cubit.getSuggestions(movieId);
            }
            return cubit;
          },
        ),
      ],
      child: BlocConsumer<MoviesDetailsCubit, MoviesDetailsState>(
        listener: _onDetailsState,
        builder: (context, state) {
          if (state is MoviesDetailsLoaded) {
            return Scaffold(
              body: _buildLoaded(context, state.moviesDetails, theme),
            );
          }
          if (state is MoviesDetailsFailure) {
            return _buildErrorPage(
              context,
              message:
                  'Could not load this movie. Please check your internet connection and try again.',
              movieId: movieId,
            );
          }
          if (movieId <= 0) {
            return _buildErrorPage(
              context,
              message: 'This movie could not be found.',
              movieId: movieId,
              showRetry: false,
            );
          }
          return _buildLoadingPage();
        },
      ),
    );
  }

  // ---------------- LOADING / ERROR / PLACEHOLDERS ----------------

  Widget _buildLoadingPage() {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: _pageAppBar(),
      body: const Center(
        child: CircularProgressIndicator(color: AppColors.secondColor),
      ),
    );
  }

  Widget _buildErrorPage(
    BuildContext context, {
    required String message,
    required int movieId,
    bool showRetry = true,
  }) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: _pageAppBar(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.movie_filter_outlined,
                color: AppColors.mainSubText,
                size: 56.sp,
              ),
              SizedBox(height: 16.h),
              Text(
                'Something went wrong',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.mainText,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.mainSubText,
                ),
              ),
              if (showRetry) ...[
                SizedBox(height: 24.h),
                CustomButton(
                  text: "Retry",
                  textColor: AppColors.mainText,
                  backgroundColor: AppColors.secondColor,
                  onPressed: () {
                    if (movieId > 0) {
                      context.read<MoviesDetailsCubit>().getMovieDetails(
                            movieId,
                          );
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  AppBar _pageAppBar() {
    return AppBar(
      backgroundColor: AppColors.navbarColor,
      leading: GestureDetector(
        onTap: () => navigatorKey.currentState?.pop(),
        child: Icon(
          Icons.arrow_back_ios,
          color: AppColors.white,
          size: 30.sp,
        ),
      ),
    );
  }

  Widget _imagePlaceholder({double size = 48}) {
    return Container(
      color: AppColors.navbarColor,
      alignment: Alignment.center,
      child: Icon(
        Icons.movie,
        color: AppColors.mainSubText,
        size: size,
      ),
    );
  }

  // ---------------- LOADED STATE ----------------

  Widget _buildLoaded(
    BuildContext context,
    MoviesDetails movieDetails,
    ThemeData theme,
  ) {
    final int movieId = _resolveMovieId();
    final List<String> screenShots = [
      movieDetails.large_screenshot_image1,
      movieDetails.large_screenshot_image2,
      movieDetails.large_screenshot_image3,
    ].where((url) => url.isNotEmpty).toList();

    final List<CastModel> cast = movieDetails.cast;
    final List<String> genres = movieDetails.genres;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          surfaceTintColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () => navigatorKey.currentState?.pop(),
            child: Icon(
              Icons.arrow_back_ios,
              color: AppColors.white,
              size: 30.sp,
            ),
          ),
          actionsPadding: EdgeInsets.only(right: 16),
          actions: [
            BlocBuilder<UserLibraryCubit, UserLibraryState>(
              builder: (context, state) {
                final bool isFavorite = context
                    .read<UserLibraryCubit>()
                    .isFavorite(movieId);
                return GestureDetector(
                  child: isFavorite
                      ? Assets.icons.bookMark.svg()
                      : Assets.icons.bookmarkempty.image(
                          width: 20.w,
                          height: 29.h,
                        ),
                  onTap: () {
                    context.read<UserLibraryCubit>().toggleFavorite(
                          SavedMovie.fromDetails(
                            id: movieId,
                            details: movieDetails,
                          ),
                        );
                  },
                );
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
                    errorBuilder: (_, __, ___) => _imagePlaceholder(),
                  ),
                ),
                Positioned(
                  left: 16.w,
                  right: 16.w,
                  bottom: 14.h,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => _launchTrailer(movieDetails),
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
                          fontWeight: FontWeight.w700,
                          color: AppColors.greyDark,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      CustomButton(
                        text: "Watch",
                        textColor: AppColors.mainText,
                        onPressed: () =>
                            _launchWatchPage(movieDetails, movieId),
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
                if (screenShots.isNotEmpty) ...[
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
                    itemCount: screenShots.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      return Image.network(
                        screenShots[index],
                        errorBuilder: (_, __, ___) => _imagePlaceholder(),
                      );
                    },
                  ),
                  SizedBox(height: 16.h),
                ],
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
                        child: CircularProgressIndicator(
                          color: AppColors.secondColor,
                        ),
                      );
                    } else if (state is SuggestionsFailure) {
                      return Text(
                        'Could not load similar movies.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.mainSubText,
                        ),
                      );
                    } else if (state is SuggestionsLoaded) {
                      final suggestions = state.suggestionMovies;
                      if (suggestions.isEmpty) {
                        return Text(
                          'No similar movies found.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.mainSubText,
                          ),
                        );
                      }
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
                  movieDetails.description_full.isEmpty
                      ? 'No description available.'
                      : movieDetails.description_full,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.mainText,
                  ),
                ),
                if (cast.isNotEmpty) ...[
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
                    itemCount: cast.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      final castItem = cast[index];
                      return CastItem(
                        actorName: castItem.name ?? '',
                        actorImage: castItem.urlSmallImage ?? '',
                        characterName: castItem.characterName ?? '',
                      );
                    },
                  ),
                ],
                if (genres.isNotEmpty) ...[
                  SizedBox(height: 16.h),
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
                    itemCount: genres.length,
                    itemBuilder: (context, index) =>
                        GenresItem(genres: genres[index]),
                  ),
                ],
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}