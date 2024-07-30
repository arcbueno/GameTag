import 'package:flutter/material.dart';
import 'package:game_tag/utils/sized_box_extension.dart';
import 'package:game_tag/widgets/custom_form_field.dart';

class SignUpForm extends StatelessWidget {
  final GlobalKey formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController usernameController;
  final Function() onBackToLogin;

  const SignUpForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.usernameController,
    required this.onBackToLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: onBackToLogin,
                  icon: const Icon(Icons.arrow_back_ios_sharp)),
              Text(
                'SignUp',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          24.h,
          CustomFormField(
            label: 'Username',
            controller: usernameController,
          ),
          12.h,
          CustomFormField(
            label: 'Email',
            controller: emailController,
          ),
          12.h,
          CustomFormField(
            label: 'Password',
            controller: passwordController,
            isPassword: true,
          ),
          12.h,
          CustomFormField(
            label: 'Confirm Password',
            controller: confirmPasswordController,
            isPassword: true,
          ),
        ],
      ),
    );
  }
}
