//
//
// import 'dart:typed_data';
// import 'package:file_picker/file_picker.dart';
//
// class ImageModel {
//   final String name;
//   final Uint8List bytes;
//   final String? path;
//
//   ImageModel({
//     required this.name,
//     required this.bytes,
//     this.path,
//   });
// }
//
// class ImagePickerHelper {
//   static Future<ImageModel?> pickImage() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//     );
//
//     if (result != null && result.files.single.bytes != null) {
//       return ImageModel(
//         name: result.files.single.name,
//         bytes: result.files.single.bytes!,
//         path: result.files.single.path,
//       );
//     }
//     return null;
//   }
// }
