import 'package:flutter/material.dart';
import 'package:food_admin/core/theme/text_style.dart';
import 'package:food_admin/core/widgets/loader.dart';
import 'package:food_admin/features/auth/viewmodel/bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';

void showAlertDialog(
  BuildContext context, {
  required AuthState state,
  required void Function()? onPressed,
}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog.adaptive(
        title: Text('LogOut'),
        content: Text(
          'Are you sure, you want to logout?',
          style: Style.text2.copyWith(fontSize: 14),
        ),
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
            child: state is AuthLoading ? const Loader() : Text('Yes'),
          ),
        ],
      );
    },
  );
}
