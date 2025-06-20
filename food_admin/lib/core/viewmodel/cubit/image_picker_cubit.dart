import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'image_picker_state.dart';

class ImagePickerCubit extends Cubit<ImagePickerState> {
  ImagePickerCubit() : super(ImagePickerInitial());

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFromGallery() async {
    emit(ImagePickerLoading());

    try {
      final xFile = await _picker.pickImage(source: ImageSource.gallery);
      if (xFile != null) {
        emit(ImagePickerSuccess(File(xFile.path)));
      } else {
        emit(ImagePickerInitial());
      }
    } catch (e) {
      emit(ImagePickerFailure(e.toString()));
    }
  }

  void clearImage() {
    emit(ImagePickerInitial());
  }
}
