import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';
import 'text_style.dart';

class TextInputField extends StatelessWidget {
  const TextInputField(
      {required this.name,
      this.titleStyle,
      this.title,
      this.titlePadding,
      this.obscureText = false,
      this.readyOnly = false,
      this.onTap,
      this.label,
      this.validator,
      this.initialValue,
      this.controller,
      this.labelStyle,
      this.inputTextStyle,
      this.hintText,
      this.keyboardType,
      this.inputFormatters,
      this.maxLength,
      this.borderRadius = 16,
      this.suffixIcon,
      this.suffixIconConstraints,
      this.contentPadding = const EdgeInsets.all(16),
      this.onChanged,
      this.onSaved,
      this.hasUnderLineBorder = false,
      this.hasBorder = true,
      this.focusNode,
      this.onSubmitted,
      this.counter,
      this.isDense = true,
      this.filled = false,
      this.fillColor,
      this.hintStyle,
      this.isEnabled = true,
      this.errorMaxLines,
      this.errorText,
      super.key,
      this.autoValidateMode,
      this.prefixIcon,
      this.prefixConstraints,
      this.suffix,
      this.maxLines = 1,
      this.minLines = 1,
      this.borderColor,
      this.backgroundColor,
      this.isRequired = false,
      this.maxLengthEnforcement});

  final FocusNode? focusNode;
  final int? maxLines;
  final int? minLines;
  final Function()? onSubmitted;
  final String name;
  final Color? borderColor;
  final Color? backgroundColor;
  final String? label;
  final String? title;
  final EdgeInsetsGeometry? titlePadding;
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final bool readyOnly;
  final TextStyle? labelStyle;
  final TextStyle? inputTextStyle;
  final TextStyle? titleStyle;
  final void Function()? onTap;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int? errorMaxLines;
  final String? errorText;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final double borderRadius;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final String? hintText;
  final TextStyle? hintStyle;
  final AutovalidateMode? autoValidateMode;
  final EdgeInsetsGeometry contentPadding;
  final Widget? prefixIcon;
  final BoxConstraints? prefixConstraints;
  final Widget? suffix;
  final bool hasUnderLineBorder;
  final bool hasBorder;
  final bool isEnabled;
  final Widget? counter;
  final bool isDense;
  final void Function(String? value)? onChanged;
  final void Function(String? value)? onSaved;
  final bool filled;
  final Color? fillColor;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      cursorColor: AppColors.kBlack,
      maxLines: maxLines,
      minLines: minLines,
      focusNode: focusNode,
      onEditingComplete: onSubmitted,
      onSubmitted: (String? value) {
        onSubmitted?.call();
      },
      onSaved: onSaved,
      controller: controller,
      onTap: onTap,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      enabled: isEnabled,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      style: inputTextStyle ?? AppTextStyles.kw700Black14,
      decoration: InputDecoration(
        label: Text(label ?? hintText ?? ''),
        labelStyle: labelStyle,
        hintText: hintText,
        hintStyle: hintStyle,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        prefixIcon: prefixIcon,
        prefixIconConstraints: prefixConstraints,
        counter: counter,
        isDense: isDense,
        filled: filled,
        fillColor: fillColor,
        contentPadding: contentPadding,
        suffix: suffix,
        suffixIcon: suffixIcon,
        suffixIconConstraints: suffixIconConstraints,
        enabledBorder: _buildOutlineInputBorder(),
        errorBorder: _buildOutlineInputBorder(),
        border: _buildOutlineInputBorder(),
        focusedErrorBorder: _buildOutlineInputBorder(),
        focusedBorder: _buildOutlineFocusedBorder(),
        alignLabelWithHint: true,
      ),
      obscureText: obscureText,
      readOnly: readyOnly,
      name: name,
      initialValue: initialValue,
      onChanged: onChanged,
    );
  }

  InputBorder _buildOutlineInputBorder() => hasUnderLineBorder
      ? UnderlineInputBorder(
          borderSide: BorderSide(
            color: borderColor ?? AppColors.kOutline,
          ),
        )
      : hasBorder
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius.r),
              borderSide: BorderSide(color: borderColor ?? AppColors.kOutline),
            )
          : InputBorder.none;

  InputBorder _buildOutlineFocusedBorder() => hasUnderLineBorder
      ? const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.kBlack),
        )
      : hasBorder
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius.r),
              borderSide: BorderSide(color: borderColor ?? AppColors.kBlack),
            )
          : InputBorder.none;
}
