import 'dart:io';
import 'dart:ui';

import 'package:dio/io.dart';
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:st_01/services/api.dart';

class AuthController extends GetxController {
  final api = Get.put(Api());
  var isLoading = false.obs;
  final storage = GetStorage();
  void logout() {
    storage.erase(); // clear all stored data
    Get.offAllNamed('/login'); // go back to login
  }

  void register(
      {required String name,
      required String email,
      required String password,
      required File image}) async {
    final res = api.register(
        name: name, email: email, password: password, image: image);
    res.fold(
      (l) {
        Get.snackbar('Error from login', l, snackPosition: SnackPosition.TOP);
      },
      (r) {
        Get.snackbar('Success', 'User created successfully',
            snackPosition: SnackPosition.TOP);
      },
    );
  }
   Future<bool> login({
    required String email,
    required String password,
  }) async {
    final res = await api.login(email: email, password: password);
    bool result = false;
    res.fold(
      (l) {
        Get.snackbar('Error', l, snackPosition: SnackPosition.TOP);
        result = false; // login failed
      },
      (r) {
        final token = r['token'];
        storage.write('token', token);
        Get.offAllNamed('/main');
        isLoading.value = true;
        result = true;
      },
    );
    return result;
  }
}
