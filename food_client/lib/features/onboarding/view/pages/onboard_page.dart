import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/core/routes/route_constants.dart';
import 'package:food_client/core/theme/textstyle.dart';
import 'package:food_client/features/onboarding/models/onboard_model.dart';
import 'package:food_client/features/onboarding/viewmodel/cubit/onboarding_cubit.dart';
import 'package:food_client/features/onboarding/view/widgets/build_dot.dart';
import 'package:go_router/go_router.dart';

class OnBoardPage extends StatefulWidget {
  const OnBoardPage({super.key});

  @override
  State<OnBoardPage> createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  final PageController controller = PageController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingCubit = context.read<OnboardingCubit>();

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            int currentIndex = 0;

            if (state is OnboardingSuccess) {
              currentIndex = state.index;
            }

            return PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: controller,
              itemCount: contents.length,
              onPageChanged: onboardingCubit.onPageChanged,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 1.8,
                        child: Image.asset(contents[index].image),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        contents[index].title,
                        style: Style.text,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        contents[index].description,
                        style: Style.text2,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      BuildDot(currentPage: currentIndex),
                      const SizedBox(height: 25),
                      GestureDetector(
                        onTap: () {
                          if (currentIndex == contents.length - 1) {
                            context.goNamed(RouteConstants.logInRoute);
                          }
                          controller.nextPage(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.red,
                          ),
                          child: Center(
                            child: Text(
                              currentIndex == contents.length - 1
                                  ? 'Start'
                                  : 'Next',
                              style: Style.text3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
