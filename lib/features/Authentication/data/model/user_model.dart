class UserModel {
  String? id;
  String? name;
  String? email;
  String? role; // "mentor" or "mentee"
  String? bio;
  String? expertise; // Only for mentors
  String? interests; // Only for mentees

  UserModel({
    this.id,
    this.name,
    this.email,
    this.role,
    this.bio,
    this.expertise,
    this.interests,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    bio = json['bio'];
    expertise = json['expertise'];
    interests = json['interests'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'bio': bio,
      'expertise': expertise,
      'interests': interests,
    };
  }
}
