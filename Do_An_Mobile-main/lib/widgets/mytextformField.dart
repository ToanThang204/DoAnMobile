import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final FormFieldValidator<String>? validator;
  final void Function(String)? onChanged;
  final String name;

  const MyTextFormField({
    super.key,
    required this.validator,
    required this.name,
    required this.onChanged, 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction, // Hiển thị lỗi ngay khi người dùng tương tác
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: name,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.blue),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}