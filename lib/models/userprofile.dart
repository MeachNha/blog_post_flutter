class UserProfile {
  int? id;
  String? name;
  String? email;
  String? image;
  Null emailVerifiedAt;
  String? confirmPassword;
  String? createdAt;
  String? updatedAt;

  UserProfile(
      {this.id,
        this.name,
        this.email,
        this.image,
        this.emailVerifiedAt,
        this.confirmPassword,
        this.createdAt,
        this.updatedAt});

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    image = json['image'];
    emailVerifiedAt = json['email_verified_at'];
    confirmPassword = json['confirm_password'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['image'] = this.image;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['confirm_password'] = this.confirmPassword;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}