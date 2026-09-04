import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/gen/assets.gen.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/widgets/custom_button.dart';
import 'package:movies_app/core/widgets/movie_grid_item.dart';
import 'package:movies_app/features/MovieDetails/presentation/widgets/cast_item.dart';
import 'package:movies_app/features/MovieDetails/presentation/widgets/genres_item.dart';
import 'package:movies_app/features/MovieDetails/presentation/widgets/movie_info_row.dart';
import 'package:movies_app/features/MovieDetails/presentation/widgets/screen_shot_item.dart';
import 'package:movies_app/main.dart';

class MovieDetailsView extends StatelessWidget {
  const MovieDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
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
                    child: Assets.images.ratemovie.image(fit: BoxFit.cover),
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
                          "Doctor Strange in the Multiverse\nof Madness",
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
                                text: "15",
                                widget: Assets.icons.favourite.svg(
                                  height: 12.h,
                                  width: 12.w,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: MovieInfoRow(
                                text: "90",
                                widget: Assets.icons.clock.svg(
                                  height: 12.h,
                                  width: 12.w,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: MovieInfoRow(
                                text: "7.6",
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
                      return ScreenShotItem();
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
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
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
                    "Following the events of Spider-Man No Way Home, Doctor Strange unwittingly casts a forbidden spell that accidentally opens up the multiverse. With help from Wong and Scarlet Witch, Strange confronts various versions of himself as well as teaming up with the young America Chavez while traveling through various realities and working to restore reality as he knows it. Along the way, Strange and his allies realize they must take on a powerful new adversary who seeks to take over the multiverse.—Blazer346",
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
                      return CastItem();
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
      ),
    );
  }
}
