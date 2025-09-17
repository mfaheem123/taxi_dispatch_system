
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

import '../../Model/image_model.dart';

class VehicleController extends GetxController{


  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo functionality vehicle type

  /// bool variable
  RxBool defaultVehicleValue = false.obs;
  RxBool minimumMilesValue = false.obs;

  ImageModel? profileImg;

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.bytes != null) {
      profileImg = ImageModel(
          name: result.files.single.name,
          bytes: result.files.single.bytes!,
          path: result.files.single.path
      );
    }
    update();

  }


  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo functionality vehicle type
}