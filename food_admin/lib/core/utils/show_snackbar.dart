import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context, {
  required String message,
  required Color color,
}) {
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
}
