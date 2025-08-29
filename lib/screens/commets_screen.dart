import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:st_01/unils/utils.dart';
import '../controller/post_controller.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:st_01/models/userprofile.dart';
import '../controller/userprofice_controller.dart';

class CommentsScreen extends StatefulWidget {
  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final int postId = Get.arguments;
  final PostController postController = Get.put(PostController());
  final UserProfileController currentUser = Get.put(UserProfileController());
  final TextEditingController _txtcontroller = TextEditingController();
  final _keyform = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      postController.getPostById(id: postId);
    });
  }
  @override
  void dispose() {
    _txtcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              if (postController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final postByid = postController.postById;
              final comments = postByid.data?.comments ?? [];

              return Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        // Post details
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: postByid.data?.user?.image != null
                                          ? NetworkImage(BASE_URL + postByid.data!.user!.image!)
                                          : const AssetImage('assets/images/avatar.png') as ImageProvider,
                                      radius: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          postByid.data?.user?.name ?? '',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        Text(
                                          timeago.format(
                                            DateTime.tryParse(postByid.data?.createdAt ?? '') ?? DateTime.now(),
                                            locale: 'en_short',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(postByid.data?.title ?? '', style: const TextStyle(fontSize: 15)),
                                const SizedBox(height: 5),
                                Text(postByid.data?.body ?? '', style: const TextStyle(fontSize: 14)),
                                const SizedBox(height: 10),
                                if (postByid.data?.image != null)
                                  Image.network(
                                    BASE_URL_POST + postByid.data!.image!,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Container(height: 200, color: Colors.grey),
                                  )
                                else
                                  Container(height: 200, color: Colors.grey),
                                const Divider(height: 30),
                              ],
                            ),
                          ),
                        ),
                        // Comments list
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              final comment = comments[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: comment.user?.image != null
                                          ? NetworkImage(BASE_URL + comment.user!.image!)
                                          : const AssetImage('assets/images/avatar.png') as ImageProvider,
                                      radius: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          PopupMenuButton<String>(
                                            tooltip: '',
                                            onSelected: (value) async {
                                              if (value == 'edit') {
                                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                                  postController.openEditOverlay(comment.id!, comment.text!);
                                                });
                                              } else if (value == 'delete') {
                                                bool? shouldDelete = await showDialog<bool>(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: const Text("Delete Comment"),
                                                    content: const Text("Are you sure you want to delete this comment?"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () => Navigator.pop(context, false),
                                                        child: const Text("Cancel"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () => Navigator.pop(context, true),
                                                        child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                                if (shouldDelete == true) {
                                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                                    postController.destroyComment(
                                                        postId: postId, commentId: comment.id!);
                                                  });
                                                }
                                              }
                                            },
                                            itemBuilder: (context) => [
                                              const PopupMenuItem(value: 'edit', child: Text('Edit')),
                                              const PopupMenuItem(value: 'delete', child: Text('Delete')),
                                            ],
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(comment.user?.name ?? '',
                                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                                  const SizedBox(height: 2),
                                                  Text(comment.text ?? '', style: const TextStyle(fontSize: 14)),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            comment.createdAt != null
                                                ? timeago.format(DateTime.parse(comment.createdAt!), locale: 'en_short')
                                                : 'Just now',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            childCount: comments.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Comment input box
                  Obx(() => postController.showEditOverlay.value == false
                      ? Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: currentUser.user.name != null
                              ? NetworkImage(BASE_URL + currentUser.user.image!)
                              : const AssetImage('assets/images/avatar.png') as ImageProvider,
                          radius: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            key: _keyform,
                            controller: _txtcontroller,
                            decoration: InputDecoration(
                              hintText: "Write a comment...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: postController.isLoading.value
                              ? const CircularProgressIndicator()
                              : const Icon(Icons.send),
                          color: Colors.blue,
                          onPressed: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              postController.newComment(
                                  postId: postId, text: _txtcontroller.text.trim());
                              _txtcontroller.clear();
                            });
                          },
                        ),
                      ],
                    ),
                  )
                      : const SizedBox()),
                ],
              );
            }),
            // Edit overlay
            Obx(() => postController.showEditOverlay.value
                ? Container(
              color: Colors.black54,
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Edit Comment', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      TextField(
                        maxLines: 5,
                        onChanged: (val) => postController.currentCommentText.value = val,
                        controller: postController.editCommentController,
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => postController.showEditOverlay.value = false,
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                postController.EditComment(
                                    postId: postId,
                                    commentId: postController.currentCommentId.value,
                                    text: postController.currentCommentText.value);
                              });
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
                : const SizedBox()),
          ],
        ),
      ),
    );
  }
}
