import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/core/utils/pick_image.dart';
import 'package:food_client/features/auth/repository/auth_remote_repository.dart';
import 'package:food_client/features/profile/models/user_model.dart';
import 'package:food_client/features/profile/repository/profile_remote_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRemoteRepository _profileRemoteRepository;
  final AuthRemoteRepository _authRemoteRepository;
  ProfileCubit({
    required ProfileRemoteRepository profileRemoteRepository,
    required AuthRemoteRepository authRemoteRepository,
  }) : _profileRemoteRepository = profileRemoteRepository,
       _authRemoteRepository = authRemoteRepository,
       super(ProfileInitial());

  void imagePicked() async {
    final xFile = await pickImage();
    if (xFile == null) return;
    final file = File(xFile.path);

    emit(ProfileLoading());

    final uploadResult = await _profileRemoteRepository
        .uploadImageToFirebaseStorage(file);

    if (uploadResult.isLeft()) {
      emit(ProfileFailure(uploadResult.fold((l) => l.message, (_) => '')));
      return;
    }

    final imageUrl = uploadResult.getOrElse(() => '');

    final saveResult = await _profileRemoteRepository.saveImageUrlToFirestore(
      imageUrl,
    );

    saveResult.fold(
      (l) => emit(ProfileFailure(l.message)),
      (_) => fetchUserDetails(),
    );
  }

  void fetchUserDetails() async {
    final res = await _profileRemoteRepository.fetchUserDetails();

    res.fold((l) => emit(ProfileFailure(l.message)), (userMap) {
      if (userMap == null) {
        emit(ProfileFailure('No user found!'));
        return;
      }

      final user = UserModel.fromMap(userMap);

      emit(ProfileFetched(user: user));
    });
  }

  void logOutUser() async {
    emit(ProfileAuthLoading());

    final res = await _authRemoteRepository.logOut();

    res.fold(
      (l) => emit(ProfileFailure(l.message)),
      (_) => emit(ProfileLoggedOut()),
    );
  }

  void deleteAccount() async {
    emit(ProfileAuthLoading());

    final userResult = await _profileRemoteRepository.fetchUserDetails();

    if (userResult.isLeft()) {
      emit(ProfileFailure(userResult.fold((l) => l.message, (r) => '')));
    }

    final userMap = userResult.getOrElse(() => {});
    if (userMap == null) {
      emit(ProfileFailure('No user found!'));
      return;
    }

    final user = UserModel.fromMap(userMap);

    final res = await _authRemoteRepository.deleteUser(user.userImage);

    res.fold(
      (l) => emit(ProfileFailure(l.message)),
      (_) => emit(ProfileAccountDeleted()),
    );
  }

  void updateUserName(String name) async {
    emit(ProfileAuthLoading());

    final res = await _profileRemoteRepository.updateUserName(name);

    res.fold((l) => emit(ProfileFailure(l.message)), (_) => fetchUserDetails());
  }
}
