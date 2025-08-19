import 'package:do_an_mobile/provider/category_provider.dart';
import 'package:do_an_mobile/provider/product_provider.dart';
import 'package:do_an_mobile/screens/cartpage.dart';
import 'package:do_an_mobile/screens/checkout.dart';
import 'package:do_an_mobile/screens/detailpage.dart';
import 'package:do_an_mobile/screens/homepage.dart';
import 'package:do_an_mobile/screens/listproduct.dart';
import 'package:do_an_mobile/screens/login.dart';
import 'package:do_an_mobile/screens/profilepage.dart';
import 'package:do_an_mobile/screens/welcomepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:do_an_mobile/screens/signup.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<CategoryProvider>(
          create: (ctx) => CategoryProvider(),
        ), 
        ListenableProvider<ProductProvider>(
          create: (ctx) => ProductProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              return HomePage();
              //return ProFilePage();
            } else {
              return Welcomepage();
            }
          },
        ),
      ),
    );
  }
}