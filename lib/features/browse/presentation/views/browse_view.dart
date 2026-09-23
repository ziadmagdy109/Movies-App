import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/widgets/movie_grid_item.dart';
import 'package:movies_app/features/Browse/presentation/cubit/browse_cubit.dart';
import 'package:movies_app/features/Browse/presentation/cubit/browse_state.dart';
import 'package:movies_app/features/Browse/presentation/widgets/category_movies.dart';

class BrowseView extends StatelessWidget {
  const BrowseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: SafeArea(
        child: BlocBuilder<BrowseCubit, BrowseState>(
          builder: (context, state) {
            final browseCubit = context.read<BrowseCubit>();

            return Column(
              children: [
                SizedBox(
                  height: 30.h,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return CategoryMovies(
                          text: BrowseCubit.categories[index],
                          isSelected:
                              browseCubit.currentCategoryIndex == index,
                          onTap: () => browseCubit.selectCategory(index),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      itemCount: BrowseCubit.categories.length,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Expanded(child: _buildContent(context, state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, BrowseState state) {
    if (state is browseLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.secondColor,
        ),
      );
    }

    if (state is browseLoaded) {
      return GridView.builder(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisSpacing: 8,
          crossAxisSpacing: 20,
          childAspectRatio: 0.62,
        ),
        itemCount: state.movies.length,
        itemBuilder: (context, index) => MovieGridItem(movies: state.movies[index]),
      );
    }

    if (state is browseFailure) {
      return Center(
        child: Text(
          state.msg,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: AppColors.red),
        ),
      );
    }

    return Center(
      child: Text(
        "Choose a genre to explore",
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: AppColors.mainSubText),
      ),
    );
  }
}