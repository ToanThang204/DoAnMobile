import 'package:do_an_mobile/screens/homepage.dart';
import 'package:do_an_mobile/screens/signup.dart';
import 'package:do_an_mobile/widgets/changeScreens.dart';
import 'package:do_an_mobile/widgets/mytextformField.dart';
import 'package:do_an_mobile/widgets/passwordtextformField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/mybutton.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final GlobalKey<ScaffoldState> _scaffoldstate = GlobalKey<ScaffoldState>();
String p =
    r'^[a-zA-Z0-9._%+-]+@(gmail\.com|yahoo\.com|hotmail\.com|outlook\.com)$';
RegExp regExp = RegExp(p);
bool obserText = true;
String email = "";
String password = "";

class _LoginState extends State<Login> {

  //xay dung cac loai thong bao
  void vaildation() async {
    final FormState? _form = _formKey.currentState;
    if (_form!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Đăng nhập thành công!")),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => HomePage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'invalid-credential':
            errorMessage = "Email hoặc mật khẩu không đúng. Vui lòng kiểm tra lại.";
            break;
          case 'user-disabled':
            errorMessage = "Tài khoản này đã bị vô hiệu hóa.";
            break;
          case 'too-many-requests':
            errorMessage = "Quá nhiều yêu cầu. Vui lòng thử lại sau.";
            break;
          default:
            errorMessage = "Lỗi: ${e.message}";
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Lỗi không xác định: $e")),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vui lòng điền đầy đủ thông tin hợp lệ")),
        );
      }
    }
  }
  /// Xây dựng các TextFormField và nút đăng nhập
  Widget _buildAlllTextFormFieldsAndButton() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
            Container(
              height: 120,
              child: Image.asset("images/logo.png", fit: BoxFit.contain),
            ),
          Text(
            'Đăng Nhập',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700], // Đồng bộ màu với SignUp
            ),
          ),
          const SizedBox(height: 20),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Bo góc giống SignUp
            ),
            elevation: 5, // Hiệu ứng bóng giống SignUp
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  MyTextFormField(
                    name: 'Email',
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Vui lòng nhập email';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Email không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  PasswordTextFormField(
                    obserText: obserText,
                    name: "Password",
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Vui lòng nhập mật khẩu';
                      } else if (value.length < 8) {
                        return 'Mật khẩu phải lớn hơn 8 ký tự';
                      }
                      return null;
                    },
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        obserText = !obserText;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          MyButton(
            onPressed: vaildation,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.grey[600], // Màu nút giống SignUp
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Bo góc giống SignUp
              ),
              elevation: 5, // Hiệu ứng bóng giống SignUp
              minimumSize: const Size(double.infinity, 50), // Full width giống SignUp
            ),
            name: "Đăng Nhập",
          ),
          const SizedBox(height: 20),
          TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                  );
                },
                child: const Text(
                  "Bạn chưa có tài khoản? Đăng kí ngay",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldstate,
      backgroundColor: Colors.white, // Màu nền giống SignUp
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0), // Padding giống SignUp
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 60), // Khoảng cách đầu giống SignUp
                _buildAlllTextFormFieldsAndButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}