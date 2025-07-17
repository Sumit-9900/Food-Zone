import 'package:flutter/material.dart';
import 'package:food_client/core/theme/textstyle.dart';
import 'package:go_router/go_router.dart';

void showAlertDialog(
  BuildContext context, {
  required String title,
  required String des,
  required Widget child,
  required void Function()? onPressed,
}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog.adaptive(
        backgroundColor: Colors.white,
        title: Text(title),
        content: Text(des, style: Style.text2.copyWith(fontSize: 14)),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              context.pop();
            },
            child: Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.black,
            ),
            onPressed: onPressed,
            child: child,
          ),
        ],
      );
    },
  );
}
