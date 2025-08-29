import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController {
  var isLoading = false.obs;
  final storage = GetStorage();

  final dio.Dio _dio = dio.Dio(
    dio.BaseOptions(
      baseUrl: 'http://192.168.78.39:8001/api/',
    ),
  );
  Future<bool> CreateUser({
    required String name,
    required String email,
    required String password,
    required File image,
  }) async {
    try {
      isLoading.value = true;
      var formData = dio.FormData.fromMap({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'image': await dio.MultipartFile.fromFile(image.path),
      });

      final response = await _dio.post('register', data: formData);
      Get.snackbar('Success', 'User created successfully',
          snackPosition: SnackPosition.TOP);
      Get.toNamed('/login');
      return true;
    } on dio.DioException catch (e) {
      Get.snackbar('Error', 'Failed to create user',
          snackPosition: SnackPosition.TOP);
      print("Error: ${e.response?.data}");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> Login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      var formData = dio.FormData.fromMap({
        'email': email,
        'password': password,
      });

      final response = await _dio.post('login', data: formData);

      // Save token
      storage.write('token', response.data['token']);

      Get.snackbar('Success', 'Login successful',
          snackPosition: SnackPosition.TOP);
      print('Response: ${response.data}');
      Future.delayed(Duration.zero, () {
        Get.offAllNamed('/main');
      }); // Navigate to main screen after login
      return true;
    } on dio.DioException catch (e) {
      Get.snackbar('Error', 'Failed to login',
          snackPosition: SnackPosition.TOP);
      print("Error: ${e.response?.data}");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
