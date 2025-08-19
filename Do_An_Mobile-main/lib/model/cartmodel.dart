import 'package:flutter/material.dart';

class Cartmodel {
  final String name;
  final String image;
  final double price;
  final int quantity;
  final String size;
  
  Cartmodel({
    required this.name,
    required this.image,
    required this.price, 
    required this.quantity,
    required this.size,
  });
}