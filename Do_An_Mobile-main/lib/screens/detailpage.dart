import 'package:do_an_mobile/screens/cartpage.dart';
import 'package:do_an_mobile/screens/homepage.dart';
import 'package:do_an_mobile/widgets/noficationShoppingcart.dart';
import 'package:flutter/material.dart';
import 'package:do_an_mobile/provider/product_provider.dart';
import 'package:provider/provider.dart';

class Detailpage extends StatefulWidget {
  final String image;
  final String name;
  final double price;
  final String description;

  const Detailpage({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.description,
    
  });

  @override
  State<Detailpage> createState() => _DetailpageState();
}

class _DetailpageState extends State<Detailpage> {
  int count = 1;
  late ProductProvider productProvider;

  final TextStyle myStyle = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  Widget _buildImage() {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              fit: BoxFit.contain,
              image: NetworkImage(widget.image),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfProduct() {
    String formattedDescription = widget.description.replaceAll('\\n', '\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(widget.name, style: myStyle),
        const SizedBox(height: 8),
        Text(
          "\$ ${widget.price.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 20, color: Colors.green),
        ),
        const SizedBox(height: 16),
        Text("Chi tiết", style: myStyle),
        const SizedBox(height: 8),
        ...formattedDescription.split('\n').map((line) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(line, style: const TextStyle(fontSize: 16)),
            )),
      ],
    );
  }

  List<bool> isSelected = [false, false, false, false]; // Khởi tạo đúng trạng thái ban đầu

Widget _buildSize({required String name, required bool isSelected, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200), // Hiệu ứng chuyển động mượt mà
      height: 50,
      width: 50,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blueAccent.shade700 : Colors.white,
        border: Border.all(
          color: isSelected ? Colors.blueAccent.shade700 : Colors.grey.shade300,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.blueAccent.shade700,
          ),
        ),
      ),
    ),
  );
}

Widget _buildSizes() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text('Kích cỡ', style: myStyle),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(4, (index) {
          final sizes = ["S", "M", "L", "XL"];
          return _buildSize(
            name: sizes[index],
            isSelected: isSelected[index],
            onTap: () {
              setState(() {
                for (int idexbtn = 0; idexbtn < isSelected.length; idexbtn++) {
                  isSelected[idexbtn] = idexbtn == index; // Chỉ chọn một nút tại một thời điểm
                }
              });
            },
          );
        }),
      ),
    ],
  );
}


  Widget _buildSlPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Số lượng", style: myStyle),
        const SizedBox(height: 10),
        Container(
          height: 40,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade100,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                child: const Icon(Icons.remove),
                onTap: () {
                  setState(() {
                    if (count > 1) count--;
                  });
                },
              ),
              Text(count.toString(), style: const TextStyle(fontSize: 18)),
              GestureDetector(
                child: const Icon(Icons.add),
                onTap: () {
                  setState(() {
                    count++;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

 Widget _buildButton() {
  return Center(
    child: SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () {
          // Kiểm tra xem người dùng đã chọn kích cỡ chưa
          int selectedSizeIndex = isSelected.indexWhere((element) => element == true);
          if (selectedSizeIndex == -1) {
            // Nếu chưa chọn kích cỡ, hiển thị thông báo
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Vui lòng chọn kích cỡ!")),
            );
            return;
          }

          // Lấy kích cỡ đã chọn
          final sizes = ["S", "M", "L", "XL"];
          String selectedSize = sizes[selectedSizeIndex];

          // Thêm sản phẩm vào giỏ hàng với kích cỡ
          productProvider.addNotificationShoppingCart("Thêm vào giỏ hàng thành công");
          productProvider.addNotificationShoppingCart("Sản phẩm ${widget.name} đã được thêm vào giỏ hàng");
          productProvider.getCheckOutCartData(
            name: widget.name,
            image: widget.image,
            quantity: count,
            price: widget.price,
            size: selectedSize, // Truyền kích cỡ đã chọn
          );

          // Chuyển đến màn hình giỏ hàng
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => const CartPage()),
          );
        },
        icon: const Icon(Icons.shopping_cart_checkout_outlined),
        label: const Text(
          "Thêm vào giỏ hàng",
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Chi tiết sản phẩm",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: const <Widget>[
          NoficationShoppingCart(),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: <Widget>[
          _buildImage(),
          _buildInfProduct(),
          const SizedBox(height: 20),
          _buildSizes(),
          const SizedBox(height: 20),
          _buildSlPart(),
          const SizedBox(height: 20),
          _buildButton(),
        ],
      ),
    );
  }
}
