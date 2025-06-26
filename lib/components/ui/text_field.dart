import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'text_style.dart';

import 'no_space_text_field.dart';
import 'text_input_field.dart';

typedef CompletionOnChange = Function(String?);

// ignore: must_be_immutable
class InputFields extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  String? errorText;
  String? label;
  CompletionOnChange? onChangeText;
  bool? isNumber;
  bool? isAddress;
  bool? isEmail;
  bool? isNickName;
  bool isUnderline;
  Widget? suffixIcon;
  InputFields({
    super.key,
    required this.hintText,
    required this.controller,
    this.onChangeText,
    this.errorText = '',
    this.isNumber = false,
    this.isNickName = false,
    this.isAddress = false,
    this.suffixIcon,
    this.label,
    this.isEmail = true,
    this.isUnderline = false,
    required String name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextInputField(
          hasUnderLineBorder: isUnderline,
          hintText: hintText,
          hintStyle: AppTextStyles.kw400Secondary14,
          controller: controller,
          name: hintText,
          label: label ?? hintText,
          suffixIcon: suffixIcon,
          inputTextStyle: AppTextStyles.kw700Primary14,
          labelStyle: AppTextStyles.kw400Secondary14,
          keyboardType:
              (isNumber == true) ? TextInputType.number : TextInputType.name,
          inputFormatters: (isAddress == true)
              ? <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(40),
                  NoLeadingSpaceFormatter(),
                  FilteringTextInputFormatter.allow(
                      RegExp("^[\u0000-\u007F]+\$")),
                ]
              : (isNumber == true)
                  ? <TextInputFormatter>[
                      NoLeadingSpaceFormatter(),
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(20),
                    ]
                  : (isNickName == true)
                      ? [
                          // NoSpaceFormatter(),
                          NoLeadingSpaceFormatter(),
                          LengthLimitingTextInputFormatter(80),
                          FilteringTextInputFormatter.allow(RegExp(
                              '[a-zA-Z ]')),
                        ]
                      : (isEmail == false)
                          ? []
                          : [
                              NoLeadingSpaceFormatter(),
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9a-zA-Z.!#%&*+-/=?^_@~|]')
                                  ),
                            ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return errorText;
            }
            return null;
          },
          onChanged: (val) {
            if (isAddress == true || isNickName == true) {
              String text = controller.text;
              text = text.replaceAll(RegExp(r'\s+'), ' ');
              controller.value = TextEditingValue(
                text: text,
                selection: TextSelection.fromPosition(
                  TextPosition(offset: text.length),
                ),
              );
            }
            if (onChangeText != null) {
              onChangeText!(val);
            }
          },
        ),
      ],
    );
  }
}
