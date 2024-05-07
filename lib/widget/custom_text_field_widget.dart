import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  final String? hint;
  final Widget? preIcon;
  final TextEditingController? controller;
  final Widget? suffIcon;
  final bool? obsecured;
  final String? label;
  final TextInputType? inputType;
  final int? maxLines;
  final List<TextInputFormatter>? formatter;
  final Color? color;
  final int? maxLength;
  final bool? enabled;
  final Function(String)? onChange;

  const TextFieldWidget({
    super.key,
    this.hint,
    this.preIcon,
    this.suffIcon,
    @required this.controller,
    this.obsecured,
    this.label,
    this.inputType,
    this.maxLines,
    this.formatter,
    this.color,
    this.maxLength,
    this.enabled,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.blue),
      child: TextField(
        enabled: enabled ?? true,
        inputFormatters: formatter,
        controller: controller,
        obscureText: obsecured != null ? obsecured! : false,
        keyboardType: inputType,
        maxLines: maxLines ?? 1,
        minLines: 1,
        maxLength: maxLength,
        onTapOutside: (focusNode) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        style: TextStyle(
          color: color ?? Colors.black,
        ),
        onChanged: onChange,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade100,
          alignLabelWithHint: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: maxLines != null ? Colors.transparent : Theme.of(context).primaryColor,
                width: 1.5,
              )),
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
          suffixIcon: suffIcon,
          prefixIcon: preIcon,
          hintText: hint ?? "",
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
            height: 2.5,
          ),
        ),
      ),
    );
  }
}
