import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_admin/core/routes/app_route_constants.dart';
import 'package:food_admin/core/theme/text_style.dart';
import 'package:food_admin/core/utils/show_snackbar.dart';
import 'package:food_admin/core/widgets/loader.dart';
import 'package:food_admin/features/auth/view/widgets/button.dart';
import 'package:food_admin/features/auth/view/widgets/field.dart';
import 'package:food_admin/features/auth/viewmodel/bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController usercontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();

  @override
  void dispose() {
    usercontroller.dispose();
    passcontroller.dispose();
    super.dispose();
  }

  Widget _headingText() {
    return Positioned(
      top: 35,
      left: MediaQuery.of(context).size.width / 4.5,
      child: Text(
        'Let\'s start with\n Admin',
        style: Style.text,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _headerElliptical() {
    return Positioned(
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(
            top: Radius.elliptical(MediaQuery.of(context).size.width, 120),
          ),
        ),
      ),
    );
  }

  void loginButtonOnTap({required String username, required String password}) {
    if (_formkey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthLogin(username: username, password: password),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showSnackBar(context, message: state.message, color: Colors.red);
          } else if (state is AuthSuccess) {
            showSnackBar(
              context,
              message: 'User Login Successfully!',
              color: Colors.green,
            );
            context.goNamed(AppRouteConstants.foodsRouteName);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    _headingText(),
                    _headerElliptical(),
                    Positioned(
                      top: MediaQuery.of(context).size.height / 4,
                      left: MediaQuery.of(context).size.width / 8,
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width / 1.3,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Field(
                                controller: usercontroller,
                                text: 'Username',
                                icon: Ionicons.person,
                              ),
                              Field(
                                controller: passcontroller,
                                text: 'Password',
                                icon: Icons.password_outlined,
                                isObscureText: true,
                              ),
                              const SizedBox(height: 20),
                              Button(
                                textWidget:
                                    state is AuthLoading
                                        ? const Loader()
                                        : Text(
                                          'Login',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                          ),
                                        ),
                                onTap: () {
                                  loginButtonOnTap(
                                    username: usercontroller.text.trim(),
                                    password: passcontroller.text.trim(),
                                  );
                                  usercontroller.clear();
                                  passcontroller.clear();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
