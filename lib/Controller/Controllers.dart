import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class OutputPathController extends GetxController {
  final String outputPath;

  OutputPathController(this.outputPath);
}

class ProfileController extends GetxController {
  Rx<XFile?> image = Rx<XFile?>(null);
  RxString profileImagePath = RxString('assets/pfp.png');
  RxString googleUserName = ''.obs;

  void setImage(XFile? file) {
    image.value = file;
    profileImagePath.value = file?.path ?? 'assets/pfp.png';
  }

  void setUserName(String val) {
    googleUserName.value = val;
  }
}

class DirectoryNameController extends GetxController {
  RxString directoryName = RxString('');

  void setDirectoryName(String name) {
    directoryName.value = name;
  }
}

class ViewInteriorImageController extends GetxController {
  var interiorImagePath = ''.obs;
  var capture = ''.obs;

  void setInteriorImagePath(String path) {
    interiorImagePath.value = path;
  }

  void setcapture(String path) {
    capture.value = path;
  }

  // Function to save the interior image path
  void saveInteriorImagePath(String path) {
    setInteriorImagePath(path);
  }
}
