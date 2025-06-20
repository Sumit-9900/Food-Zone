import 'package:flutter/material.dart';
import 'package:food_client/core/constants/image_constants.dart';
import 'package:food_client/core/routes/route_constants.dart';
import 'package:food_client/core/theme/textstyle.dart';
import 'package:food_client/features/auth/view/widgets/auth_button.dart';
import 'package:food_client/features/auth/view/widgets/input_field.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                    color: const Color(0xFFff5c30),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(
                        MediaQuery.of(context).size.width,
                        120,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Image.asset(ImageConstants.logo),
              ),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InputField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        hintText: 'Name',
                        icon: Icons.person_outline,
                      ),
                      InputField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        hintText: 'Email',
                        icon: Icons.email_outlined,
                      ),
                      InputField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        hintText: 'Password',
                        icon: Icons.password_outlined,
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      AuthButton(
                        textButton: // value.isLoading
                        //     ? const CircularProgressIndicator()
                        //     :
                        Text(
                          'SignUp',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        onTap: () {
                          // context.read<UserProvider>().signUp(
                          //       context,
                          //       email: emailController.text.trim(),
                          //       password: passwordController.text.trim(),
                          //       name: nameController.text.trim(),
                          //     );
                          // emailController.clear();
                          // passwordController.clear();
                          // nameController.clear();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width / 8,
                bottom: MediaQuery.of(context).size.height / 8.5,
                child: GestureDetector(
                  onTap: () {
                    context.pushReplacementNamed(RouteConstants.logInRoute);
                  },
                  child: Text(
                    'Already have an account?\n Login',
                    style: Style.text1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
