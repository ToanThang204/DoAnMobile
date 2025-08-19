import 'package:flutter/material.dart';

class UserModel {
  String username;
  String email;
  String gioitinh;
  String phone;
  String? profileImageUrl; // Thêm trường để lưu URL ảnh từ Cloudinary
  String address = "Chưa cập nhật"; // Giá trị mặc định cho địa chỉ
  UserModel({
    required this.username,
    required this.email,
    required this.phone,
    required this.gioitinh,
    this.profileImageUrl, // Có thể null nếu người dùng chưa upload ảnh
    required this.address,
  });
}