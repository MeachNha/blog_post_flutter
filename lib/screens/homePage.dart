import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:st_01/controller/userprofice_controller.dart';
import 'package:st_01/models/post_model.dart' as models;
import 'package:st_01/screens/post_screen.dart';
import 'package:st_01/unils/utils.dart';
import 'package:st_01/widgets/appbarwidget.dart';
import '../controller/post_controller.dart';
import '../widgets/storywidget.dart';
import 'package:timeago/timeago.dart' as timeago;

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final PostController postController = Get.put(PostController());
  final UserProfileController currentUser = Get.put(UserProfileController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !postController.isPaginating.value &&
        !postController.lastPage.value) {
      postController.loadMorePosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
        ),
        child: Column(
          children: [
            Appbarwidget(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await postController.getPost();
                },
                child: Obx(
                      () {
                    // Check loading and empty states
                    if (postController.isLoading.value && postController.allpost.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Handles both the Storywidget and the posts in a single, efficient list
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(0),
                      // The itemCount now accounts for the stories and the loading indicator
                      itemCount: postController.allpost.length + 1 + (postController.isPaginating.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        // The very first item (index 0) is the Storywidget
                        if (index == 0) {
                          return Storywidget();
                        }

                        // Show loading indicator at the end of the list
                        if (index == postController.allpost.length + 1) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        // Handle the main post list
                        final post = postController.allpost[index - 1];
                        final UserPost = post.user;

                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              // --- Your existing post item UI code ---
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: UserPost?.image != null
                                              ? NetworkImage(BASE_URL + UserPost!.image!)
                                              : const AssetImage('assets/images/avatar.jpg') as ImageProvider,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${UserPost?.name}",
                                                    style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  post.createdAt != null
                                                      ? Text(
                                                    timeago.format(DateTime.parse(
                                                      post.createdAt ?? '',
                                                    )),
                                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                                  )
                                                      : const Text(
                                                    "Just now",
                                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  const Icon(Icons.public, size: 16),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const Row(
                                      children: [
                                        Icon(Icons.more_horiz, size: 16),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    post.title ?? '',
                                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    post.body ?? '',
                                                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          color: Colors.blueAccent,
                                        ),
                                        child: post.image != null
                                            ? Image.network(
                                          BASE_URL_POST + post.image!,
                                          fit: BoxFit.cover,
                                          height: 500,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              height: 500,
                                              color: Colors.grey.shade300,
                                              child: const Icon(
                                                Icons.broken_image,
                                                color: Colors.grey,
                                                size: 50,
                                              ),
                                            );
                                          },
                                        )
                                            : Container(
                                          height: 500,
                                          color: Colors.grey.shade300,
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey,
                                            size: 50,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const SizedBox(width: 10),
                                  if (post.likesCount != 0)
                                    Text(
                                      '${post.likesCount} likes',
                                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                                    ),
                                  const SizedBox(width: 10),
                                  if (post.commentCount != 0)
                                    Text(
                                      '${post.commentCount} comments',
                                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                                    ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              postController.toggleLike(
                                                post: post,
                                                isLiked: post.like == 1,
                                              );
                                            },
                                            icon: Icon(
                                              post.like == 1 ? Icons.favorite : Icons.favorite_border,
                                              color: post.like == 1 ? Colors.red : Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            "Like",
                                            style: TextStyle(color: post.like == 1 ? Colors.green : Colors.grey, fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed('/comment', arguments: post.id);
                                      },
                                      child: const Row(
                                        children: [
                                          Icon(Icons.comment_outlined, color: Colors.grey, size: 16),
                                          SizedBox(width: 5),
                                          Text(
                                            "Comment",
                                            style: TextStyle(color: Colors.grey, fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    const InkWell(
                                      child: Row(
                                        children: [
                                          Icon(Icons.share_outlined, color: Colors.grey, size: 16),
                                          SizedBox(width: 5),
                                          Text(
                                            "Share",
                                            style: TextStyle(color: Colors.grey, fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                              // --- End of your existing post item UI code ---
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}