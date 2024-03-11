import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../blocs/forgot_password/bloc.dart';
import '../../../../../../blocs/forgot_password/event.dart';
import '../../../../../../theme/theme.dart';
import '../connector/email_input.dart';
import '../connector/reset_password_button.dart';

class ForgotPasswordM_ResetPasswordForm extends StatefulWidget {
  const ForgotPasswordM_ResetPasswordForm({super.key});

  @override
  State<ForgotPasswordM_ResetPasswordForm> createState() =>
      _ForgotPasswordM_ResetPasswordFormState();
}

class _ForgotPasswordM_ResetPasswordFormState
    extends State<ForgotPasswordM_ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  bool hasSubmitted = false;

  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    emailController.addListener(_refresh);
    emailFocusNode.addListener(_refresh);
  }

  void _refresh() {
    setState(() {});
  }

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();

    super.dispose();
  }

  bool _areFieldsAnswered() {
    return emailController.text.trim().isNotEmpty;
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
      context.read<ForgotPasswordBloc>().add(
            ForgotPasswordEvent_ForgotPassword(
              email: emailController.text,
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
          ForgotPasswordC_EmailInput(
            controller: emailController,
            focusNode: emailFocusNode,
            onSubmitted: (value) => _onSubmitted(),
          ),
          SizedBox(
            height: context.tokens.spacing.large,
          ),
          Row(
            children: [
              ForgotPasswordC_ResetPasswordButton(
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
