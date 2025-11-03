

import 'dart:typed_data';

class ImageModel {
  String name;
  final Uint8List bytes;
  final String? path;

  ImageModel({
    required this.name,
    required this.bytes,
    this.path,
  });

  factory ImageModel.fromPlatformFile(dynamic file) {
    return ImageModel(
      name: file.name,
      bytes: file.bytes,
      path: file.path,
    );
  }
}
