class User {
  String? id;
  String? name;
  String? phoneNumber;
  String? email;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? avatar;

  User({
    this.id,
    this.name,
    this.phoneNumber,
    this.email,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.avatar,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phone'];
    email = json['email'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    avatar = json['avatar'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['avatar'] = avatar;
    return data;
  }

  @override
  String toString() {
    return "Id: ${id}, Name: ${name}, Phone number: ${phoneNumber}, Email: ${email}, DeletedAt: ${deletedAt}, CreatedAt: ${createdAt}, UpdatedAt: ${updatedAt}, Avatar: ${avatar}";
  }
}
