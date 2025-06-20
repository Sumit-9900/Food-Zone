part of 'image_picker_cubit.dart';

@immutable
sealed class ImagePickerState {}

final class ImagePickerInitial extends ImagePickerState {}

final class ImagePickerLoading extends ImagePickerState {}

final class ImagePickerFailure extends ImagePickerState {
  final String message;
  ImagePickerFailure(this.message);
}

final class ImagePickerSuccess extends ImagePickerState {
  final File file;
  ImagePickerSuccess(this.file);
}
