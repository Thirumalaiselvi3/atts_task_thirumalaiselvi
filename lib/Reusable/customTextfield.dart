import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'color.dart';
import 'formatter.dart';
import 'text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final bool readOnly;
  final TextStyle? textStyle;
  final TextEditingController controller;
  final Color baseColor;
  final Color borderColor;
  final Color? labelColor;
  final Color errorColor;
  final TextInputType inputType;
  final bool obscureText;
  final int maxLength;
  final int? maxLine;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final bool showSuffixIcon;
  final Widget? suffixIcon;
  final Widget? countryCodePicker;
  final String? prefixText;
  final FilteringTextInputFormatter? fTextInputFormatter;
  final bool isUpperCase;
  final bool enableNricFormatter;
  final double? height;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.readOnly,
    required this.controller,
    required this.baseColor,
    required this.borderColor,
    required this.errorColor,
    required this.inputType,
    required this.obscureText,
    required this.maxLength,
    this.maxLine,
    this.onChanged,
    this.onTap,
    this.validator,
    this.labelColor,
    this.textStyle,
    this.showSuffixIcon = false,
    this.suffixIcon,
    this.countryCodePicker,
    this.prefixText,
    this.fTextInputFormatter,
    this.isUpperCase = false,
    this.enableNricFormatter = false,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (countryCodePicker != null) countryCodePicker!,
        Expanded(
          child: Container(

            margin: const EdgeInsets.only(left: 10, right: 10),
            child: TextSelectionTheme(
              data: const TextSelectionThemeData(
                cursorColor: appPrimaryColor,
                selectionColor: appPrimaryColor,
                selectionHandleColor: appPrimaryColor,
              ),
              child: TextFormField(
                style: textStyle ?? ( MediaQuery.of(context).size.width < 650
                    ? MyTextStyle.f16(appButton1Color, weight: FontWeight.w400)
                    : MyTextStyle.f20(appButton1Color, weight: FontWeight.w400)),
                controller: controller,
                readOnly: readOnly,
                obscureText: obscureText,
                keyboardType: inputType,
                expands: false,
                textCapitalization: isUpperCase
                    ? TextCapitalization.characters
                    : TextCapitalization.none,
                inputFormatters: [
                  if (fTextInputFormatter != null) fTextInputFormatter!,
                  if (isUpperCase)
                    FilteringTextInputFormatter.allow(RegExp("[A-Z0-9 ]")),
                  if (enableNricFormatter) NricFormatter(separator: '-'),
                  LengthLimitingTextInputFormatter(maxLength),
                ],
                maxLength: maxLength,
                maxLines: maxLine ?? 1,
                onChanged: onChanged,
                onTap: onTap,
                validator: validator,
                textAlignVertical: TextAlignVertical.top,

                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: height ?? 10.0,
                    horizontal: 10.0,
                  ),
                  counterText: "",
                  hintText: hint,
                  hintStyle: MediaQuery.of(context).size.width < 650
                      ? MyTextStyle.f14(labelColor ?? appButton1Color, weight: FontWeight.w300)
                      : MyTextStyle.f18(labelColor ??appButton1Color, weight: FontWeight.w300),
                  prefixText: prefixText, // Add prefix text
                  prefixStyle: MediaQuery.of(context).size.width < 650
                      ? MyTextStyle.f14(blackColor, weight: FontWeight.w300)
                      : MyTextStyle.f18(blackColor, weight: FontWeight.w300),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: baseColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: errorColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: showSuffixIcon ? suffixIcon : null,

                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
class CustomInputField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final bool isPassword;

  const CustomInputField({super.key,
    required this.icon,
    required this.hintText,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.brown.shade800,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.amber.shade300),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.amber.shade200),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}
