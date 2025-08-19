import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_mobile/provider/product_provider.dart';
import 'package:do_an_mobile/screens/homepage.dart';
import 'package:do_an_mobile/widgets/importProductCart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}



class _CheckoutState extends State<Checkout> {
  late ProductProvider productProvider;

  //xay dung thong tin thanh toan
  Widget _buildCheckoutDetail(
      {required String startName, required String endName}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(startName, style: const TextStyle(fontSize: 18)),
        Text(endName, style: const TextStyle(fontSize: 18)),
      ],
    );
  }

  double totalPayment = 0.0;

 Widget _buildButtonThanhToan() {
  User? user = FirebaseAuth.instance.currentUser;
  return Column(
    children: productProvider.UsermodeList.map((e) {
      return ElevatedButton(
        onPressed: () {
          if (productProvider.checkOutModelList.isNotEmpty) {
            // Tính tổng tiền
            double totalPayment = 0;
            for (var product in productProvider.checkOutModelList) {
              totalPayment += product.price * product.quantity;
            }

            FirebaseFirestore.instance.collection("Order").add({
              "Product": productProvider.checkOutModelList.map((c) => {
                'Productname': c.name,
                'ProductPrice': c.price,
                'ProductQuantity': c.quantity,
                'ProductSize': c.size,
              }).toList(),
              'TotalPrice': totalPayment.toStringAsFixed(2),
              'UserName': e.username ?? 'Unknown',
              'UserEmail': e.email ?? 'Unknown',
              'UserPhone': e.phone ?? 'Unknown',
              'UserAddress': e.address ?? 'Unknown',
              'UserId': user!.uid,
              'OrderDate': Timestamp.now(), // Thêm thông tin ngày đặt hàng
            }).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Đặt hàng thành công!")),
              );
              productProvider.clearProductInCart(); // Xóa giỏ hàng sau khi thanh toán
            }).catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Lỗi khi tạo đơn hàng: $error")),
              );
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Giỏ hàng trống! Vui lòng chọn sản phẩm.")),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue,
        ),
        child: const Text(
          "Đặt Hàng",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }).toList(),
  );
}



  @override
  Widget build(BuildContext context) {
    
    productProvider = Provider.of<ProductProvider>(context);
    
    double discount =3;
    double totalDiscount;
    double totalShipping = 10;
    double totalPrice = 0.0;
    

    if(productProvider.checkOutModelList.isEmpty) {
       totalPayment = 0.0;
       discount = 0.0;
      totalShipping = 0.0;
    }
    
    productProvider.getCheckoutModelList.forEach((element) {
       totalPrice += element.price * element.quantity; // tinh tong gia tri san pham
    });
    totalDiscount = totalPrice * discount / 100;//tinh tong giam gia
    totalPayment = totalPrice + totalShipping - totalDiscount;//tinh tong thanh toan
    int index;
    return Scaffold(
      //xay dung phan appbar
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Thanh Toán", style: TextStyle(color: Colors.black)),
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
      bottomNavigationBar: Container(
        height: 80,
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.only(bottom: 20),
        child: _buildButtonThanhToan()
      ),

      //phan body
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: productProvider.getCheckOutModelListLength,
                itemBuilder: (ctx, myindex) {

                  index = myindex; //lay index cua san pham
                  
                 
                  //xay dung danh sach san pham trong gio hang
                  return ImportProductCart(
                    isCount: false,
                    name: productProvider.getCheckoutModelList[myindex].name,
                    image: productProvider.getCheckoutModelList[myindex].image,
                    quantity: productProvider.getCheckoutModelList[myindex].quantity,
                    price: productProvider.getCheckoutModelList[myindex].price,
                    size: productProvider.getCheckoutModelList[index].size,
                    index: myindex,
                  );
                },
              ),
            ),

            //thong tin thanh toan
            Container(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildCheckoutDetail(
                    startName: "Tổng Cộng",
                    endName: "\$  ${totalPrice.toStringAsFixed(2)}",
                  ),
                  _buildCheckoutDetail(
                    startName: "Giảm Giá", 
                    endName: " ${discount.toStringAsFixed(0)} \%"),
                  _buildCheckoutDetail(
                    startName: "Phí Vận Chuyển",
                    endName: "\$ ${totalShipping.toStringAsFixed(2)}",
                  ),
                  _buildCheckoutDetail(
                    startName: "Tổng Thanh Toán",
                    endName: "\$ ${totalPayment.toStringAsFixed(2)}",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}