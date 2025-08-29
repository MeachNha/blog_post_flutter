import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:st_01/models/current_post_model.dart';
import 'package:st_01/models/post_model.dart' as models;
import '../services/post_service.dart';
class PostController extends GetxController {
  final post = Get.put(PostService());
  var allpost = <models.Data>[].obs;
  var isLoading = true.obs;
  var isPaginating = false.obs;
  var lastPage = false.obs;
  int currentPage = 1;
  final TextEditingController editCommentController = TextEditingController();
  CurrentPostModel postById = CurrentPostModel();
  var showEditOverlay = false.obs;
  var currentCommentId = 0.obs;
  var currentCommentText = ''.obs;
  @override
  void onInit() {
    getPost();
    super.onInit();
  }

  @override
  void onClose() {
    editCommentController.dispose();
    super.onClose();
  }

  //show overlay
  void openEditOverlay(int commentId, String oldText) {
    currentCommentId.value = commentId;
    currentCommentText.value = oldText;
    editCommentController.text = oldText;
    showEditOverlay.value = true;
  }
  void saveEdit(int postId) {
    EditComment(
      postId: postId,
      commentId: currentCommentId.value,
      text: currentCommentText.value,
    );
  }
  void createPost({
    required String title,
    required String body,
    required File image,
  }) async {
    final res = await post.CreatePost(
        title: title,
        body: body,
        image: image,
        token: '${GetStorage().read('token')}');
    res.fold((l) {
      Get.snackbar('Error', l, snackPosition: SnackPosition.TOP);
    }, (r) {
      Get.snackbar('Success', 'Post created successfully',
          snackPosition: SnackPosition.TOP);
    });
  }

  Future<void> getPost() async {
    final res = await post.GetPost(token: '${GetStorage().read('token')}',page: 1);
    res.fold((l) {
      Get.snackbar('Error', l, snackPosition: SnackPosition.TOP);
      print("error: $l");
      // post fetching failed
    }, (r) {
      // handle the fetched post data
      isLoading.value = false;
      allpost.assignAll(r.postData?.data??[]);
      currentPage = r.postData?.currentPage ?? 1;
      lastPage.value = r.postData?.lastPage == currentPage;
      print("Fetched Posts: ${r.message}");
    });
  }
  //load more posts
  Future<void> loadMorePosts() async{
     if (isPaginating.value || lastPage.value) return;
     isPaginating.value = true;
     final nextPage = currentPage + 1;
     final res = await post.GetPost(
         token: '${GetStorage().read('token')}', page: nextPage);
      res.fold((l){
      Get.snackbar('Error', l, snackPosition: SnackPosition.TOP);
      isLoading.value = false;
      isPaginating.value = false;
      lastPage.value = false;
      }, (r){
      isPaginating.value = false;
      if(r.postData?.data!=null){
        allpost.addAll(r.postData!.data!);
        currentPage = r.postData?.currentPage ?? currentPage;
        lastPage.value = r.postData?.lastPage == currentPage;
      } else {
        Get.snackbar('Info', 'No more posts to load',
            snackPosition: SnackPosition.TOP);
      }
      });
  }
  //get post by id
  Future<void> getPostById({required int id}) async {
    isLoading.value = true;
    final res = await post.GetCurrentPost(
        id: id, token: '${GetStorage().read('token')}');
    res.fold((l) {
      isLoading.value = false;
      Get.snackbar('Error', l, snackPosition: SnackPosition.TOP);
      print("error: $l");
      // post fetching failed
    }, (r) {
      isLoading.value = false;
      postById = r;
    });
  }

  Future<void> newComment({required int postId, required String text}) async {
    isLoading.value = true;
    final res = await post.CreateNewComment(
        postId: postId, text: text, token: '${GetStorage().read('token')}');
    res.fold((l) {
      Get.snackbar('Error', l, snackPosition: SnackPosition.TOP);
      isLoading.value = false;
      // comment creation failed
    }, (r) async {
      Get.snackbar('Success', 'Comment created successfully',
          snackPosition: SnackPosition.TOP);
      await getPostById(id: postId);
      isLoading.value = false;
      // refresh the post comments
    });
  }
  Future<void> EditComment(
      {required int commentId,
      required int postId,
      required String text}) async {
    isLoading.value = true;
    final res = await post.updateComment(
        commentId: commentId,
        text: text,
        token: '${GetStorage().read('token')}',
        postId: postId);
    res.fold((l) {
      Get.snackbar('Error', l, snackPosition: SnackPosition.TOP);
      isLoading.value = false;
      showEditOverlay.value = false;
      // comment update failed
    }, (r) async {
      Get.snackbar('Success', 'Comment updated successfully',
          snackPosition: SnackPosition.TOP);
      await getPostById(id: postId);
      isLoading.value = false;
      showEditOverlay.value = false;
      // refresh the post comments
    });
  }
  // delete comment
  Future<void> destroyComment(
      {required int commentId, required int postId}) async {
      isLoading.value = true;
      final res = await post.deleteComment(
          commentId: commentId, token: '${GetStorage().read('token')}');
    res.fold((l) {
      Get.snackbar('Error', l, snackPosition: SnackPosition.TOP);
      isLoading.value = false;
      // comment deletion failed
    }, (r) async {
      Get.snackbar('Success', 'Comment deleted successfully',
          snackPosition: SnackPosition.TOP);
      await getPostById(id: postId);
      isLoading.value = false;
      // refresh the post comments
    });
  }
  //toggle
  Future<void> toggleLike({
    required models.Data post,
    required bool isLiked,
  }) async {
    final token = '${GetStorage().read('token')}';

    // Cache original values for rollback
    final originalLike = post.like;
    final originalLikesCount = post.likesCount;

    // Optimistic UI update
    // The new like status is the opposite of the current status
    post.like = isLiked ? 0 : 1;
    // likesCount is incremented if isLiked is false (liking), decremented if true (unliking)
    post.likesCount = (post.likesCount ?? 0) + (isLiked ? -1 : 1);

    allpost.refresh();

    final res = isLiked
        ? await this.post.unlikePost(postId: post.id!, token: token)
        : await this.post.likePost(postId: post.id!, token: token);

    res.fold(
          (l) {
        Get.snackbar('Error', l, snackPosition: SnackPosition.TOP);

        // Rollback to original values
        post.like = originalLike;
        post.likesCount = originalLikesCount;
        allpost.refresh();
      },
          (r) {
        // Success: No rollback needed
      },
    );
  }
}
