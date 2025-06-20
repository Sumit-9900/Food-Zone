import 'package:flutter/material.dart';
import 'package:food_admin/core/theme/text_style.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final String? prefixText;
  final int? maxLines;
  const InputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.prefixText,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final middleText = hintText.split(' ').last;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) {
        if (value!.isEmpty) {
          return '$middleText can\'t be empty!';
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFececf8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        prefixText: prefixText,
        hintText: hintText,
        hintStyle: Style.text2,
      ),
    );
  }
}
