import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_mobile/model/cartmodel.dart';
import 'package:do_an_mobile/model/product.dart';
import 'package:do_an_mobile/model/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class ProductProvider with ChangeNotifier {
  
  void deleteProductInCart(int index){
    checkOutModelList.removeAt(index);
    notifyListeners();
  }

   
  void clearProductInCart(){
    checkOutModelList.clear();
    notifyListeners();
  }
  
  
  List<UserModel> UsermodeList = [];
  UserModel? userModel;

  Future<void> getUserData() async {
    List<UserModel> newList = [];
    User currentUser = FirebaseAuth.instance.currentUser!;
    QuerySnapshot userSnapshot =
        await FirebaseFirestore.instance.collection("users").get();
    userSnapshot.docs.forEach((element) {
      if (currentUser.uid == element['usererId'] && element.exists) {
        final data = element.data() as Map<String, dynamic>?;
        userModel = UserModel(
          address: element['address'],
          username: element['username'],
          email: element['email'],
          phone: element['phone'],
          gioitinh: element['gioitinh'],
          profileImageUrl: data?.containsKey('profileImageUrl') == true
              ? element['profileImageUrl']
              : null,
        );
        newList.add(userModel!);
      }
    });
    UsermodeList = newList;
    notifyListeners();
  }

  List<UserModel> get getUserModel {
    return UsermodeList;
  }

  Future<void> uploadImageToCloudinaryAndSave(File imageFile) async {
    try {
      if (!imageFile.existsSync()) {
        print("Error: Image file does not exist at ${imageFile.path}");
        return;
      }

      final cloudinary = CloudinaryPublic('dqh8kyxgt', 'UploadHinh_DoAnMoBile');
      CloudinaryResponse uploadResult = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imageFile.path),
      );
      String imageUrl = uploadResult.secureUrl;

      User currentUser = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .update({
        "profileImageUrl": imageUrl,
      });

      await getUserData();
      notifyListeners();
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  List<Cartmodel> cartModelList = [];
  late Cartmodel cartModel;

  List<Cartmodel> checkOutModelList = [];
  late Cartmodel checkOutModel;

  void getCheckOutCartData({
    required String name,
    required String image,
    required int quantity,
    required double price,
    required String size,
  }) {
    checkOutModel = Cartmodel(
      name: name,
      image: image,
      price: price,
      quantity: quantity,
      size: size,
    );
    checkOutModelList.add(checkOutModel);
    notifyListeners();
  }

  List<Cartmodel> get getCheckoutModelList {
    return List.from(checkOutModelList);
  }

  int get getCheckOutModelListLength {
    return checkOutModelList.length;
  }

  void updateQuantity(int index, int newQuantity) {
    if (index >= 0 && index < checkOutModelList.length && newQuantity >= 1) {
      checkOutModelList[index] = Cartmodel(
        name: checkOutModelList[index].name,
        image: checkOutModelList[index].image,
        price: checkOutModelList[index].price,
        quantity: newQuantity,
        size: checkOutModelList[index].size,
      );
      notifyListeners();
    }
  }

  List<Product> featureproduct = [];
  Product? featureproductData;
  Future<void> getFeatureproductData() async {
    List<Product> newlist = [];
    QuerySnapshot featureSnapshot = await FirebaseFirestore.instance
        .collection("product")
        .doc("1HgSL0xNRTgFI2sM7Dtb")
        .collection("featureproduct")
        .get();
    featureSnapshot.docs.forEach((element) {
      featureproductData = Product(
        description: element['description'],
        image: element['image'],
        name: element['name'],
        price: element['price'].toDouble(),
      );
      newlist.add(featureproductData!);
    });
    featureproduct = newlist;
    notifyListeners();
  }

  List<Product> get getFeatureList {
    return featureproduct;
  }

  List<Product> newproduct = [];
  Product? newproductData;
  Future<void> getNewproductData() async {
    List<Product> newlist = [];
    QuerySnapshot newSnapshot = await FirebaseFirestore.instance
        .collection("product")
        .doc("1HgSL0xNRTgFI2sM7Dtb")
        .collection("newproduct")
        .get();
    newSnapshot.docs.forEach((element) {
      newproductData = Product(
        description: element['description'],
        image: element['image'],
        name: element['name'],
        price: element['price'].toDouble(),
      );
      newlist.add(newproductData!);
    });
    newproduct = newlist;
    notifyListeners();
  }

  List<Product> get getNewList {
    return newproduct;
  }

  List<Product> homefeatureproduct = [];
  Product? homefeatureproductData;
  Future<void> getHomeFeatureproductData() async {
    List<Product> newlist = [];
    QuerySnapshot homenewSnapshot =
        await FirebaseFirestore.instance.collection("homefeature").get();
    homenewSnapshot.docs.forEach((element) {
      homefeatureproductData = Product(
        description: element['description'],
        image: element['image'],
        name: element['name'],
        price: element['price'].toDouble(),
      );
      newlist.add(homefeatureproductData!);
    });
    homefeatureproduct = newlist;
    notifyListeners();
  }

  List<Product> get getHomeFeatureList {
    return homefeatureproduct;
  }

  List<Product> homenewproduct = [];
  Product? homenewproductData;
  Future<void> getHomeNewproductData() async {
    List<Product> newlist = [];
    QuerySnapshot newSnapshot =
        await FirebaseFirestore.instance.collection("homenew").get();
    newSnapshot.docs.forEach((element) {
      homenewproductData = Product(
        description: element['description'],
        image: element['image'],
        name: element['name'],
        price: element['price'].toDouble(),
      );
      newlist.add(homenewproductData!);
    });
    homenewproduct = newlist;
    notifyListeners();
  }

  List<Product> get getHomeNewList {
    return homenewproduct;
  }

  List<String> NotificationShoppingCartList = [];
  void addNotificationShoppingCart(String NoficationShoppingCart) {
    NotificationShoppingCartList.add(NoficationShoppingCart);
    notifyListeners();
  }

  int get getNotificationShoppingCartListLenght {
    return NotificationShoppingCartList.length;
  }
}