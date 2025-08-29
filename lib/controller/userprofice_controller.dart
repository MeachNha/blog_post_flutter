import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/userprofile.dart';
import '../services/api.dart';

class UserProfileController extends GetxController {
  final api = Get.put(Api());
  UserProfile user = UserProfile();

  @override
  void onInit() {
    super.onInit();
    userProfile(); // fetch user profile on controller initialization
  }

  void userProfile() async {
    final token = GetStorage().read('token');

    if (token == null) {
      Get.snackbar("Error", "No token found", snackPosition: SnackPosition.TOP);
      return;
    }

    final res = await api.getUser(token: token);

    res.fold(
          (l) {
        Get.snackbar('Error', l, snackPosition: SnackPosition.TOP);
      },
          (r) {
        user = r;
        print("User Profile: ${r.name}");
      },
    );
  }
}
