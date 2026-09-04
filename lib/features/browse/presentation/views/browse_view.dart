import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/widgets/movie_grid_item.dart';
import 'package:movies_app/features/Browse/presentation/cubit/browse_cubit.dart';
import 'package:movies_app/features/Browse/presentation/widgets/category_movies.dart';

class BrowseView extends StatelessWidget {
  BrowseView({super.key});
  final List<String> categories = [
    "Action",
    "Adventure",
    "Animation",
    "Biography",
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrowseCubit, int>(
      builder: (context, currentIndex) {
        return Padding(
          padding: EdgeInsets.only(top: 16.h),
          child: Column(
            children: [
              SizedBox(
                height: 30.h,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, index) =>
                        CategoryMovies(
                          text: categories[index],
                          isSelected: currentIndex == index,
                          onTap: () {
                            context.read<BrowseCubit>().changeIndex(index);
                          },
                        ),
                    separatorBuilder: (context, index) => SizedBox(width: 10),
                    itemCount: categories.length,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Expanded(
                child: GridView.builder(
                  physics: ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.62,
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) => MovieGridItem(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
