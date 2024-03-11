import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/sign_up/bloc.dart';
import '../../../../../blocs/sign_up/event.dart';
import '../../../../../theme/theme.dart';
import '../connector/email_input.dart';
import '../connector/password_input.dart';
import '../connector/sign_up_button.dart';

class SignUpM_SignUnForm extends StatefulWidget {
  const SignUpM_SignUnForm({super.key});

  @override
  State<SignUpM_SignUnForm> createState() => _SignUpM_SignUnFormState();
}

class _SignUpM_SignUnFormState extends State<SignUpM_SignUnForm> {
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
      context.read<SignUpBloc>().add(
            SignUpEvent_SignUp(
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
          SignUpC_EmailInput(
            controller: emailController,
            focusNode: emailFocusNode,
            nextFocusNode: passwordFocusNode,
          ),
          SizedBox(
            height: context.tokens.spacing.large,
          ),
          SignUpC_PasswordInput(
            controller: passwordController,
            focusNode: passwordFocusNode,
            onSubmitted: (value) => _onSubmitted(),
          ),
          SizedBox(
            height: context.tokens.spacing.large,
          ),
          Row(
            children: [
              SignUpC_SignUpButton(
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
