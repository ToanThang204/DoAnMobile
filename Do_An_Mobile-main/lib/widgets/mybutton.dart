import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String name;
  final ButtonStyle? style; // Thêm tham số style để tùy chỉnh
  final double? width; // Thêm width để tùy chỉnh chiều rộng
  final double? height; // Thêm height để tùy chỉnh chiều cao

  const MyButton({
    super.key,
    required this.onPressed,
    required this.name,
    this.style, // Không bắt buộc
    this.width, // Không bắt buộc
    this.height, // Không bắt buộc
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: style ?? ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[600], // Màu mặc định giống SignUp
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Bo góc giống SignUp
        ),
        elevation: 5, // Bóng đổ giống SignUp
        minimumSize: Size(width ?? double.infinity, height ?? 50), // Kích thước mặc định giống SignUp
        padding: const EdgeInsets.symmetric(vertical: 16), // Padding giống SignUp
      ),
      child: Text(
        name,
        style: const TextStyle(
          color: Colors.white, // Màu chữ trắng giống SignUp
          fontSize: 18, // Kích thước chữ giống SignUp
        ),
      ),
    );
  }
}