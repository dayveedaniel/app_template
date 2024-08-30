import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_project_template/assets/app_sizes.dart';
import 'package:new_project_template/assets/text_styles.dart';
import 'package:new_project_template/util/validators.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.onChanged,
    this.labelTextKey,
    this.initialValue,
    this.decoration,
    this.onEditingComplete,
    this.controller,
    this.enabled,
    this.validator,
    this.style,
    this.keyboardType,
    this.readOnly = false,
    this.textFormatters,
    this.scrollPadding,
    this.textAlign,
    this.autoValidateMode,
    this.textInputAction,
    this.obscureText = false,
    this.autofocus = false,
    this.focusNode,
  });

  final ValueSetter<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final String? labelTextKey;
  final String? initialValue;
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final TextStyle? style;
  final bool? enabled;
  final bool readOnly;
  final bool obscureText;
  final bool autofocus;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? textFormatters;
  final AutovalidateMode? autoValidateMode;
  final EdgeInsets? scrollPadding;
  final TextAlign? textAlign;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      autofocus: autofocus,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      controller: controller,
      scrollPadding: scrollPadding ?? const EdgeInsets.all(20),
      onChanged: onChanged,
      textAlign: textAlign ?? TextAlign.start,
      onEditingComplete: onEditingComplete,
      initialValue: initialValue,
      style: style ?? AppTextStyles.s16w400,
      autovalidateMode: autoValidateMode,
      validator: validator,
      cursorHeight: Sizes.p24,
      cursorWidth: Sizes.p1_5,
      cursorRadius: const Radius.circular(999),
      textInputAction: textInputAction,
      contextMenuBuilder: _buildContextMenu,
      keyboardType: keyboardType,
      inputFormatters: textFormatters,
      decoration: decoration ?? InputDecoration(labelText: labelTextKey?.tr()),
    );
  }
}

Widget _buildContextMenu(
  BuildContext context,
  EditableTextState editableTextState,
) {
  return AdaptiveTextSelectionToolbar.buttonItems(
    anchors: editableTextState.contextMenuAnchors,
    buttonItems: <ContextMenuButtonItem>[
      if (editableTextState.cutEnabled)
        ContextMenuButtonItem(
          onPressed: () =>
              editableTextState.cutSelection(SelectionChangedCause.toolbar),
          type: ContextMenuButtonType.cut,
        ),
      if (editableTextState.copyEnabled)
        ContextMenuButtonItem(
          onPressed: () =>
              editableTextState.copySelection(SelectionChangedCause.toolbar),
          type: ContextMenuButtonType.copy,
        ),
      if (editableTextState.selectAllEnabled)
        ContextMenuButtonItem(
          onPressed: () =>
              editableTextState.selectAll(SelectionChangedCause.toolbar),
          type: ContextMenuButtonType.selectAll,
        ),
      if (editableTextState.pasteEnabled)
        ContextMenuButtonItem(
          onPressed: () =>
              editableTextState.pasteText(SelectionChangedCause.toolbar),
          type: ContextMenuButtonType.paste,
        ),
    ],
  );
}

class EmailField extends StatelessWidget {
  const EmailField({
    super.key,
    required this.onChanged,
    this.initialValue,
    this.enabled,
  });

  final ValueSetter<String> onChanged;
  final String? initialValue;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      onChanged: onChanged,
      initialValue: initialValue,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: Validators.emailValidator,
      enabled: enabled,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      labelTextKey: 'createAccount.email',
    );
  }
}
