import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_admin/core/constants/text_constants.dart';
import 'package:food_admin/core/routes/app_route_constants.dart';
import 'package:food_admin/core/utils/show_alert_dialog.dart';
import 'package:food_admin/core/utils/show_snackbar.dart';
import 'package:food_admin/features/auth/viewmodel/bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage(TextConstants.boyImage),
            ),
          ),
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                showSnackBar(
                  context,
                  message: state.message,
                  color: Colors.red,
                );
              } else if (state is AuthLogoutSuccess) {
                context.goNamed(AppRouteConstants.loginRouteName);
              }
            },
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  showAlertDialog(
                    context,
                    state: state,
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLogout());
                    },
                  );
                },
                child: const ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
