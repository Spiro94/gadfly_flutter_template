import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/reset_password/bloc.dart';
import '../../../../../blocs/reset_password/event.dart';
import '../../../../../theme/theme.dart';
import '../connector/new_password_text_field.dart';
import '../connector/reset_password_button.dart';

class ResetPasswordM_ResetPasswordForm extends StatefulWidget {
  const ResetPasswordM_ResetPasswordForm({super.key});

  @override
  State<ResetPasswordM_ResetPasswordForm> createState() =>
      _ResetPasswordM_ResetPasswordFormState();
}

class _ResetPasswordM_ResetPasswordFormState
    extends State<ResetPasswordM_ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  bool hasSubmitted = false;

  late TextEditingController newPasswordController;
  late FocusNode newPasswordFocusNode;

  void _refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    newPasswordController = TextEditingController();
    newPasswordFocusNode = FocusNode();

    newPasswordController.addListener(_refresh);
    newPasswordFocusNode.addListener(_refresh);
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    newPasswordFocusNode.dispose();
    super.dispose();
  }

  bool _areFieldsAnswered() {
    return newPasswordController.text.trim().isNotEmpty;
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
      context.read<ResetPasswordBloc>().add(
            ResetPasswordEvent_ResetPassword(
              password: newPasswordController.text,
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
        children: [
          ResetPasswordC_NewPasswordTextField(
            controller: newPasswordController,
            focusNode: newPasswordFocusNode,
            onSubmitted: (_) => _onSubmitted(),
          ),
          SizedBox(height: context.tokens.spacing.large),
          Row(
            children: [
              ResetPasswordC_ResetPasswordButton(
                onPressed: _onSubmitted,
                areFieldsAnswered: _areFieldsAnswered(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
