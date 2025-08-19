import 'package:do_an_mobile/screens/detailpage.dart';
import 'package:flutter/material.dart';
import 'package:do_an_mobile/model/product.dart';
import 'package:diacritic/diacritic.dart';  // Thêm thư viện diacritic
import 'package:provider/provider.dart';

class ProductSearch extends SearchDelegate<Product?> {
  final List<Product> allProducts;

  ProductSearch({required this.allProducts});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Đóng trang tìm kiếm
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = allProducts
        .where((product) =>
            _normalizeText(product.name).contains(_normalizeText(query)))
        .toList();

    return _buildResultList(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = allProducts
        .where((product) =>
            _normalizeText(product.name).contains(_normalizeText(query)))
        .toList();

    return _buildResultList(suggestions);
  }

  // Hàm chuẩn hóa tên sản phẩm và truy vấn (bao gồm loại bỏ dấu và chuyển thành chữ thường)
  String _normalizeText(String text) {
    return removeDiacritics(text.toLowerCase());
  }

  Widget _buildResultList(List<Product> products) {
    if (products.isEmpty) {
      return Center(child: Text('Không tìm thấy sản phẩm nào'));
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ListTile(
          leading: Image.network(product.image, width: 50, height: 50),
          title: Text(product.name),
          subtitle: Text("${product.price.toStringAsFixed(2)} \$"),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Detailpage(
                  image: product.image,
                  name: product.name,
                  price: product.price,
                  description: product.description ?? "No description available",
                ),
              ),
            );
          },
        );
      },
    );
  }
}
 