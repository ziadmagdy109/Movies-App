import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/gen/assets.gen.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/widgets/movie_grid_item.dart';
import 'package:movies_app/features/Home/presentation/widgets/action_see_more.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Assets.images.startboarding.image(fit: BoxFit.fill),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter,
                colors: [Colors.black54, Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black87, Colors.transparent],
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80.w),
                  child: Assets.images.availableNow.image(),
                ),
                CarouselSlider(
                  items: [MovieGridItem()],
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.34,

                    aspectRatio: 2 / 3,

                    viewportFraction: 0.50,

                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,

                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(
                      milliseconds: 800,
                    ),
                    autoPlayCurve: Curves.fastOutSlowIn,

                    enlargeCenterPage: true,
                    enlargeFactor: 0.24.w,

                    scrollDirection: Axis.horizontal,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 38.w),
                  child: Assets.images.watchNow.image(),
                ),

                ///
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: ActionSeeMore(),
                ),
                SizedBox(
                  height: 220.h,
                  child: ListView.separated(
                    padding: EdgeInsets.only(left: 10.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    separatorBuilder: (context, index) => SizedBox(width: 10.w),
                    itemBuilder: (context, index) {
                      return SizedBox(width: 146.w, child: MovieGridItem());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
