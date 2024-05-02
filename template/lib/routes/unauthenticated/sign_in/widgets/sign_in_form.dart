import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/sign_in/bloc.dart';
import '../../../../blocs/sign_in/event.dart';
import '../../../../theme/theme.dart';
import 'email_input.dart';
import 'password_input.dart';
import 'sign_in_button.dart';

class SignIn_SignInForm extends StatefulWidget {
  const SignIn_SignInForm({super.key});

  @override
  State<SignIn_SignInForm> createState() => _SignIn_SignInFormState();
}

class _SignIn_SignInFormState extends State<SignIn_SignInForm> {
  final _formKey = GlobalKey<FormState>();
  bool hasSubmitted = false;

  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();

  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    emailController.addListener(_refresh);
    emailFocusNode.addListener(_refresh);

    passwordController.addListener(_refresh);
    passwordFocusNode.addListener(_refresh);
  }

  void _refresh() {
    setState(() {});
  }

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();

    passwordController.dispose();
    passwordFocusNode.dispose();

    super.dispose();
  }

  bool _areFieldsAnswered() {
    return emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty;
  }

  void _onSubmitted() {
    if (!_areFieldsAnswered()) {
      return;
    }

    if (!hasSubmitted) {
      setState(() {
        hasSubmitted = true;
      });
    }

    final sm = ScaffoldMessenger.of(context);
    sm.hideCurrentSnackBar();

    if (_formKey.currentState!.validate()) {
      context.read<SignInBloc>().add(
            SignInEvent_SignIn(
              email: emailController.text,
              password: passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: hasSubmitted
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SignIn_EmailInput(
            controller: emailController,
            focusNode: emailFocusNode,
          ),
          SizedBox(
            height: context.tokens.spacing.large,
          ),
          SignIn_PasswordInput(
            controller: passwordController,
            focusNode: passwordFocusNode,
            onSubmitted: (value) => _onSubmitted(),
          ),
          SizedBox(
            height: context.tokens.spacing.large,
          ),
          Row(
            children: [
              SignIn_SignInButton(
                areFieldsAnswered: _areFieldsAnswered(),
                onPressed: _onSubmitted,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
