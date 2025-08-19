import 'package:badges/badges.dart' as badges;
import 'package:do_an_mobile/screens/cartpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:do_an_mobile/provider/product_provider.dart';

class NoficationShoppingCart extends StatelessWidget {


  const NoficationShoppingCart({super.key});

  @override
  Widget build(BuildContext context) {
      ProductProvider productProvider = Provider.of<ProductProvider>(context);
    return badges.Badge(
      position: badges.BadgePosition.topEnd(top: 0, end: 2),
      badgeContent:Text(
        productProvider.getCheckOutModelListLength.toString(),
        style: TextStyle(color: Colors.white),
      ),
      child: IconButton(
        icon: const Icon(Icons.shopping_cart, color: Colors.black),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CartPage(), // Giả sử bạn có một trang giỏ hàng
            ),
          );
        },
      ),
    );
  }
}
