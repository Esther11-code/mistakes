class UserModel {
  String? id;
  String? email;
  String? name;
  String? role;
  String? username;
  String? bio;
  String? expertise;
  String? profilePhotoUrl;
  String? location;
  String? linkedinUrl;
  bool? isVerified;
  List<String>? interests;

  // Mentee-specific
  // String? areaOfInterest;
  String? learningGoals;

  // Mentor-specific
  int? yearsExperience;
  String? availability;

  UserModel({
    this.id,
    this.email,
    this.name,
    this.role,
    this.username,
    this.bio,
    this.expertise,
    this.profilePhotoUrl,
    this.location,
    this.linkedinUrl,
    this.isVerified,
    this.interests,
    // this.areaOfInterest,
    this.learningGoals,
    this.yearsExperience,
    this.availability,
  });

  bool get isMentor => role?.toLowerCase() == 'mentor';
  bool get isMentee => role?.toLowerCase() == 'mentee';
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user_id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      username: json['username'],
      bio: json['bio'],
      expertise: json['expertise'],
      profilePhotoUrl: json['profile_photo_url'],
      location: json['location'],
      linkedinUrl: json['linkedin_url'],
      isVerified: json['is_verified'] ?? false,
      interests: json['interests'] != null
          ? List<String>.from(json['interests'])
          : [],
      learningGoals: json['learning_goals'],
      yearsExperience: json['years_experience'],
      availability: json['availability'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'email': email,
      'name': name,
      'role': role,
      'username': username,
      'bio': bio,
      'expertise': expertise,
      'profile_photo_url': profilePhotoUrl,
      'location': location,
      'linkedin_url': linkedinUrl,
      'is_verified': isVerified,
      'interests': interests,
      'learning_goals': learningGoals,
      'years_experience': yearsExperience,
      'availability': availability,
    };
  }
}
