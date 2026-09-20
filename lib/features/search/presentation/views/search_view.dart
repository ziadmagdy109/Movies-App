import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/gen/assets.gen.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/widgets/custom_text_form_field.dart';
import 'package:movies_app/core/widgets/movie_grid_item.dart';
import 'package:movies_app/features/Search/presentation/cubit/search_cubit.dart';
import 'package:movies_app/features/Search/presentation/cubit/search_state.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SafeArea(
        child: Column(
          spacing: 12,
          children: [
            CustomTextFormField(
              controller: searchController,
              hintText: "Search",
              textInputAction: TextInputAction.search,
              prefixIcon: Assets.icons.searchIcon.svg(
                width: 16.w,
                height: 16.h,
              ),
              onChanged: searchCubit.onQueryChanged,
            ),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is searchLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.secondColor,
                      ),
                    );
                  }

                  if (state is searchLoaded) {
                    return GridView.builder(
                      padding: EdgeInsets.zero,
                      physics: const ClampingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 20,
                        childAspectRatio: 0.62,
                      ),
                      itemCount: state.movies.length,
                      itemBuilder: (context, index) =>
                          MovieGridItem(movies: state.movies[index]),
                    );
                  }

                  if (state is searchEmpty) {
                    return Center(
                      child: Text(
                        "No movies found",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: AppColors.mainSubText),
                      ),
                    );
                  }

                  if (state is searchFailure) {
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
                      "Search for any movie",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: AppColors.mainSubText),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}