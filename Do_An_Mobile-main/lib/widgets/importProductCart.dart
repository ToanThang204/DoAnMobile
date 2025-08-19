import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:do_an_mobile/provider/product_provider.dart';

class ImportProductCart extends StatefulWidget {
  final String name;
  final String image;
  final double price;
  final bool isCount;
  final int quantity;
  final int index;
  final String size;

  const ImportProductCart({
    super.key,
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
    required this.index,
    this.isCount = true,
    required this.size,
  });

  @override
  State<ImportProductCart> createState() => _ImportProductCartState();
}

class _ImportProductCartState extends State<ImportProductCart> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    int currentQuantity = productProvider.getCheckoutModelList[widget.index].quantity;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              // Ảnh sản phẩm
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.image,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              // Thông tin sản phẩm
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tên sản phẩm
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            productProvider.deleteProductInCart(widget.index);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Size: ${widget.size}", // Hiển thị size thay vì "Quần Áo"
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "\$${widget.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    widget.isCount
                        ? Container(
                            height: 32,
                            width: 110,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    if (currentQuantity > 1) {
                                      productProvider.updateQuantity(
                                        widget.index,
                                        currentQuantity - 1,
                                      );
                                    }
                                  },
                                  child: const Icon(Icons.remove),
                                ),
                                Text(
                                  currentQuantity.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    productProvider.updateQuantity(
                                      widget.index,
                                      currentQuantity + 1,
                                    );
                                  },
                                  child: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          )
                        : Text(
                            "Số lượng: $currentQuantity",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
