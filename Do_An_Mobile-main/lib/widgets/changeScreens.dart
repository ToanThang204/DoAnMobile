import 'package:flutter/material.dart';

class ChangeScreens extends StatelessWidget {
  final String whichaccount;
  final String name;
  final VoidCallback onTap;
  const ChangeScreens({
    super.key, 
    required this.name, 
    required this.onTap, 
    required this.whichaccount
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(whichaccount),
        SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            name,
            style: TextStyle(
              color: Colors.cyan,
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
        )
      ],
    );
  }
}