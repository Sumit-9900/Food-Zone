import 'package:flutter/material.dart';

class AddFoodButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget textWidget;
  const AddFoodButton({super.key, required this.onTap, required this.textWidget});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: textWidget,
        ),
      ),
    );
  }
}
