import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/gen/assets.gen.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/features/Home/presentation/views/home_view.dart';
import 'package:movies_app/features/Layout/presentation/cubit/layout_cubit.dart';
import 'package:movies_app/features/Layout/presentation/widgets/navigator_tap_widget.dart';
import 'package:movies_app/features/browse/presentation/cubit/browse_cubit.dart';
import 'package:movies_app/features/browse/presentation/views/browse_view.dart';
import 'package:movies_app/features/profile/presentation/views/profile_view.dart';
import 'package:movies_app/features/search/presentation/views/search_view.dart';

class LayoutView extends StatelessWidget {
  final tabs = [
    Assets.icons.homeIcon.svg(),
    Assets.icons.searchIcon.svg(),
    Assets.icons.browseIcon.svg(),
    Assets.icons.profileIcon.svg(),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCubit, int>(
      builder: (context, currentIndex) {
        return SafeArea(
          bottom: false,
          child: Scaffold(
            body: IndexedStack(
              index: currentIndex,
              children: [
                HomeView(),
                SearchView(),
                BlocProvider(
                  create: (context) => BrowseCubit(),
                  child: BrowseView(),
                ),
                ProfileView(),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(right: 10.w, left: 10.w, bottom: 20.h),
              child: Container(
                height: 44.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.navbarColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(tabs.length, (index) {
                    return NavigatorTapWidget(
                      onTap: () {
                        context.read<LayoutCubit>().changeIndex(index);
                      },
                      isSelected: currentIndex == index,
                      widget: tabs[index],
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
