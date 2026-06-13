import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../outside/theme/theme.dart';
import '../../../../../../shared/mixins/logging.dart';
import '../../../../../blocs/reset_password/bloc.dart';
import '../../../../../blocs/reset_password/events.dart';
import 'button_submit.dart';
import 'input_email.dart';

class ForgotPassword_Form_ResetPasswordRequest extends StatefulWidget
    with SharedMixin_Logging {
  const ForgotPassword_Form_ResetPasswordRequest({super.key});

  @override
  State<ForgotPassword_Form_ResetPasswordRequest> createState() =>
      _ForgotPassword_Form_ResetPasswordRequestState();
}

class _ForgotPassword_Form_ResetPasswordRequestState
    extends State<ForgotPassword_Form_ResetPasswordRequest> {
  final _formKey = GlobalKey<FormState>();
  bool _hasSubmittedBefore = false;

  late final TextEditingController emailController;

  void _refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();
    emailController.addListener(_refresh);
  }

  @override
  void dispose() {
    emailController.dispose();
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
      ResetPassword_Event_SendResetPasswordLink(email: emailController.text),
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
          ForgotPassword_Input_Email(controller: emailController),
          SizedBox(height: context.tokens.spacing.medium),
          ForgotPassword_Button_Submit(onSubmit: _onSubmit),
          SizedBox(height: context.tokens.spacing.medium),
        ],
      ),
    );
  }
}
