
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movies_app/core/gen/assets.gen.dart';
import 'package:movies_app/core/routing/app_route_name.dart';
import 'package:movies_app/core/theme/app_strings.dart';
import 'package:movies_app/core/widgets/custom_app_bar.dart';
import 'package:movies_app/core/widgets/custom_button.dart';
import 'package:movies_app/core/widgets/custom_text_form_field.dart';
import 'package:movies_app/features/Auth/presentation/widgets/have_account.dart';
import 'package:movies_app/features/Auth/presentation/widgets/language_switcher.dart';
import 'package:movies_app/features/Auth/presentation/widgets/select_avatar.dart';
import 'package:movies_app/main.dart';
import '../../../../core/utils/validation_rules.dart';
import '../cubit/signup_cubit.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _validationRules = ValidationRules();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      //Call cubit here
      context.read<SignUpCubit>().signUp(
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.register,
        leading: Assets.icons.arrowBack.svg(),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 24,
              children: [
                SelectAvatar(),
                CustomTextFormField(
                  controller: _nameController,
                  validator: _validationRules.fullName,
                  prefixIcon: Assets.icons.name.svg(),
                  hintText: AppStrings.name,
                  keyboardType: TextInputType.name,
                ),
                CustomTextFormField(
                  controller: _emailController,
                  validator: _validationRules.email,
                  prefixIcon: Assets.icons.email.svg(),
                  hintText: AppStrings.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomTextFormField(
                  controller: _passwordController,
                  validator: _validationRules.password,
                  prefixIcon: Assets.icons.password.svg(),
                  hintText: AppStrings.password,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: _obscurePassword
                        ? Assets.icons.closeeye.svg(width: 24.w, height: 24.h)
                        : Assets.icons.eye.svg(width: 24.w, height: 24.h),
                  ),
                  obscureText: _obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                ),
                CustomTextFormField(
                  controller: _confirmPasswordController,
                  validator: (value) => _validationRules.confirmPassword(
                    value,
                    _passwordController.text,
                  ),
                  prefixIcon: Assets.icons.password.svg(),
                  hintText: AppStrings.confirmPassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    icon: _obscureConfirmPassword
                        ? Assets.icons.closeeye.svg(width: 24.w, height: 24.h)
                        : Assets.icons.eye.svg(width: 24.w, height: 24.h),
                  ),
                  obscureText: _obscureConfirmPassword,
                  keyboardType: TextInputType.visiblePassword,
                ),
                CustomTextFormField(
                  controller: _phoneController,
                  validator: _validationRules.phone,
                  prefixIcon: Assets.icons.phone.svg(),
                  hintText: AppStrings.phone,
                  keyboardType: TextInputType.phone,
                ),
                BlocConsumer<SignUpCubit, SignUpState>  (
                  listener: (context, state) async {
                    if(state is SignUpLoading) {
                      await EasyLoading.show(status: 'Loading...');
                    }
                    if (state is SignUpSuccess) {
                      EasyLoading.dismiss();
                      navigatorKey.currentState!.pushReplacementNamed(AppRouteName.login);
                      Fluttertoast.showToast(
                        msg:"Successfully Created Account" ,
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                      );
                    }
                    if (state is SignUpFailure) {
                      await EasyLoading.showError('Sign up failed');
                      Fluttertoast.showToast(
                        msg: state.error ?? "Something went wrong",
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                  },
                  builder: (context, state) {
                    return CustomButton(
                      text: AppStrings.createOne,
                      onPressed: _onSubmit,
                    );
                  },
                ),
                HaveAccount(
                  onCreateAccount: () {
                    navigatorKey.currentState!.pushNamed(AppRouteName.login);
                  },
                  text: AppStrings.login,
                ),
                LanguageSwitcher(),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}