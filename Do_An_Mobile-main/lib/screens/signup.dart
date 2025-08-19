import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_mobile/screens/login.dart';
import 'package:do_an_mobile/widgets/mybutton.dart';
import 'package:do_an_mobile/widgets/mytextformField.dart';
import 'package:do_an_mobile/widgets/passwordtextformField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool obserText = true;
  String email = "";
  String password = "";
  String username = "";
  String phoneNumber = "";
  bool isNam = true;
  String address = "";

  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@(gmail\.com|yahoo\.com|hotmail\.com|outlook\.com)$';
  final RegExp emailRegExp = RegExp(emailPattern);
  
  //luu dang ky vao firebase va hien thi thong bao
  Future<void> validation() async {
    final FormState? _form = _formKey.currentState;
    if (_form!.validate()) {
      try {
        UserCredential result =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        // await FirebaseAuth.instance.createUserWithEmailAndPassword(
        //   email: email,
        //   password: password,
        // );

        FirebaseFirestore.instance
            .collection("users")
            .doc(result.user!.uid)
            .set({
              "username": username,
              "usererId": result.user!.uid,
              "email": email,
              "gioitinh": isNam ? "Nam" : "Nữ",
              "phone": phoneNumber,
              "address": address,
            });
        // Đăng ký thành công, hiển thị thông báo và chuyển hướng đến trang đăng nhập
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đăng ký thành công!")),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => Login()),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = "Email đã được sử dụng.";
            break;
          case 'invalid-email':
            errorMessage = "Email không hợp lệ.";
            break;
          case 'weak-password':
            errorMessage = "Mật khẩu quá yếu (ít nhất 8 ký tự).";
            break;
          default:
            errorMessage = "Lỗi: ${e.message}";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng điền đầy đủ thông tin hợp lệ")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 60),
              Text(
                'Đăng Ký',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        MyTextFormField(
                          name: "Email",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vui lòng nhập email';
                            } else if (!emailRegExp.hasMatch(value)) {
                              return 'Email không hợp lệ';
                            }
                            return null;
                          },
                          onChanged: (value) => email = value,
                        ),
                        const SizedBox(height: 20),
                        MyTextFormField(
                          name: "Username",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Username không được để trống';
                            } else if (value.length < 3) {
                              return 'Username phải lớn hơn 3 ký tự';
                            } else if (value.length > 20) {
                              return 'Username không được quá 20 ký tự';
                            }
                            else if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                              return 'Username chỉ được chứa chữ cái, số và dấu gạch dưới';
                            }
                            return null;
                          },
                          onChanged: (value) => username = value,
                        ),
                        const SizedBox(height: 20),
                        PasswordTextFormField(
                          obserText: obserText,
                          name: "Password",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vui lòng nhập mật khẩu';
                            } else if (value.length < 8) {
                              return 'Mật khẩu phải lớn hơn 8 ký tự';
                            }
                            return null;
                          },
                          onChanged: (value) => password = value,
                          onTap: () {
                            setState(() => obserText = !obserText);
                          },
                        ),

                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Radio(
                                value: true,
                                groupValue: isNam,
                                onChanged: (value) {
                                  setState(() {
                                    isNam = value!;
                                  });
                                },
                              ),
                              const Text("Nam"),
                              Radio(
                                value: false,
                                groupValue: isNam,
                                onChanged: (value) {
                                  setState(() {
                                    isNam = value!;
                                  });
                                },
                              ),
                              const Text("Nữ"),
                            ],
                          ),

                        ),
                        const SizedBox(height: 20),
                        MyTextFormField(
                          name: "Số Điện Thoại",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Số điện thoại không được để trống';
                            } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                              return 'Số điện thoại phải có đúng 10 chữ số';
                            }
                            return null;
                          },
                          onChanged: (value) => phoneNumber = value,
                        ),
                        MyTextFormField(
                          name: "Địa chỉ",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Địa chỉ không được để trống';
                            } else if (value.length < 5) {
                              return 'Địa chỉ phải lớn hơn 5 ký tự';
                            } else if (value.length > 50) {
                              return 'Địa chỉ không được quá 50 ký tự';
                            }
                            return null;
                          },
                          onChanged: (value) => address = value,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              MyButton(
                onPressed: validation,
                name: "Đăng Ký",
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.grey[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                child: const Text(
                  "Bạn đã có tài khoản? Đăng nhập ngay",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}