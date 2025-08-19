import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_mobile/model/usermodel.dart';
import 'package:do_an_mobile/provider/category_provider.dart';
import 'package:do_an_mobile/provider/product_provider.dart';
import 'package:do_an_mobile/screens/cartpage.dart';
import 'package:do_an_mobile/screens/checkout.dart';
import 'package:do_an_mobile/screens/detailpage.dart';
import 'package:do_an_mobile/screens/listproduct.dart';
import 'package:do_an_mobile/screens/login.dart';
import 'package:do_an_mobile/screens/profilepage.dart';
import 'package:do_an_mobile/screens/search.dart';
import 'package:do_an_mobile/screens/welcomepage.dart';
import 'package:do_an_mobile/widgets/importProduct.dart';
import 'package:do_an_mobile/widgets/noficationShoppingcart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:do_an_mobile/model/product.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  //hinh anh carousel
  final List<String> carouselImages = [
    'images/aotetdra.jpg',
    'images/ao7dra.jpg',
    'images/ao.png',
  ];

  bool homeColor = true;
  bool gioHangColor = false;
  bool AboutColor = false;
  bool profileColor = false;

  @override
  void initState() {
    super.initState();
    // Gọi các phương thức bất đồng bộ trong initState
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    categoryProvider.getTshirtData();
    categoryProvider.getPantData();
    categoryProvider.getDressData();
    categoryProvider.getShoeData();
    categoryProvider.getWatchData();

    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.getFeatureproductData();
    productProvider.getNewproductData();
    productProvider.getHomeFeatureproductData();
    productProvider.getHomeNewproductData();
    productProvider.getUserData();
  }

  //xau dung incon danh muc
  Widget _buildCategoryProduct({required String image, required int color}) {
    return CircleAvatar(
      maxRadius: 30,
      backgroundColor: Color(color),
      child: Image.asset(
        image,
        height: 30,
        color: Colors.white,
      ),
    );
  }
//xay dung thong tin tai khoan o trong drawer
Widget _buidUserAcountDrawer() {
  final productProvider = Provider.of<ProductProvider>(context);
  List<UserModel> userModel = productProvider.getUserModel;

  return Column(
    children: userModel.isEmpty
  ? [
      DrawerHeader(
        child: Center(child: CircularProgressIndicator()),
      ),
    ]
  : userModel.map((e) {
      return UserAccountsDrawerHeader(
        currentAccountPicture: CircleAvatar(
                backgroundImage: e.profileImageUrl != null
                    ? NetworkImage(e.profileImageUrl!) // Sử dụng ảnh từ Cloudinary
                    : AssetImage("images/hinhuser.jpg") as ImageProvider, // Ảnh mặc định nếu không có URL
              ),
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        accountName: Text(
          e.username,
          style: TextStyle(color: Colors.white),
        ),
        accountEmail: Text(e.email), 
      );
    }).toList(),
  );
}

//xay dung drawer
Widget _buildMyDrawer() {
  final productProvider = Provider.of<ProductProvider>(context);
  final userModel = productProvider.getUserModel;

  return Drawer(
    child: Column(
      children: <Widget>[
        _buidUserAcountDrawer(), //xay dung thong tin tai khoan o trong drawer
        
        ListTile(
          selected: homeColor,
          onTap: () {
            setState(() {
              homeColor = true;
              gioHangColor = false;
              AboutColor = false;
              profileColor = false;
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => HomePage(),
              ),
            );
          },
          leading: Icon(Icons.home),
          title: Text("Home"),
        ),
         ListTile(
          selected: profileColor,
          onTap: () {
            setState(() {
              homeColor = false;
              gioHangColor = false;
              AboutColor = false;
              profileColor = true;
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => ProFilePage(),
              ),
            );
          },
          leading: Icon(Icons.info_rounded),
          title: Text("Thông Tin Cá Nhân"),
        ),
        ListTile(
          selected: gioHangColor,
          onTap: () {
            setState(() {
              gioHangColor = true;
              homeColor = false;
              AboutColor = false;
              profileColor = false;
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => CartPage(),
              ),
            );
          },
          leading: Icon(Icons.shopping_cart),
          title: Text("Giỏ Hàng"),
        ),
        ListTile(
          selected: AboutColor,
          onTap: () {
            setState(() {
              AboutColor = true;
              homeColor = false;
              gioHangColor = false;
              profileColor = false;
            });
          },
          leading: Icon(Icons.info),
          title: Text("About"),
        ),
        ListTile(
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            if (!mounted) return;
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Welcomepage()),
              (Route<dynamic> route) => false,
            );
          },
          leading: Icon(Icons.exit_to_app),
          title: Text("Đăng Xuất"),
        ),
      ],
    ),
  );
}

  //xay dung danh muc
  Widget _buildCategory(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    List<Product> tshirt = categoryProvider.getTshirtList;
    List<Product> pant = categoryProvider.getPantList;
    List<Product> dress = categoryProvider.getDressList;
    List<Product> shoe = categoryProvider.getShoeList;
    List<Product> watch = categoryProvider.getWatchList;

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Danh Mục', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ListProduct(
                      name: 'Áo',
                      snapShot: tshirt,
                    ),
                  ),
                );
              },
              child: _buildCategoryProduct(
                image: 'images/inconAo.png',
                color: 0xff74acf7,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ListProduct(
                      name: 'Quần',
                      snapShot: pant,
                    ),
                  ),
                );
              },
              child: _buildCategoryProduct(
                image: 'images/inconQuan.png',
                color: 0xff33dcfd,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ListProduct(
                      name: 'Váy',
                      snapShot: dress,
                    ),
                  ),
                );
              },
              child: _buildCategoryProduct(
                image: 'images/inconDress.png',
                color: 0xfff38cdd,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ListProduct(
                      name: 'Giày',
                      snapShot: shoe,
                    ),
                  ),
                );
              },
              child: _buildCategoryProduct(
                image: 'images/inconShoes.png',
                color: 0xff4ff2af,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ListProduct(
                      name: 'Đồng Hồ',
                      snapShot: watch,
                    ),
                  ),
                );
              },
              child: _buildCategoryProduct(
                image: 'images/inconWatch.png',
                color: 0xff74acf7,
              ),
            ),
          ],
        ),
      ],
    );
  }
  //xay dung danh sach san pham noi bat
  Widget _buildFeatured(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    List<Product> featureProduct = productProvider.getFeatureList;
    List<Product> homefeatureProduct = productProvider.getHomeFeatureList;

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Nổi Bật', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ListProduct(
                      name: 'Nổi Bật',
                      snapShot: featureProduct,
                    ),
                  ),
                );
              },
              child: Text(
                'See all',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: homefeatureProduct.map((e) {
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => Detailpage(
                          image: e.image,
                          name: e.name,
                          price: e.price,
                          description: e.description ?? "No description available", // Added description parameter
                        ),
                      ),
                    );
                  },
                  child: Importproduct(
                    image: e.image,
                    name: e.name,
                    price: e.price,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
  //xay dung danh sach san pham moi
  Widget _buildNew(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    List<Product> newProduct = productProvider.getNewList;
    List<Product> homeNewProduct = productProvider.getHomeNewList;

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('New', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ListProduct(
                      name: 'New',
                      snapShot: newProduct,
                    ),
                  ),
                );
              },
              child: Text(
                'See all',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: homeNewProduct.map((e) {
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => Detailpage(
                          image: e.image,
                          name: e.name,
                          price: e.price,
                          description: e.description ?? "No description available" , // Added description parameter
                        ),
                      ),
                    );
                  },
                  child: Importproduct(
                    image: e.image,
                    name: e.name,
                    price: e.price,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: _buildMyDrawer(),
      //xay dung appbar
      appBar: AppBar(
        title: Text('Dirty Coins'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () => _key.currentState!.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final productProvider = Provider.of<ProductProvider>(context, listen: false);
              final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
              await showSearch(
                context: context,
                delegate: ProductSearch(
                  allProducts: [
                    ...categoryProvider.getDressList,
                    ...categoryProvider.getPantList,
                    ...categoryProvider.getShoeList,
                    ...categoryProvider.getTshirtList,
                    ...categoryProvider.getWatchList,
                    ...productProvider.getHomeNewList,
                    ...productProvider.getHomeFeatureList,
                    ...productProvider.getNewList,
                    ...productProvider.getFeatureList,
                  ],
                ),
              );
            },
          ),
          NoficationShoppingCart(),
        ],
      ),
      //xa dung body
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: <Widget>[
            //xay dung carousel
            CarouselSlider(
              options: CarouselOptions(
                height: 180,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
              ),
              items: carouselImages.map((imagePath) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                );
              }).toList(),
            ),
            _buildCategory(context),
            SizedBox(height: 20),
            _buildFeatured(context),
            SizedBox(height: 20),
            _buildNew(context),
          ],
        ),
      ),
    );
  }
}