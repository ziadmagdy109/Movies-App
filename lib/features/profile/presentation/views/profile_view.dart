import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/gen/assets.gen.dart';
import 'package:movies_app/core/routing/app_route_name.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/widgets/custom_button.dart';
import 'package:movies_app/main.dart';

import '../../../../core/widgets/movie_grid_item.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  TabBarDelegate(this.tabBar);

  @override
  double get minExtent => 70;

  @override
  double get maxExtent => 70;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return Container(color: AppColors.mainColor, child: tabBar);
  }

  @override
  bool shouldRebuild(covariant TabBarDelegate oldDelegate) {
    return false;
  }
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.mainColor,

      body: NestedScrollView(
        headerSliverBuilder: (context, constraints) => [

          // ================= PROFILE =================
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 52.h),

                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Assets.images.gamer1.image(
                        width: 118.w,
                        height: 118.h,
                      ),
                    ),

                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "12",
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: AppColors.mainText,
                            ),
                          ),

                          Text(
                            "Wish List",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppColors.mainText,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "10",
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: AppColors.mainText,
                            ),
                          ),

                          Text(
                            "History",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppColors.mainText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),

                // ================= USERNAME =================
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 27.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "John Safwat",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.mainText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10.h),

                // ================= BUTTONS =================
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: CustomButton(
                          text: "Edit Profile",
                          onPressed: () {
                            navigatorKey.currentState!.pushNamed(AppRouteName.updateProfile);
                          },
                        ),
                      ),

                      SizedBox(width: 10.w),

                      Expanded(
                        flex: 2,
                        child: CustomButton(
                          text: "Exit",
                          onPressed: () {
                            navigatorKey.currentState!.pushNamed(AppRouteName.login);
                          },
                          icon: Assets.icons.exit.image(
                            width: 24.w,
                            height: 24.h,
                          ),
                          backgroundColor: AppColors.red,
                          textColor: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 15.h),
              ],
            ),
          ),

          // ================= TAB BAR =================
          SliverPersistentHeader(
            pinned: true,
            delegate: TabBarDelegate(
              TabBar(
                controller: tabController,
                indicatorColor: AppColors.secondColor,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: AppColors.white,
                unselectedLabelColor: AppColors.white,
                dividerColor: Colors.transparent,

                tabs: [
                  Tab(
                    icon: Assets.icons.list.svg(
                      width: 20.w,
                      height: 20.h,
                    ),
                    text: "Watch List",
                  ),

                  Tab(
                    icon: Assets.icons.folder.svg(
                      width: 20.w,
                      height: 20.h,
                    ),
                    text: "History",
                  ),
                ],
              ),
            ),
          ),

          // ================= TAB CONTENT =================
        ],
        body: TabBarView(
          controller: tabController,
          children: [
            // ================= WATCH LIST =================
            Center(
              child: Assets.images.empty.image(width: 120.w, height: 120.h),
            ),

            // ================= HISTORY =================
            GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),

              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 20,
                childAspectRatio: 0.62,
              ),

              itemCount: 15,

              itemBuilder: (context, index) {
                return const MovieGridItem();
              },
            ),
          ],
        ),
      ),
    );
  }
}