import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../outside/theme/theme.dart';
import '../../../../../shared/mixins/logging.dart';
import '../../../../blocs/reset_password/bloc.dart';
import '../../../../blocs/reset_password/events.dart';
import 'button_submit.dart';
import 'input_email.dart';

class ResetPassword_Form_ResetPassword extends StatefulWidget
    with SharedMixin_Logging {
  const ResetPassword_Form_ResetPassword({super.key});

  @override
  State<ResetPassword_Form_ResetPassword> createState() =>
      _ResetPassword_Form_ResetPasswordState();
}

class _ResetPassword_Form_ResetPasswordState
    extends State<ResetPassword_Form_ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  bool _hasSubmittedBefore = false;

  late final TextEditingController passwordController;

  void _refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    passwordController = TextEditingController();
    passwordController.addListener(_refresh);
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    widget.log.info('submitting form');

    setState(() {
      _hasSubmittedBefore = true;
    });

    if (!_formKey.currentState!.validate()) {
      widget.log.warning('form not valid');
      // short-circuit if not valid
      return;
    }
    widget.log.info('form valid');

    context.read<ResetPassword_Bloc>().add(
      ResetPassword_Event_ResetPassword(password: passwordController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode:
          _hasSubmittedBefore
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: context.tokens.spacing.medium),
          ResetPassword_Input_Password(controller: passwordController),
          SizedBox(height: context.tokens.spacing.medium),
          ResetPassword_Button_Submit(onSubmit: _onSubmit),
          SizedBox(height: context.tokens.spacing.medium),
        ],
      ),
    );
  }
}
