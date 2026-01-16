import 'dart:developer';
import 'package:mistakes/features/Authentication/data/model/user_model.dart';
import 'package:mistakes/main.dart';

class HomeRepo {
  // ============================================================================
  // GET ALL USERS (Mentors and Mentees)
  // ============================================================================
  Future<List<UserModel>> getAllUsers() async {
    try {
      log('🔵 Fetching all users from database');

      final response = await supabase
          .from('profiles')
          .select('*') // ⭐ Simple select, no joins!
          .order('created_at', ascending: false);

      final users = <UserModel>[];

      for (var profile in response) {
        // ⭐ No more separate skills query!
        final interests = profile['area_of_interest'] != null
            ? List<String>.from(profile['area_of_interest'])
            : <String>[];

        final user = UserModel(
          id: profile['user_id'],
          name: profile['full_name'],
          role: profile['role'],
          username: profile['username'],
          bio: profile['bio'],
          profilePhotoUrl: profile['profile_photo_url'],
          expertise: profile['expertise'],
          yearsExperience: profile['years_experience'],
          availability: profile['availability'],
          learningGoals: profile['learning_goals'],
          location: profile['location'],
          linkedinUrl: profile['linkedin_url'],
          isVerified: profile['is_verified'] ?? false,
          interests: interests, // ⭐ Directly from profiles!
        );

        users.add(user);
      }

      log('Loaded ${users.length} users from database');
      return users;
    } catch (e) {
      log(' Error fetching users: $e');
      throw Exception('Failed to load users: ${e.toString()}');
    }
  }

  // ============================================================================
  // GET MENTORS ONLY
  // ============================================================================
  Future<List<UserModel>> getMentors() async {
    try {
      log('🔵 Fetching mentors from database');

      final response = await supabase
          .from('profiles')
          .select('''
            user_id,
            username,
            full_name,
            role,
            bio,
            profile_photo_url,
            expertise,
            years_experience,
            availability,
            location,
            linkedin_url,
            is_verified
          ''')
          .or('role.eq.mentor,role.eq.both')
          .order('years_experience', ascending: false);

      final mentors = <UserModel>[];

      for (var profile in response) {
        final skillsResponse = await supabase
            .from('user_skills')
            .select('skill_name')
            .eq('user_id', profile['user_id']);

        final interests = (skillsResponse as List)
            .map((item) => item['skill_name'] as String)
            .toList();

        final mentor = UserModel(
          id: profile['user_id'],
          name: profile['full_name'],
          role: profile['role'],
          username: profile['username'],
          bio: profile['bio'],
          profilePhotoUrl: profile['profile_photo_url'],
          expertise: profile['expertise'],
          yearsExperience: profile['years_experience'],
          availability: profile['availability'],
          location: profile['location'],
          linkedinUrl: profile['linkedin_url'],
          isVerified: profile['is_verified'] ?? false,
          interests: interests,
        );

        mentors.add(mentor);
      }

      log('Loaded ${mentors.length} mentors');
      return mentors;
    } catch (e) {
      log(' Error fetching mentors: $e');
      throw Exception('Failed to load mentors: ${e.toString()}');
    }
  }

  // ============================================================================
  // GET MENTEES ONLY
  // ============================================================================
  Future<List<UserModel>> getMentees() async {
    try {
      log('🔵 Fetching mentees from database');

      final response = await supabase
          .from('profiles')
          .select('''
            user_id,
            username,
            full_name,
            role,
            bio,
            profile_photo_url,
            area_of_interest,
            learning_goals,
            location,
            is_verified
          ''')
          .or('role.eq.mentee,role.eq.both')
          .order('created_at', ascending: false);

      final mentees = <UserModel>[];

      for (var profile in response) {
        final skillsResponse = await supabase
            .from('user_skills')
            .select('skill_name')
            .eq('user_id', profile['user_id']);

        final interests = (skillsResponse as List)
            .map((item) => item['skill_name'] as String)
            .toList();

        final mentee = UserModel(
          id: profile['user_id'],
          name: profile['full_name'],
          role: profile['role'],
          username: profile['username'],
          bio: profile['bio'],
          profilePhotoUrl: profile['profile_photo_url'],
          // areaOfInterest: profile['area_of_interest'],
          learningGoals: profile['learning_goals'],
          location: profile['location'],
          isVerified: profile['is_verified'] ?? false,
          interests: interests,
        );

        mentees.add(mentee);
      }

      log('Loaded ${mentees.length} mentees');
      return mentees;
    } catch (e) {
      log(' Error fetching mentees: $e');
      throw Exception('Failed to load mentees: ${e.toString()}');
    }
  }

  // ============================================================================
  // SEARCH USERS
  // ============================================================================
  Future<List<UserModel>> searchUsers({
    String? query,
    String? role,
    String? expertise,
    String? location,
  }) async {
    try {
      log('🔵 Searching users with query: $query');

      var queryBuilder = supabase.from('profiles').select('''
            user_id,
            username,
            full_name,
            role,
            bio,
            profile_photo_url,
            expertise,
            years_experience,
            availability,
            area_of_interest,
            learning_goals,
            location,
            linkedin_url,
            is_verified
          ''');

      // Apply filters
      if (role != null && role != 'All') {
        if (role.toLowerCase() == 'mentor') {
          queryBuilder = queryBuilder.or('role.eq.mentor,role.eq.both');
        } else if (role.toLowerCase() == 'mentee') {
          queryBuilder = queryBuilder.or('role.eq.mentee,role.eq.both');
        }
      }

      if (expertise != null && expertise != 'All') {
        queryBuilder = queryBuilder.eq('expertise', expertise);
      }

      if (location != null) {
        queryBuilder = queryBuilder.ilike('location', '%$location%');
      }

      // Execute query
      final response = await queryBuilder;

      final users = <UserModel>[];

      for (var profile in response) {
        final skillsResponse = await supabase
            .from('user_skills')
            .select('skill_name')
            .eq('user_id', profile['user_id']);

        final interests = (skillsResponse as List)
            .map((item) => item['skill_name'] as String)
            .toList();

        final user = UserModel(
          id: profile['user_id'],
          name: profile['full_name'],
          role: profile['role'],
          username: profile['username'],
          bio: profile['bio'],
          profilePhotoUrl: profile['profile_photo_url'],
          expertise: profile['expertise'],
          yearsExperience: profile['years_experience'],
          availability: profile['availability'],
          // areaOfInterest: profile['area_of_interest'],
          learningGoals: profile['learning_goals'],
          location: profile['location'],
          linkedinUrl: profile['linkedin_url'],
          isVerified: profile['is_verified'] ?? false,
          interests: interests,
        );

        // Apply local search filter if query provided
        if (query != null && query.isNotEmpty) {
          final searchQuery = query.toLowerCase();
          final matchesSearch =
              user.name!.toLowerCase().contains(searchQuery) ||
              (user.bio?.toLowerCase().contains(searchQuery) ?? false) ||
              (user.expertise?.toLowerCase().contains(searchQuery) ?? false) ||
              user.interests!.any((i) => i.toLowerCase().contains(searchQuery));

          if (matchesSearch) {
            users.add(user);
          }
        } else {
          users.add(user);
        }
      }

      log('Found ${users.length} users matching criteria');
      return users;
    } catch (e) {
      log(' Error searching users: $e');
      throw Exception('Failed to search users: ${e.toString()}');
    }
  }

  // ============================================================================
  // GET UNIQUE EXPERTISE LIST
  // ============================================================================
  Future<List<String>> getExpertiseList() async {
    try {
      final response = await supabase
          .from('profiles')
          .select('expertise')
          .not('expertise', 'is', null);

      final expertiseSet = <String>{};
      for (var item in response) {
        if (item['expertise'] != null && item['expertise'] != '') {
          expertiseSet.add(item['expertise']);
        }
      }

      return expertiseSet.toList()..sort();
    } catch (e) {
      log(' Error fetching expertise list: $e');
      return [];
    }
  }

  // ============================================================================
  // GET ALL SKILLS/INTERESTS
  // ============================================================================
  Future<List<String>> getAllSkills() async {
    try {
      final response = await supabase.from('user_skills').select('skill_name');

      final skillsSet = <String>{};
      for (var item in response) {
        skillsSet.add(item['skill_name']);
      }

      return skillsSet.toList()..sort();
    } catch (e) {
      log(' Error fetching skills: $e');
      return [];
    }
  }
}
