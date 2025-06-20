import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final Widget textButton;
  final VoidCallback onTap;
  const AuthButton({super.key, required this.textButton, required this.onTap});

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
            color: const Color(0xFFff5c30),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(child: textButton),
        ),
      ),
    );
  }
}
