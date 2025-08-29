class CurrentPostModel {
  String? status;
  String? message;
  PostData? data;

  CurrentPostModel({this.status, this.message, this.data});

  factory CurrentPostModel.fromJson(Map<String, dynamic> json) {
    return CurrentPostModel(
      status: json['status']?.toString(),
      message: json['message']?.toString(),
      data: json['data'] != null ? PostData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class PostData {
  int? id;
  String? title;
  String? body;
  String? image;
  int? userId;
  String? createdAt;
  String? updatedAt;
  List<dynamic>? likes;
  List<Comment>? comments;
  User? user;

  PostData({
    this.id,
    this.title,
    this.body,
    this.image,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.likes,
    this.comments,
    this.user,
  });

  factory PostData.fromJson(Map<String, dynamic> json) {
    return PostData(
      id: json['id'],
      title: json['title']?.toString(),
      body: json['body']?.toString(),
      image: json['image']?.toString(),
      userId: json['user_id'],
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      likes: json['likes'] ?? [],
      comments: json['comments'] != null
          ? (json['comments'] as List)
          .map((c) => Comment.fromJson(c))
          .toList()
          : [],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'image': image,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'likes': likes,
      'comments': comments?.map((c) => c.toJson()).toList(),
      'user': user?.toJson(),
    };
  }
}

class Comment {
  int? id;
  String? text;
  int? userId;
  int? postId;
  String? createdAt;
  String? updatedAt;
  User? user;

  Comment({
    this.id,
    this.text,
    this.userId,
    this.postId,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      text: json['text']?.toString(),
      userId: json['user_id'],
      postId: json['post_id'],
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'user_id': userId,
      'post_id': postId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user?.toJson(),
    };
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? image;
  String? emailVerifiedAt;
  String? confirmPassword;
  String? createdAt;
  String? updatedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.image,
    this.emailVerifiedAt,
    this.confirmPassword,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      image: json['image']?.toString(),
      emailVerifiedAt: json['email_verified_at']?.toString(),
      confirmPassword: json['confirm_password']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'image': image,
      'email_verified_at': emailVerifiedAt,
      'confirm_password': confirmPassword,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
