import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movies_app/core/gen/assets.gen.dart';
import 'package:movies_app/core/routing/app_route_name.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_strings.dart';
import 'package:movies_app/core/widgets/custom_button.dart';
import 'package:movies_app/core/widgets/custom_text_form_field.dart';
import 'package:movies_app/features/Auth/presentation/cubit/signin_cubit.dart';
import 'package:movies_app/features/Auth/presentation/widgets/have_account.dart';
import 'package:movies_app/features/Auth/presentation/widgets/language_switcher.dart';
import 'package:movies_app/features/Auth/presentation/widgets/or_divider.dart';
import 'package:movies_app/main.dart';

import '../../../../core/utils/validation_rules.dart';
import '../cubit/google_signin_cubit.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final _validationRules = ValidationRules();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      //Call cubit here
      context.read<SignInCubit>().signIn(
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Assets.icons.splashicon.image(),
                CustomTextFormField(
                  controller: _emailController,
                  validator: _validationRules.email,
                  prefixIcon: Assets.icons.email.svg(height: 20, width: 20),
                  hintText: AppStrings.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 22),
                CustomTextFormField(
                  controller: _passwordController,
                  validator: _validationRules.password,
                  prefixIcon: Assets.icons.password.svg(height: 20, width: 20),
                  hintText: AppStrings.password,
                  suffixIcon: IconButton(
                    icon: _obscurePassword
                        ? Assets.icons.closeeye.svg(width: 24.w, height: 24.h)
                        : Assets.icons.eye.svg(width: 24.w, height: 24.h),
                    color: AppColors.secondColor,
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscurePassword,
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => navigatorKey.currentState!.pushNamed(
                      AppRouteName.forgetPassword,
                    ),
                    child: Text(
                      AppStrings.forgetPasswordAppBar,
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: AppColors.secondColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 34),
                BlocConsumer<SignInCubit, SignInState>(
                  listener: (context, state) async {
                    if (state is SignInLoading) {
                      await EasyLoading.show(status: 'Loading...');
                    }
                    if (state is SignInSuccess) {
                      EasyLoading.dismiss();
                      navigatorKey.currentState!.pushReplacementNamed(
                        AppRouteName.layout,
                      );
                      Fluttertoast.showToast(
                        msg: "Successfully Login",
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                      );
                    }
                    if (state is SignInFailure) {
                      EasyLoading.dismiss();
                      Fluttertoast.showToast(
                        msg: "Incorrect Email or Password",
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                  },
                  builder: (context, state) {
                    return CustomButton(
                      text: AppStrings.login,
                      onPressed: _onSubmit,
                    );
                  },
                ),
                SizedBox(height: 22),
                HaveAccount(
                  text: AppStrings.createOne,
                  onCreateAccount: () {
                    navigatorKey.currentState!.pushNamed(AppRouteName.register);
                  },
                ),
                SizedBox(height: 28),
                OrDivider(),
                SizedBox(height: 28),
                BlocConsumer<GoogleSignInCubit, GoogleSignInState>(
                  listener: (context, state) {
                    if (state is GoogleSignInLoading) {
                      EasyLoading.show(status: 'Loading...');
                    }
                    if (state is GoogleSignInSuccess) {
                      EasyLoading.dismiss();
                      navigatorKey.currentState!.pushReplacementNamed(
                        AppRouteName.layout,
                      );
                    }
                    if (state is GoogleSignInError) {
                      EasyLoading.dismiss();
                      Fluttertoast.showToast(
                        msg: state.message,
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                  },
                  builder: (context, state) {
                    return CustomButton(
                      icon: Assets.icons.iconGoogle.svg(),
                      text: AppStrings.loginWithGoogle,
                      onPressed: () {
                        context.read<GoogleSignInCubit>().signInWithGoogle();
                      },
                    );
                  },
                ),
                SizedBox(height: 34),
                LanguageSwitcher(),
                SizedBox(height: 34),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
