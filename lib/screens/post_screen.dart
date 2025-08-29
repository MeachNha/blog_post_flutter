import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:st_01/controller/imagepicker.dart';
import 'package:st_01/controller/post_controller.dart';
import 'package:st_01/controller/userprofice_controller.dart';
import 'package:st_01/unils/utils.dart';

class PostScreen extends StatefulWidget {
  PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _bodyController = TextEditingController();

  final ImagepickerController imagepicker = Get.put(ImagepickerController());

  final UserProfileController _userProfileController =
      Get.put(UserProfileController());
  final PostController _postController = Get.put(PostController());
  final _formKey = GlobalKey<FormState>();
  void _showImageSourceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false, // ✅ Prevent dismissing by tapping outside
      enableDrag: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false, // Max size (almost full screen)// Set to false when used inside showModalBottomSheet
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor, // Use theme color
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView(
                controller: scrollController,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const Text(
                    'Add Photo/Video',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  // Option to pick from gallery
                  ListTile(
                    leading: const Icon(Icons.photo_library, color: Colors.blueAccent),
                    title: const Text('Choose from Gallery'),
                    onTap: () async {
                      Navigator.pop(context); // Close the bottom sheet
                      // Assuming imagepicker.pickImageFromGallery() exists
                      await imagepicker.Image();
                    },
                  ),
                  // Option to take a photo
                  ListTile(
                    leading: const Icon(Icons.camera_alt, color: Colors.blueAccent),
                    title: const Text('Take Photo'),
                    onTap: () async {
                      Navigator.pop(context); // Close the bottom sheet
                      // Assuming imagepicker.pickImageFromCamera() exists
                      await imagepicker.Image();
                    },
                  ),
                  // You can add more options here, e.g., for video
                ],
              ),
            );
          },
        );
      },
    );
  }
  @override
  void initState() {
    super.initState();
    // Automatically show the bottom sheet after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showImageSourceBottomSheet(context);
    });
  }
  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    imagepicker.clearImage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Create Post"),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                final file = imagepicker.fileImage;
                if (file != null && file.path.isNotEmpty) {
                  _postController.createPost(
                    title: _titleController.text.trim(),
                    body: _bodyController.text.trim(),
                    image: file,
                  );
                  Get.offAllNamed('/main');
                } else {
                  Get.snackbar("Error", "Please select an image",
                      snackPosition: SnackPosition.BOTTOM);
                }
              } else {
                Get.snackbar("Error", "Please fill all fields correctly",
                    snackPosition: SnackPosition.BOTTOM);
              }
            },
            child: Text("Post",
                style: TextStyle(
                    color: Colors.blueAccent, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GetBuilder(builder: (UserProfileController User) {
              return Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: _userProfileController.user.image != null
                          ? NetworkImage(
                              BASE_URL + _userProfileController.user.image!)
                          : AssetImage('assets/images/avatar.png')
                              as ImageProvider,
                      backgroundColor: Colors.transparent,
                    ),
                    SizedBox(width: 10),
                    Text(_userProfileController.user.name ?? "User",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          print("Title is empty");
                          return "Please enter title";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Title",
                        border: InputBorder.none,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _bodyController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          print("Body is empty");
                          return "Please enter body";
                        }
                        return null;
                      },
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "What's on your mind?",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: GetBuilder(builder: (ImagepickerController imagepicker) {
                return imagepicker.fileImage != null
                    ? Image.file(imagepicker.fileImage!,
                        height: 200, width: double.infinity, fit: BoxFit.cover)
                    : Container();
              }),
            ),
            //buttom sheet
          ],
        ),
      ),
    );
  }
}
