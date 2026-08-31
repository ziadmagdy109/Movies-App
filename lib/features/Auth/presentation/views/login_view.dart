import 'package:flutter/material.dart';
import 'package:movies_app/core/gen/assets.gen.dart';
import 'package:movies_app/core/routing/app_route_name.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_strings.dart';
import 'package:movies_app/core/widgets/custom_button.dart';
import 'package:movies_app/core/widgets/custom_text_form_field.dart';
import 'package:movies_app/features/Auth/presentation/widgets/have_account.dart';
import 'package:movies_app/features/Auth/presentation/widgets/language_switcher.dart';
import 'package:movies_app/features/Auth/presentation/widgets/or_divider.dart';
import 'package:movies_app/main.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Assets.icons.splashicon.image(),
              CustomTextFormField(
                prefixIcon: Assets.icons.email.svg(height: 20, width: 20),
                hintText: AppStrings.email,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 22),
              CustomTextFormField(
                prefixIcon: Assets.icons.password.svg(height: 20, width: 20),
                hintText: AppStrings.password,
                suffixIcon: Assets.icons.visible.svg(height: 20, width: 20),
                keyboardType: TextInputType.visiblePassword,
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
                    // textAlign: TextAlign.end,
                  ),
                ),
              ),
              SizedBox(height: 34),
              CustomButton(
                text: AppStrings.login,
                onPressed: () {
                  navigatorKey.currentState!.pushNamed(AppRouteName.layout);
                },
              ), // Init Nav To Main Layout
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
              CustomButton(
                icon: Assets.icons.iconGoogle.svg(),
                text: AppStrings.loginWithGoogle,
                onPressed: () {},
              ),
              SizedBox(height: 34),
              LanguageSwitcher(),
            ],
          ),
        ),
      ),
    );
  }
}
