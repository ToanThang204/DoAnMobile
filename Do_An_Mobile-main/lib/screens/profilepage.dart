import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_mobile/model/usermodel.dart';
import 'package:do_an_mobile/provider/product_provider.dart';
import 'package:do_an_mobile/screens/homepage.dart';
import 'package:do_an_mobile/widgets/noficationShoppingcart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProFilePage extends StatefulWidget {
  const ProFilePage({super.key});

  @override
  State<ProFilePage> createState() => _ProFilePageState();
}

class _ProFilePageState extends State<ProFilePage> {
  File? _PickedImage;
  XFile? _image;
  bool _isImagePickerActive = false;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _gioitinhController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  final List<String> genderOptions = ['Nam', 'Nữ', 'Khác'];

  bool edit = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _gioitinhController = TextEditingController();
    _phoneController = TextEditingController();
      _addressController = TextEditingController();

    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.getUserData().then((_) {
      if (productProvider.getUserModel.isNotEmpty) {
        final user = productProvider.getUserModel[0];
        _usernameController.text = user.username;
        _emailController.text = user.email;
        _gioitinhController.text = user.gioitinh;
        _phoneController.text = user.phone;
        _addressController.text = user.address ?? ''; 
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _gioitinhController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> getImage() async {
    if (_isImagePickerActive) return;
    if (!mounted) return;

    setState(() {
      _isImagePickerActive = true;
    });

    try {
      _image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (_image != null) {
        _PickedImage = File(_image!.path);
        final productProvider = Provider.of<ProductProvider>(context, listen: false);
        await productProvider.uploadImageToCloudinaryAndSave(_PickedImage!);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tải ảnh thất bại: $e")),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isImagePickerActive = false;
      });
    }
  }

  Future<void> saveUserData() async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    User currentUser = FirebaseAuth.instance.currentUser!;

    try {
      await FirebaseFirestore.instance.collection("users").doc(currentUser.uid).update({
         "address": _addressController.text,
        "username": _usernameController.text,
        "email": _emailController.text,
        "gioitinh": _gioitinhController.text,
        "phone": _phoneController.text,
       
      });
      await productProvider.getUserData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lưu dữ liệu thất bại: $e")),
      );
    }
  }

  Widget _buildHienThiProfileField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
        SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Text(value, style: TextStyle(fontSize: 16)),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildEditThongTinTextField(String label, TextEditingController controller, {bool isEmail = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
      SizedBox(height: 4),
      isEmail
          ? Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Text(
                controller.text, // Chỉ hiển thị giá trị, không cho chỉnh sửa
                style: TextStyle(fontSize: 16, color: Colors.grey), // Màu xám
              ),
            )
          : TextFormField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
      SizedBox(height: 16),
    ],
  );
}


  Widget _buildDropdownGioiTinhField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
        SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: _gioitinhController.text.isNotEmpty ? _gioitinhController.text : null,
          items: genderOptions.map((String gender) {
            return DropdownMenuItem<String>(value: gender, child: Text(gender));
          }).toList(),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          ),
          onChanged: (String? newValue) {
            setState(() {
              _gioitinhController.text = newValue ?? '';
            });
          },
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final user = productProvider.getUserModel.isNotEmpty ? productProvider.getUserModel[0] : null;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(edit ? Icons.close : Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (edit) {
              setState(() => edit = false);
            } else {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
            }
          },
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        actions: [
          edit
              ? IconButton(
                  icon: Icon(Icons.check, color: Colors.green),
                  onPressed: () async {
                    await saveUserData();
                    setState(() => edit = false);
                  },
                )
              : NoficationShoppingCart(),
        ],
      ),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: user.profileImageUrl != null
                            ? NetworkImage(user.profileImageUrl!)
                            : AssetImage("images/hinhuser.jpg") as ImageProvider,
                      ),
                      if (edit)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: getImage,
                            child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.edit, color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: Column(
                      children: edit
                          ? [
                              _buildEditThongTinTextField("Họ và tên", _usernameController),
                              _buildEditThongTinTextField("Email", _emailController, isEmail: true),
                              _buildDropdownGioiTinhField("Giới tính"),
                              _buildEditThongTinTextField("Số điện thoại", _phoneController),
                              _buildEditThongTinTextField("Địa Chỉ", _addressController),
                            ]
                          : [
                              _buildHienThiProfileField("Họ và tên", user.username),
                              _buildHienThiProfileField("Email", user.email),
                              _buildHienThiProfileField("Giới tính", user.gioitinh),
                              _buildHienThiProfileField("Số điện thoại", user.phone),
                              _buildHienThiProfileField("Địa Chỉ", user.address),
                            ],
                    ),
                  ),
                  SizedBox(height: 20),
                  if (!edit)
                    ElevatedButton.icon(
                      onPressed: () => setState(() => edit = true),
                      icon: Icon(Icons.edit),
                      label: Text("Chỉnh sửa thông tin"),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
