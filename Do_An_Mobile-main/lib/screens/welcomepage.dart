import 'package:do_an_mobile/screens/login.dart';
import 'package:do_an_mobile/screens/signup.dart';
import 'package:flutter/material.dart';

class Welcomepage extends StatelessWidget {
  const Welcomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget> [
              Container(
                height: 600,
                width:double.infinity,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:<Widget> [
                    Container(
                      height: 350,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("images/logo.png"),
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:<Widget> [
                          Text(
                            "Chào mừng bạn đến với Shop quần áo của chúng tôi",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            "Hãy đăng ký tài khoản để bắt đầu mua sắm",
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (ctx)=>SignUp(),),
                            );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent
                        ),
                        child: Text(
                          "Đăng ký",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:<Widget> [
                        Text("Bạn đã có tài khoản? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (ctx)=>Login(),),
                            );
                          },
                          child: Text(
                            "Đăng Nhập",
                            style: TextStyle(
                              color: Colors.lightBlueAccent,
                              fontWeight: FontWeight.bold,fontSize: 20
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
