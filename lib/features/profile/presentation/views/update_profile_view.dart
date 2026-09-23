import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movies_app/core/gen/assets.gen.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/widgets/custom_app_bar.dart';
import 'package:movies_app/core/widgets/custom_button.dart';
import 'package:movies_app/core/widgets/custom_text_form_field.dart';

import '../cubit/update_profile_cubit.dart';
import '../cubit/update_profile_states.dart';


class UpdateProfileView extends StatefulWidget {
  const UpdateProfileView({super.key});

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  AssetGenImage _selectedAvatar = Assets.images.gamer1;
  String _storedName = '';
  String _storedPhone = '';
  bool _submitting = false;

  final UpdateProfileCubit _cubit = UpdateProfileCubit();
  late final StreamSubscription<UpdateProfileState> _profileSubscription;

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _storedName);
    _phoneController = TextEditingController(text: _storedPhone);

    _profileSubscription = _cubit.stream.listen((state) {
      if (state is UpdateProfileLoaded) {
        if (!mounted) return;
        setState(() {
          _storedName = state.name;
          _storedPhone = state.phone;
          _selectedAvatar = state.avatar;
          _nameController.text = state.name;
          _phoneController.text = state.phone;
        });
      }
    });
    _cubit.loadProfile();
  }

  @override
  void dispose() {
    _profileSubscription.cancel();
    _nameController.dispose();
    _phoneController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _clearIfCurrent(TextEditingController controller, String storedValue) {
    if (controller.text == storedValue) {
      controller.clear();
    }
  }

  void _submitUpdate() {
    EasyLoading.show(status: 'Updating profile...');
    if (_submitting) return;
    _submitting = true;
    _cubit.updateProfile(
      name: _nameController.text,
      phone: _phoneController.text,
      avatar: _selectedAvatar,
    );
  }

  Future<void> _pickAvatar() async {
    final AssetGenImage? avatar = await showModalBottomSheet<AssetGenImage>(
      context: context,
      backgroundColor: AppColors.grey,
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 16.w,
              children: List.generate(UpdateProfileCubit.avatars.length, (int index) {
                final AssetGenImage avatar = UpdateProfileCubit.avatars[index];
                final bool isSelected = avatar == _selectedAvatar;
                return GestureDetector(
                  onTap: () => Navigator.pop(sheetContext, avatar),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.secondColor
                          : AppColors.transparent,
                      border: Border.all(color: AppColors.secondColor),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: avatar.image(fit: BoxFit.contain),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
    if (avatar != null) {
      setState(() {
        _selectedAvatar = avatar;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Pick Avatar",
          leading: Assets.icons.arrowBack.svg(),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 260.h),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickAvatar,
                      child: _selectedAvatar.image(
                        height: 150.h,
                        width: 150.w,
                      ),
                    ),
                    SizedBox(height: 35.h),
                    Listener(
                      onPointerDown: (_) {
                        _clearIfCurrent(_nameController, _storedName);
                      },
                      child: CustomTextFormField(
                        controller: _nameController,
                        prefixIcon: Assets.icons.user.svg(),
                        hintText: _nameController.text,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Listener(
                      onPointerDown: (_) {
                        _clearIfCurrent(_phoneController, _storedPhone);
                      },
                      child: CustomTextFormField(
                        controller: _phoneController,
                        prefixIcon: Assets.icons.phoneUser.svg(),
                        hintText: _phoneController.text,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Reset Password",
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppColors.mainText,
                        ),
                      ),
                    ),

                    // Spacer(),
                  ],
                ),
              ),
              Positioned(
                bottom: 15.h,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    CustomButton(
                      text: "Delete Account",
                      onPressed: () {},
                      backgroundColor: AppColors.red,
                      textColor: AppColors.mainText,
                    ),
                    SizedBox(height: 20.h),
                    BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
                      bloc: _cubit,
                      listener: (context, state) {
                        if (state is UpdateProfileSuccess) {
                          EasyLoading.dismiss();
                          Navigator.pop(context, state);
                          Fluttertoast.showToast(
                            msg: 'Profile Updated Successfully',
                            gravity: ToastGravity.TOP,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                          );
                        }
                        if (state is UpdateProfileFailure) {
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
                          text: "Update Data",
                          onPressed: _submitting ? null : _submitUpdate,
                          backgroundColor: AppColors.secondColor,
                          textColor: AppColors.mainColor,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}