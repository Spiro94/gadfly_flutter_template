// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Shared_Input extends StatefulWidget {
  const Shared_Input({
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.keyboardType,
    required this.textInputAction,
    this.obscureText = false,
    this.onValidate,
    this.onFieldSubmitted,
    this.inputFormatters,
    super.key,
  });

  /// The label for the field
  final String label;

  /// The controller for the field
  final TextEditingController controller;

  /// The focus node of the field
  final FocusNode focusNode;

  /// The type of the field's keyboard
  final TextInputType keyboardType;

  /// A list of input formatters for the field
  final List<TextInputFormatter>? inputFormatters;

  final void Function(String)? onFieldSubmitted;

  /// A callback when validating the field
  final String? Function(String? value)? onValidate;

  /// The keyboard action when done editing the field
  final TextInputAction textInputAction;

  /// Whether or not the text is obscured
  final bool obscureText;

  @override
  State<Shared_Input> createState() => _Shared_InputState();
}

class _Shared_InputState extends State<Shared_Input> {
  final formFieldKey = GlobalKey<FormFieldState<dynamic>>();

  /// We want to validate `TextFormField.onTapOutside`, but only if the form
  /// field has been interacted with. We use [isDirty] to determine if the
  /// field has been interacted with.
  bool isDirty = false;

  bool hasBeenValidated = false;

  /// A callback that is run when validating the field
  String? validator(String? postalCode) {
    if (!hasBeenValidated) {
      setState(() {
        hasBeenValidated = true;
      });
    }
    return widget.onValidate!.call(postalCode);
  }

  /// If the field has been interacted with, mark it as [isDirty]. If the field
  /// has been previously validated, then we want to validate on every change.
  void onChanged(String _) {
    if (!isDirty) {
      setState(() {
        isDirty = true;
      });
    }
    if (hasBeenValidated) {
      formFieldKey.currentState?.validate();
    }
  }

  /// If a user taps outside of this field, then we want to:
  /// - release focus
  /// - validate if [isDirty]
  void onTapOutside(PointerDownEvent _) {
    widget.focusNode.unfocus();
    if (isDirty) {
      formFieldKey.currentState?.validate();
    }
  }

  /// When a user is done editing this field (e.g. pressing enter), then we want
  /// to:
  /// - release focus to the next
  /// - validate
  void onEditingComplete() {
    if (widget.textInputAction == TextInputAction.done) {
      widget.focusNode.unfocus();
      formFieldKey.currentState?.validate();
      return;
    }

    if (widget.textInputAction == TextInputAction.next) {
      widget.focusNode.nextFocus();
      formFieldKey.currentState?.validate();
    }
  }

  /// This is to ensure we do not exceed SalesForce's character limit. While we
  /// may not be using Salesforce at the moment, this is still a sane upper
  /// limit.
  final int _maxCharacterLimit = 254;

  void _refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_refresh);
    widget.focusNode.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_refresh);
    widget.focusNode.removeListener(_refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showCloseIcon =
        widget.focusNode.hasFocus && widget.controller.text.isNotEmpty;

    return TextFormField(
      key: formFieldKey,
      maxLength: _maxCharacterLimit,
      controller: widget.controller,
      focusNode: widget.focusNode,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType,
      validator: widget.onValidate != null ? validator : null,
      onChanged: onChanged,
      onTapOutside: onTapOutside,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        label: Text(widget.label),
        errorMaxLines: 3,
        counterText: '',
        suffixIcon: IgnorePointer(
          ignoring: !showCloseIcon,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: showCloseIcon ? 1 : 0,
            child: ExcludeFocus(
              child: IconButton(
                icon: const Icon(Icons.cancel_outlined),
                onPressed: () {
                  widget.controller.clear();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
