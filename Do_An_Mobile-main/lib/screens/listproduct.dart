import 'package:do_an_mobile/model/product.dart';
import 'package:do_an_mobile/screens/detailpage.dart';
import 'package:do_an_mobile/screens/homepage.dart';
import 'package:do_an_mobile/widgets/importProduct.dart';
import 'package:flutter/material.dart';

class ListProduct extends StatelessWidget {
  final String name;
  final List<Product> snapShot;
  const ListProduct({super.key, required this.name, required this.snapShot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Tiêu đề ở trên cùng
                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Kiểm tra nếu snapShot rỗng
                snapShot.isEmpty
                    ? Center(child: Text("Không có sản phẩm nào"))
                    : GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8, // Điều chỉnh tỷ lệ cho cân đối
                        shrinkWrap: true, // Cho phép GridView tự điều chỉnh kích thước
                        physics: NeverScrollableScrollPhysics(), // Tắt cuộn của GridView
                        children: snapShot.map((e) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => Detailpage(
                                  image: e.image,
                                  name: e.name,
                                  price: e.price,
                                  description: e.description ?? "No description available",
                                ),
                              ),
                            );
                          },
                          child: Importproduct(
                            price: e.price,
                            image: e.image,
                            name: e.name,
                          ),
                        )).toList(),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}