import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/core/constants/image_constants.dart';
import 'package:food_client/core/routes/route_constants.dart';
import 'package:food_client/core/utils/capitalize_name.dart';
import 'package:food_client/core/utils/show_alert_dialog.dart';
import 'package:food_client/core/utils/show_snackbar.dart';
import 'package:food_client/core/widgets/loader.dart';
import 'package:food_client/features/profile/view/widgets/profile_card.dart';
import 'package:food_client/features/profile/viewmodel/cubit/profile_cubit.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: height,
          width: width,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                child: Container(
                  width: width,
                  height: height / 4.5,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(
                        MediaQuery.of(context).size.width,
                        110,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: width / 2.8,
                top: height / 7,
                child: GestureDetector(
                  onTap: () {
                    context.read<ProfileCubit>().imagePicked();
                  },
                  child: BlocConsumer<ProfileCubit, ProfileState>(
                    listener: (context, state) {
                      if (state is ProfileFailure) {
                        showSnackBar(
                          context,
                          message: state.message,
                          color: Colors.red,
                        );
                      }
                    },
                    builder: (context, state) {
                      final imageUrl =
                          (state is ProfileFetched)
                              ? state.user.userImage
                              : ImageConstants.profileDefaultLogo;

                      return CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.grey,
                        child: ClipOval(
                          child:
                              state is ProfileLoading
                                  ? const Loader()
                                  : CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                    width: 140,
                                    height: 140,
                                    placeholder: (_, __) => const Loader(),
                                    errorWidget:
                                        (_, __, ___) => CachedNetworkImage(
                                          imageUrl:
                                              ImageConstants.profileDefaultLogo,
                                          fit: BoxFit.cover,
                                          width: 140,
                                          height: 140,
                                        ),
                                  ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 12.0,
                  right: 12.0,
                  top: MediaQuery.of(context).size.width / 1.4,
                ),
                child: Column(
                  children: [
                    BlocSelector<ProfileCubit, ProfileState, String>(
                      selector: (state) {
                        if (state is ProfileFetched) {
                          return state.user.username;
                        }
                        return '---';
                      },
                      builder: (context, name) {
                        return ProfileCard(
                          icon: const Icon(Icons.person),
                          name: 'Name',
                          des: capitalizeName(name),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    BlocSelector<ProfileCubit, ProfileState, String>(
                      selector: (state) {
                        if (state is ProfileFetched) {
                          return state.user.email;
                        }
                        return '---';
                      },
                      builder: (context, email) {
                        return ProfileCard(
                          icon: const Icon(Icons.email),
                          name: 'Email',
                          des: email,
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    ProfileCard(
                      icon: const Icon(Icons.edit_document),
                      name: 'Terms and Condition',
                      onTap: () {
                        context.pushNamed(RouteConstants.termsAndConditions);
                      },
                    ),
                    const SizedBox(height: 10),
                    BlocConsumer<ProfileCubit, ProfileState>(
                      listener: (context, state) {
                        if (state is ProfileFailure) {
                          showSnackBar(
                            context,
                            message: state.message,
                            color: Colors.red,
                          );
                        } else if (state is ProfileLoggedOut) {
                          context.goNamed(RouteConstants.logInRoute);
                        }
                      },
                      builder: (context, state) {
                        return ProfileCard(
                          icon: const Icon(Icons.logout),
                          name: 'LogOut',
                          onTap: () {
                            showAlertDialog(
                              context,
                              title: 'LogOut',
                              des: 'Are you sure, you want to logout?',
                              child:
                                  state is ProfileAuthLoading
                                      ? const Loader()
                                      : Text('Yes'),
                              onPressed: () {
                                context.read<ProfileCubit>().logOutUser();
                              },
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    BlocConsumer<ProfileCubit, ProfileState>(
                      listener: (context, state) {
                        if (state is ProfileFailure) {
                          showSnackBar(
                            context,
                            message: state.message,
                            color: Colors.red,
                          );
                        } else if (state is ProfileAccountDeleted) {
                          context.goNamed(RouteConstants.onBoardingRoute);
                        }
                      },
                      builder: (context, state) {
                        return ProfileCard(
                          icon: const Icon(Icons.delete),
                          name: 'Delete Account',
                          onTap: () {
                            showAlertDialog(
                              context,
                              title: 'Delete',
                              des:
                                  'Are you sure, you want to delete your account?',
                              child:
                                  state is ProfileAuthLoading
                                      ? const Loader()
                                      : Text('Yes'),
                              onPressed: () {
                                context.read<ProfileCubit>().deleteAccount();
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
