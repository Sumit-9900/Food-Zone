import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Widget textWidget;
  final VoidCallback onTap;
  const Button({super.key, required this.textWidget, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(child: textWidget),
        ),
      ),
    );
  }
}
