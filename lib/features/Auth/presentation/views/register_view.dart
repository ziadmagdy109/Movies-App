import 'package:flutter/material.dart';
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

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.register,
        leading: Assets.icons.arrowBack.svg(),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          spacing: 24,
          children: [
            SelectAvatar(),
            CustomTextFormField(
              prefixIcon: Assets.icons.name.svg(),
              hintText: AppStrings.name,
              keyboardType: TextInputType.name,
            ),
            CustomTextFormField(
              prefixIcon: Assets.icons.email.svg(),
              hintText: AppStrings.email,
              keyboardType: TextInputType.emailAddress,
            ),
            CustomTextFormField(
              prefixIcon: Assets.icons.password.svg(),
              hintText: AppStrings.password,
              suffixIcon: Assets.icons.visible.svg(),
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
            ),
            CustomTextFormField(
              prefixIcon: Assets.icons.password.svg(),
              hintText: AppStrings.confirmPassword,
              suffixIcon: Assets.icons.visible.svg(),
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
            ),
            CustomTextFormField(
              prefixIcon: Assets.icons.phone.svg(),
              hintText: AppStrings.phone,
              keyboardType: TextInputType.phone,
            ),
            CustomButton(
              text: AppStrings.createOne,
              onPressed: () => navigatorKey.currentState!.pushReplacementNamed(
                AppRouteName.login,
              ),
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
    );
  }
}
