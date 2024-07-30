import 'package:flutter/material.dart';
import 'package:game_tag/utils/sized_box_extension.dart';
import 'package:game_tag/widgets/custom_form_field.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const LoginForm(
      {super.key,
      required this.formKey,
      required this.usernameController,
      required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Text(
            'Login',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          24.h,
          CustomFormField(
            label: 'Username',
            controller: usernameController,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: CustomFormField(
              label: 'Password',
              controller: passwordController,
              isPassword: true,
            ),
          ),
        ],
      ),
    );
  }
}
