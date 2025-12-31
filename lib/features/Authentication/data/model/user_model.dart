// lib/features/Dashboard/data/models/user_model.dart
class UserModel {
  String? id;
  String? name;
  String ?email;
  String ?role; // "mentor" or "mentee"
  String? avatar;
  String ?bio;
  
  // Common fields
  List<String>? skills;
  List<String> ?interests;
  String? expertise;
  
  // Mentor-specific fields (nullable for mentees)
  int? yearsOfExperience;
  double? rating;
  int? totalMentees;
  bool? isAvailable;
  int? maxMentees;
  
  // Mentee-specific fields (nullable for mentors)
  String? mentorId;
  List<String>? goals;
  int? completedGoals;
  int? sessionsAttended;

  UserModel({
   this.id,
  this.name,
  this.email,
  this.role,
    this.avatar,
  this.bio,
  this.skills,
  this.interests,
  this.expertise,
    // Mentor fields
    this.yearsOfExperience,
    this.rating,
    this.totalMentees,
    this.isAvailable,
    this.maxMentees,
    // Mentee fields
    this.mentorId,
    this.goals,
    this.completedGoals,
    this.sessionsAttended,
  });

  // Helper getters
  bool get isMentor => role!.toLowerCase() == 'mentor';
  bool get isMentee => role!.toLowerCase() == 'mentee';

  // From JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      avatar: json['avatar'],
      bio: json['bio'],
      skills: List<String>.from(json['skills'] ?? []),
      interests: List<String>.from(json['interests'] ?? []),
      expertise: json['expertise'],
      // Mentor fields
      yearsOfExperience: json['yearsOfExperience'],
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      totalMentees: json['totalMentees'],
      isAvailable: json['isAvailable'],
      maxMentees: json['maxMentees'],
      // Mentee fields
      mentorId: json['mentorId'],
      goals: json['goals'] != null ? List<String>.from(json['goals']) : null,
      completedGoals: json['completedGoals'],
      sessionsAttended: json['sessionsAttended'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'avatar': avatar,
      'bio': bio,
      'skills': skills,
      'interests': interests,
      'expertise': expertise,
      // Mentor fields
      if (yearsOfExperience != null) 'yearsOfExperience': yearsOfExperience,
      if (rating != null) 'rating': rating,
      if (totalMentees != null) 'totalMentees': totalMentees,
      if (isAvailable != null) 'isAvailable': isAvailable,
      if (maxMentees != null) 'maxMentees': maxMentees,
      // Mentee fields
      if (mentorId != null) 'mentorId': mentorId,
      if (goals != null) 'goals': goals,
      if (completedGoals != null) 'completedGoals': completedGoals,
      if (sessionsAttended != null) 'sessionsAttended': sessionsAttended,
    };
  }

  // Copy with
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? avatar,
    String? bio,
    List<String>? skills,
    List<String>? interests,
    String? expertise,
    int? yearsOfExperience,
    double? rating,
    int? totalMentees,
    bool? isAvailable,
    int? maxMentees,
    String? mentorId,
    List<String>? goals,
    int? completedGoals,
    int? sessionsAttended,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
      interests: interests ?? this.interests,
      expertise: expertise ?? this.expertise,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      rating: rating ?? this.rating,
      totalMentees: totalMentees ?? this.totalMentees,
      isAvailable: isAvailable ?? this.isAvailable,
      maxMentees: maxMentees ?? this.maxMentees,
      mentorId: mentorId ?? this.mentorId,
      goals: goals ?? this.goals,
      completedGoals: completedGoals ?? this.completedGoals,
      sessionsAttended: sessionsAttended ?? this.sessionsAttended,
    );
  }

  // Sample data - Mentors
  static List<UserModel> sampleMentors = [
    UserModel(
      id: '1',
      name: 'Sarah Johnson',
      email: 'sarah.j@email.com',
      role: 'mentor',
      bio: 'Senior Flutter developer with expertise in mobile app development',
      skills: ['Flutter', 'Dart', 'Firebase', 'State Management'],
      interests: ['Technology', 'Teaching', 'Innovation'],
      expertise: 'Mobile Development',
      yearsOfExperience: 5,
      rating: 4.9,
      totalMentees: 15,
      isAvailable: true,
      maxMentees: 20,
    ),
    UserModel(
      id: '2',
      name: 'Michael Chen',
      email: 'michael.c@email.com',
      role: 'mentor',
      bio: 'Backend specialist focusing on scalable systems',
      skills: ['Node.js', 'Python', 'MongoDB', 'AWS'],
      interests: ['Cloud Computing', 'DevOps', 'Architecture'],
      expertise: 'Backend Development',
      yearsOfExperience: 7,
      rating: 4.8,
      totalMentees: 12,
      isAvailable: true,
      maxMentees: 15,
    ),
    UserModel(
      id: '3',
      name: 'Emily Davis',
      email: 'emily.d@email.com',
      role: 'mentor',
      bio: 'Creative designer passionate about user-centered design',
      skills: ['Figma', 'Adobe XD', 'Prototyping', 'User Research'],
      interests: ['Design', 'Psychology', 'Art'],
      expertise: 'UI/UX Design',
      yearsOfExperience: 4,
      rating: 4.7,
      totalMentees: 20,
      isAvailable: false,
      maxMentees: 25,
    ),
    UserModel(
      id: '4',
      name: 'David Brown',
      email: 'david.b@email.com',
      role: 'mentor',
      bio: 'Data scientist specializing in ML and AI applications',
      skills: ['Python', 'Machine Learning', 'TensorFlow', 'Data Analysis'],
      interests: ['AI', 'Research', 'Statistics'],
      expertise: 'Data Science',
      yearsOfExperience: 6,
      rating: 4.9,
      totalMentees: 8,
      isAvailable: true,
      maxMentees: 10,
    ),
    UserModel(
      id: '5',
      name: 'Lisa Anderson',
      email: 'lisa.a@email.com',
      role: 'mentor',
      bio: 'Mobile developer with focus on cross-platform solutions',
      skills: ['React Native', 'Flutter', 'iOS', 'Android'],
      interests: ['Technology', 'Music', 'Travel'],
      expertise: 'Mobile Development',
      yearsOfExperience: 3,
      rating: 4.6,
      totalMentees: 18,
      isAvailable: true,
      maxMentees: 20,
    ),
  ];

  // Sample data - Mentees
  static List<UserModel> sampleMentees = [
    UserModel(
      id: '101',
      name: 'John Doe',
      email: 'john.doe@email.com',
      role: 'mentee',
      bio: 'Aspiring Flutter developer looking to improve my skills',
      skills: ['Flutter', 'Dart'],
      interests: ['Technology', 'Learning', 'Mobile Apps'],
      expertise: 'Mobile Development',
      mentorId: '1',
      goals: ['Learn State Management', 'Build First App', 'Understand Firebase'],
      completedGoals: 1,
      sessionsAttended: 5,
    ),
    UserModel(
      id: '102',
      name: 'Jane Smith',
      email: 'jane.smith@email.com',
      role: 'mentee',
      bio: 'Learning backend development and cloud technologies',
      skills: ['JavaScript', 'Node.js'],
      interests: ['Backend', 'Cloud', 'DevOps'],
      expertise: 'Backend Development',
      mentorId: '2',
      goals: ['Master Node.js', 'Learn AWS', 'Build REST APIs'],
      completedGoals: 2,
      sessionsAttended: 8,
    ),
  ];
}