import 'package:flutter/material.dart';
import 'package:food_client/core/theme/textstyle.dart';

class Button extends StatelessWidget {
  final String? label;
  final Widget? child;
  final VoidCallback? onPressed;

  const Button({super.key, this.label, this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: onPressed != null ? Colors.black : Colors.grey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(child: child ?? Text(label!, style: Style.text3)),
        ),
      ),
    );
  }
}
