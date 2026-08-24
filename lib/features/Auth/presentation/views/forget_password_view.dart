import 'package:flutter/material.dart';
import 'package:movies_app/core/gen/assets.gen.dart';
import 'package:movies_app/core/theme/app_strings.dart';
import 'package:movies_app/core/widgets/custom_app_bar.dart';
import 'package:movies_app/core/widgets/custom_button.dart';
import 'package:movies_app/core/widgets/custom_text_form_field.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.forgetPassword,
        leading: Assets.icons.arrowBack.svg(),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 24,
            children: [
              Assets.images.forgotPasswordBro1.image(),
              CustomTextFormField(
                prefixIcon: Assets.icons.email.svg(),
                hintText: AppStrings.email,
                keyboardType: TextInputType.emailAddress,
              ),
              CustomButton(text: AppStrings.verifyEmail, onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
