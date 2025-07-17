import 'package:image_picker/image_picker.dart';

Future<XFile?> pickImage() async {
  final picker = ImagePicker();
  final xFile = await picker.pickImage(source: ImageSource.camera);

  if (xFile != null) {
    return xFile;
  }

  return null;
}
