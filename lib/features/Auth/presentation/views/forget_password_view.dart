import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movies_app/core/gen/assets.gen.dart';
import 'package:movies_app/core/theme/app_strings.dart';
import 'package:movies_app/core/widgets/custom_app_bar.dart';
import 'package:movies_app/core/widgets/custom_button.dart';
import 'package:movies_app/core/widgets/custom_text_form_field.dart';
import 'package:movies_app/main.dart';

import '../../../../core/utils/validation_rules.dart';
import '../cubit/forget_password_cubit.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    final formKey = GlobalKey<FormState>();
    void onSubmit(BuildContext context) {
      if (formKey.currentState!.validate()) {
        context.read<ForgetPasswordCubit>().resetPassword(
          emailController.text,
        );
      }
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.forgetPassword,
        leading: Assets.icons.arrowBack.svg(),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Column(
              spacing: 24,
              children: [
                Assets.images.forgotPasswordBro1.image(),
                CustomTextFormField(
                  prefixIcon: Assets.icons.email.svg(),
                  hintText: AppStrings.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: ValidationRules().email,
                  controller: emailController,
                ),

                BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
                  listener: (context, state) async {
                    if (state is ForgetPasswordLoading) {
                    await  EasyLoading.show(status: "Sending password reset email...");
                    }
                    if (state is ForgetPasswordSuccess) {
                      EasyLoading.dismiss();
                      Fluttertoast.showToast(
                        msg: "Password reset email sent!",
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                      );
                      navigatorKey.currentState!.pop();
                    } else if (state is ForgetPasswordFailure) {
                      EasyLoading.dismiss();
                      Fluttertoast.showToast(
                        msg: state.errorMessage,
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ForgetPasswordLoading) {
                      return const CircularProgressIndicator();
                    } else {
                      return CustomButton(
                        text: AppStrings.verifyEmail,
                        onPressed: () => onSubmit(context),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
