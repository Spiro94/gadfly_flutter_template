import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/sign_in/bloc.dart';
import '../../../../../blocs/sign_in/event.dart';
import '../../../../../theme/theme.dart';
import 'email_input.dart';
import 'forgot_password_link.dart';
import 'password_input.dart';
import 'sign_in_button.dart';

class SignInC_SignInForm extends StatefulWidget {
  const SignInC_SignInForm({super.key});

  @override
  State<SignInC_SignInForm> createState() => _SignInC_SignInFormState();
}

class _SignInC_SignInFormState extends State<SignInC_SignInForm> {
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
          SignInC_EmailInput(
            controller: emailController,
            focusNode: emailFocusNode,
            nextFocusNode: passwordFocusNode,
          ),
          SizedBox(
            height: context.tokens.spacing.large,
          ),
          SignInC_PasswordInput(
            controller: passwordController,
            focusNode: passwordFocusNode,
            onSubmitted: (value) => _onSubmitted(),
          ),
          SizedBox(
            height: context.tokens.spacing.large,
          ),
          Row(
            children: [
              SignInC_SignInButton(
                areFieldsAnswered: _areFieldsAnswered(),
                onPressed: _onSubmitted,
              ),
              SizedBox(
                width: context.tokens.spacing.medium,
              ),
              const Expanded(
                child: SignInC_ForgotPasswordLink(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
