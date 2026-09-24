import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movies_app/core/gen/assets.gen.dart';
import 'package:movies_app/core/routing/app_route_name.dart';
import 'package:movies_app/core/services/auth_preferences.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/widgets/custom_button.dart';
import 'package:movies_app/main.dart';

import '../../../../core/widgets/movie_grid_item.dart';
import '../../../Auth/presentation/cubit/signout_cubit.dart';
import '../../../library/presentation/cubit/user_library_cubit.dart';
import '../../../library/presentation/cubit/user_library_state.dart';
import '../cubit/update_profile_cubit.dart';
import '../cubit/update_profile_states.dart';

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
  final UpdateProfileCubit _profileCubit = UpdateProfileCubit();
  late final StreamSubscription<UpdateProfileState> _profileSubscription;

  // Profile data now lives in state so it can be refreshed after editing.
  AssetGenImage _avatar = Assets.images.gamer1;
  String _name = '';

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);

    _profileSubscription = _profileCubit.stream.listen((state) {
      if (!mounted) return;
      if (state is UpdateProfileLoaded) {
        setState(() {
          _name = state.name;
          _avatar = state.avatar;
        });
      } else if (state is UpdateProfileSuccess) {
        setState(() {
          _name = state.name;
          _avatar = state.avatar;
        });
      }
    });
    _profileCubit.loadProfile();
  }

  @override
  void dispose() {
    _profileSubscription.cancel();
    _profileCubit.close();
    tabController.dispose();
    super.dispose();
  }

  Future<void> _goToEditProfile() async {
    final result = await navigatorKey.currentState!
        .pushNamed(AppRouteName.updateProfile);

    if (result is UpdateProfileSuccess) {
      if (mounted) {
        setState(() {
          _name = result.name;
          _avatar = result.avatar;
        });
      }
    } else {
      await _profileCubit.loadProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => SignOutCubit(),
      child: Scaffold(
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
                        child: _avatar.image(
                          width: 118.w,
                          height: 118.h,
                        ),
                      ),

                      Expanded(
                        child: Column(
                          children: [
                            BlocBuilder<UserLibraryCubit, UserLibraryState>(
                              builder: (context, state) {
                                return Text(
                                  '${context.read<UserLibraryCubit>().favorites.length}',
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                    color: AppColors.mainText,
                                  ),
                                );
                              },
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
                            BlocBuilder<UserLibraryCubit, UserLibraryState>(
                              builder: (context, state) {
                                return Text(
                                  '${context.read<UserLibraryCubit>().history.length}',
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                    color: AppColors.mainText,
                                  ),
                                );
                              },
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
                        _name,
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
                            onPressed: _goToEditProfile,
                          ),
                        ),

                        SizedBox(width: 10.w),

                        Expanded(
                          flex: 2,
                          child: BlocConsumer<SignOutCubit, SignOutState>(
                            listener: (context, state) {
                              if (state is SignOutSuccess) {
                                navigatorKey.currentState!.pushNamedAndRemoveUntil(
                                  AppRouteName.login,
                                      (route) => false,
                                );
                              }

                              if (state is SignOutFailure) {
                                Fluttertoast.showToast(
                                  msg: state.error,
                                  gravity: ToastGravity.TOP,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                );
                              }
                            },
                            builder: (context, state) {
                              return CustomButton(
                                backgroundColor: AppColors.red,
                                textColor: AppColors.white,
                                text: 'Exit',
                                onPressed: state is SignOutLoading
                                    ? null
                                    : () async {
                                  await AuthPreferences.clearEmail();
                                  context.read<SignOutCubit>().signOut();
                                },
                              );
                            },
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
          body: BlocBuilder<UserLibraryCubit, UserLibraryState>(
            builder: (context, state) {
              final userLibrary = context.read<UserLibraryCubit>();
              final favorites = userLibrary.favorites;
              final history = userLibrary.history;

              return TabBarView(
                controller: tabController,
                children: [
                  // ================= WATCH LIST =================
                  favorites.isEmpty
                      ? Center(
                          child: Assets.images.empty.image(
                            width: 120.w,
                            height: 120.h,
                          ),
                        )
                      : GridView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 20,
                            childAspectRatio: 0.62,
                          ),
                          itemCount: favorites.length,
                          itemBuilder: (context, index) =>
                              MovieGridItem(movies: favorites[index].toMovies()),
                        ),

                  // ================= HISTORY =================
                  history.isEmpty
                      ? Center(
                          child: Assets.images.empty.image(
                            width: 120.w,
                            height: 120.h,
                          ),
                        )
                      : GridView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 20,
                            childAspectRatio: 0.62,
                          ),
                          itemCount: history.length,
                          itemBuilder: (context, index) =>
                              MovieGridItem(movies: history[index].toMovies()),
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}