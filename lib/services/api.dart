import 'dart:io';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

import '../models/userprofile.dart';

class Api {
  final _dio = Dio();
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  static const String registerUrl = "$baseUrl/register";
  static const String loginUrl = "$baseUrl/login";
  static const String userprofieUrl = "$baseUrl/userprofile";
  Future<Either<String, String>> register({
    required String name,
    required String email,
    required String password,
    required File image,
  }) async {
    try {
      var formData = FormData.fromMap({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'image': await MultipartFile.fromFile(image.path),
      });

      final response = await _dio.post(
        registerUrl,
        data: formData,
        options: Options(
          validateStatus: (status) => status! < 500, // accept all under 500
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right("User created successfully");
      } else {
        final error = response.data;

        if (error is Map && error.containsKey('errors')) {
          final errors = error['errors'];

          if (errors is Map) {
            final messages = errors.values
                .map((e) => e is List ? e.join(", ") : e.toString())
                .join("\n");
            return Left(messages);
          } else {
            return Left(errors.toString());
          }
        } else if (error is String) {
          return Left(error);
        } else {
          return Left('Unknown error format');
        }
      }
    } catch (e) {
      return Left("Error: $e");
    }
  }
  Future<Either<String, Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        loginUrl,
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data); // Map<String, dynamic>
      } else {
        final error = response.data;

        if (error is Map && error.containsKey('message')) {
          return Left(error['message'].toString());
        } else if (error is Map && error.containsKey('errors')) {
          final errors = error['errors'];
          if (errors is Map) {
            final messages = errors.values
                .map((e) => e is List ? e.join(", ") : e.toString())
                .join("\n");
            return Left(messages);
          } else {
            return Left(errors.toString());
          }
        } else {
          return Left('Unknown error');
        }
      }
    } catch (e) {
      return Left("Exception: $e");
    }
  }
  Future<Either<String, UserProfile>> getUser({required String token}) async {
    try {
      final response = await _dio.get(
        userprofieUrl,
        options: Options(
          validateStatus: (status) => status! < 500,
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return Right(UserProfile.fromJson(response.data));
      } else {
        final error = response.data is Map && response.data['error'] != null
            ? response.data['error']
            : "Unexpected error from server";
        return Left(error.toString());
      }
    } catch (e) {
      return Left("Network or parsing error: $e");
    }
  }
}
