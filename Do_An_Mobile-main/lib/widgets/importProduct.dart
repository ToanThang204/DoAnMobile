import 'package:flutter/material.dart';

class Importproduct extends StatelessWidget {
  final String image;
  final double price;
  final String name;

  const Importproduct({
    super.key,
    required this.image,
    required this.price,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3, // Tạo hiệu ứng nổi nhẹ
      child: Container(
        height: 250,
        width: 180,
        padding: EdgeInsets.all(10), // Giúp bố cục gọn gàng hơn
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Căn giữa các phần tử
          children: <Widget>[
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.contain, // Hiển thị ảnh đẹp hơn
                ),
              ),
            ),
            SizedBox(height: 10), // Tạo khoảng cách giữa ảnh và chữ
            Text(
              "\$${price.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Text(
              name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
