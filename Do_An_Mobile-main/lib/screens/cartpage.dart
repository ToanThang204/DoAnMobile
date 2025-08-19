import 'package:do_an_mobile/screens/checkout.dart';
import 'package:do_an_mobile/screens/homepage.dart';
import 'package:do_an_mobile/widgets/importProductCart.dart';
import 'package:flutter/material.dart';
import 'package:do_an_mobile/provider/product_provider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}



class _CartPageState extends State<CartPage> {
  late ProductProvider productProvider;
  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      bottomNavigationBar: Container(
        height: 80,
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.only(bottom: 20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Checkout()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,
          ),
          child: const Text(
            "Đi Đến Thanh Toán",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Giỏ Hàng", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>  HomePage()),
              );
            },
            icon: const Icon(Icons.home, color: Colors.black),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: productProvider.getCheckOutModelListLength,
        itemBuilder: (ctx, index) => ImportProductCart(
          isCount: true,
          name: productProvider.getCheckoutModelList[index].name,
          image: productProvider.getCheckoutModelList[index].image,
          quantity: productProvider.getCheckoutModelList[index].quantity,
          price: productProvider.getCheckoutModelList[index].price,
          size: productProvider.getCheckoutModelList[index].size,
          index: index,
        ),
      ),
    );
  }
}