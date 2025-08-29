import 'dart:ffi';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:st_01/models/current_post_model.dart';
import '../core/network/api_client.dart';
import '../models/post_model.dart';

class PostService {
  Future<Either<String, String>> CreatePost(
      {required String title,
      required String body,
      required File image,
      required String token}) async {
    var formData = FormData.fromMap({
      'title': title,
      'body': body,
      'image': await MultipartFile.fromFile(image.path),
    });
    try {
      final response = await ApiClient.dio.post(
        'posts',
        data: formData,
        options: Options(
          validateStatus: (status) => status! < 500,
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right("Post created successfully");
      } else {
        return Left("Failed to create post: ${response.data}");
      }
    } catch (e) {
      return Left("Error: $e");
    }
  }

  Future<Either<String, PostModel>> GetPost({
    required String token,
    required int page,
  }) async {
    try {
      final response = await ApiClient.dio.get(
        'posts?page=$page',
        options: Options(
          validateStatus: (status) => status! < 500,
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200) {
        return Right(PostModel.fromJson(response.data));
      } else {
        return Left("Failed to fetch posts: ${response.data}");
      }
    } catch (e) {
      return Left("Error: $e");
    }
  }

  //get curren post by id
  Future<Either<String, CurrentPostModel>> GetCurrentPost({
    required int id,
    required String token,
  }) async {
    try {
      final response = await ApiClient.dio.get(
        'posts/$id',
        options: Options(
          validateStatus: (status) => status! < 500,
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(CurrentPostModel.fromJson(response.data));
      } else {
        return Left("Failed to fetch post: ${response.data}");
      }
    } catch (e) {
      return Left("Error: $e");
    }
  }

  //create new comment
  Future<Either<String, String>> CreateNewComment(
      {required int postId, required String text, required String token}) async {
      var formData = FormData.fromMap({
      'post_id': postId,
      'text': text,
        });
     try {
        final respone=await ApiClient.dio.post(
          'comments',
          data: formData,
          options: Options(
            validateStatus: (status)=>status!<500,
            headers: {
              "Authorization": "Bearer $token",
            },
          ),
        );
        if(respone.statusCode == 200 || respone.statusCode ==201){
          return Right("Comment created successfully");
        }else{
          return Left("Failed to create comment");
        }
     }catch(e)
     {
        return Left("Error with catch: $e");
     }
  }
  //upade comment
  Future<Either<String, String>> updateComment({
    required int commentId,
    required int postId,
    required String text,
    required String token,
  }) async {
    try {
      final response = await ApiClient.dio.put(
        'comments/$commentId',
        data: {'text': text,
               'post_id': postId
        },
        options: Options(
          validateStatus: (status) => status! < 500,
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right("Comment updated successfully");
      } else {
        return Left("Failed to update comment");
      }
    } catch (e) {
      return Left("Error: $e");
    }
  }
  //delete comment
  Future<Either<String, String>> deleteComment({
    required int commentId,
    required String token,
  }) async {
    try {
      final response = await ApiClient.dio.delete(
        'comments/$commentId',
        options: Options(
          validateStatus: (status) => status! < 500,
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return Right("Comment deleted successfully");
      } else {
        return Left("Failed to delete comment");
      }
    } catch (e) {
      return Left("Error: $e");
    }
  }
  //like post
  Future<Either<String, String>> likePost({
    required int postId,
    required String token,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        'likes',
        data: {
          'post_id': postId
        },
        options: Options(
          validateStatus: (status) => status! < 500,
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right("Post liked successfully");
      } else {
        return Left("Failed to like post");
      }
    } catch (e) {
      return Left("Error: $e");
    }
  }
  // unlike post
  Future<Either<String, String>> unlikePost({
    required int postId,
    required String token,
  }) async {
    try {
      final response = await ApiClient.dio.delete(
        'likes/$postId',
        options: Options(
          validateStatus: (status) => status! < 500,
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return Right("Post unliked successfully");
      } else {
        return Left("Failed to unlike post");
      }
    } catch (e) {
      return Left("Error: $e");
    }
  }
}
