import 'package:flutter/material.dart';

class PasswordTextFormField extends StatelessWidget {
  final bool obserText;
  final FormFieldValidator<String>? validator;
  final String name;
  final VoidCallback? onTap; // Đổi thành nullable để đồng bộ với cách sử dụng
  final void Function(String)? onChanged;

  const PasswordTextFormField({
    super.key,
    required this.obserText,
    required this.validator,
    required this.name,
    required this.onChanged,
    this.onTap, // Đổi thành nullable
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Đồng bộ với MyTextFormField
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction, // Hiển thị lỗi ngay khi người dùng tương tác
        obscureText: obserText,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: name,
          hintStyle: const TextStyle(color: Colors.black), // Giữ nguyên hintStyle
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0), // Đồng bộ với MyTextFormField
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.blue), // Đồng bộ với MyTextFormField
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.red), // Đồng bộ với MyTextFormField
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.red), // Đồng bộ với MyTextFormField
          ),
          errorStyle: const TextStyle(color: Colors.red, fontSize: 14), // Đồng bộ với MyTextFormField
          suffixIcon: GestureDetector(
            onTap: onTap,
            child: Icon(
              obserText ? Icons.visibility : Icons.visibility_off,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}