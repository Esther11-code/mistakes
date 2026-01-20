import 'dart:developer';
import 'dart:io';
import 'package:mistakes/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepo {
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      log('Starting signup for: $email');
      final authResponse = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name, 'role': role},
      );

      if (authResponse.user == null) {
        throw Exception('Failed to create auth user');
      }

      final userId = authResponse.user!.id;
      log('Auth user created: $userId');

      return {
        'user_id': userId,
        'email': email,
        'name': name,
        'role': role,
        'success': true,
      };
    } catch (e) {
      log('Signup error: $e');
      throw Exception('Signup failed: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      log('Starting signin for: $email');

      final authResponse = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw Exception('Invalid email or password');
      }

      final userId = authResponse.user!.id;
      log('User authenticated: $userId');

      final profileResponse = await supabase
          .from('profiles')
          .select('*')
          .eq('user_id', userId)
          .single();

      log('Profile fetched from database');

      // ⭐ No more user_skills query! Just get from profiles
      final interests = profileResponse['area_of_interest'] != null
          ? List<String>.from(profileResponse['area_of_interest'])
          : <String>[];

      return {
        'user_id': userId,
        'email': authResponse.user!.email,
        'name': profileResponse['full_name'],
        'role': profileResponse['role'],
        'username': profileResponse['username'],
        'bio': profileResponse['bio'],
        'expertise': profileResponse['expertise'],
        'profile_photo_url': profileResponse['profile_photo_url'],
        'location': profileResponse['location'],
        'linkedin_url': profileResponse['linkedin_url'],
        'is_verified': profileResponse['is_verified'],
        'interests': interests, // ⭐ From profiles, not user_skills
        'success': true,
      };
    } on AuthApiException catch (e) {
      log('Signin error: $e');
      throw AuthApiException('Login failed: ${e.toString()}');
    }
  }

  Future<void> updateProfile({
    required String userId,
    String? bio,
    String? expertise,
    String? profilePhotoUrl,
    String? location,
    String? linkedinUrl,
    String? areaOfInterest, // for mentees
    String? learningGoals, // for mentees
    int? yearsExperience, // for mentors
    String? availability, // for mentors
  }) async {
    try {
      log('Updating profile for user: $userId');

      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (bio != null) updates['bio'] = bio;
      if (expertise != null) updates['expertise'] = expertise;
      if (profilePhotoUrl != null) {
        updates['profile_photo_url'] = profilePhotoUrl;
      }
      if (location != null) updates['location'] = location;
      if (linkedinUrl != null) updates['linkedin_url'] = linkedinUrl;
      if (areaOfInterest != null) updates['area_of_interest'] = areaOfInterest;
      if (learningGoals != null) updates['learning_goals'] = learningGoals;
      if (yearsExperience != null) {
        updates['years_experience'] = yearsExperience;
      }
      if (availability != null) updates['availability'] = availability;

      await supabase.from('profiles').update(updates).eq('user_id', userId);

      log('Profile updated successfully');
    } catch (e) {
      log('Update profile error: $e');
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }

  Future<void> saveInterests(List<String> selectedInterests) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      log('🔵 Saving ${selectedInterests.length} interests for user: $userId');

      // ⭐ Just update the profiles table - no user_skills!
      await supabase
          .from('profiles')
          .update({
            'area_of_interest': selectedInterests, // Save as array
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId);

      log('Interests saved successfully');
    } catch (e) {
      log(' Save interests error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final session = supabase.auth.currentSession;

      if (session == null) {
        log('No active session');
        return null;
      }

      final userId = session.user.id;
      log('Found active session for: $userId');
      final profileResponse = await supabase
          .from('profiles')
          .select('*')
          .eq('user_id', userId)
          .single();
      final skillsResponse = await supabase
          .from('user_skills')
          .select('skill_name')
          .eq('user_id', userId);

      final interests = (skillsResponse as List)
          .map((item) => item['skill_name'] as String)
          .toList();

      log('Current user loaded');

      return {
        'user_id': userId,
        'email': session.user.email,
        'name': profileResponse['full_name'],
        'role': profileResponse['role'],
        'username': profileResponse['username'],
        'bio': profileResponse['bio'],
        'expertise': profileResponse['expertise'],
        'profile_photo_url': profileResponse['profile_photo_url'],
        'location': profileResponse['location'],
        'linkedin_url': profileResponse['linkedin_url'],
        'is_verified': profileResponse['is_verified'],
        'area_of_interest': profileResponse['area_of_interest'],
        'interests': interests,
      };
    } catch (e) {
      log('Get current user error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      log('Signing out user');
      await supabase.auth.signOut();
      log('User signed out');
    } catch (e) {
      log('Signout error: $e');
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      log('🔵 Sending password reset email to: $email');

      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.mentorverse://reset-password',
      );

      log('Password reset email sent successfully');
      log('📧 Check email for reset link');
    } catch (e) {
      log(' Password reset error: $e');
      throw Exception('Failed to send reset email: ${e.toString()}');
    }
  }

  Future<void> updatePassword({required String newPassword}) async {
    try {
      log('Updating password');
      await supabase.auth.updateUser(UserAttributes(password: newPassword));
      log('Password updated successfully');
    } catch (e) {
      log('Update password error: $e');
      throw Exception('Failed to update password: ${e.toString()}');
    }
  }

  Future<String> uploadProfilePhoto({
    required String userId,
    required File imageFile,
  }) async {
    try {
      log('🔵 Uploading profile photo for user: $userId');

      // Generate unique filename
      final fileExt = imageFile.path.split('.').last;
      final fileName =
          '${userId}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = 'profile-photos/$fileName';

      // Upload to Supabase Storage
      await supabase.storage
          .from('profile-photos')
          .upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true, // Overwrite if exists
            ),
          );

      // Get public URL
      final publicUrl = supabase.storage
          .from('profile-photos')
          .getPublicUrl(filePath);

      log('Photo uploaded: $publicUrl');
      return publicUrl;
    } catch (e) {
      log(' Upload error: $e');
      throw Exception('Failed to upload photo: ${e.toString()}');
    }
  }

  /// Delete old profile photo from storage
  Future<void> deleteProfilePhoto(String photoUrl) async {
    try {
      // Extract file path from URL
      final uri = Uri.parse(photoUrl);
      final path = uri.pathSegments
          .skip(4)
          .join('/'); // Skip /storage/v1/object/public/profile-photos/

      await supabase.storage.from('profile-photos').remove([path]);
      log('Old photo deleted: $path');
    } catch (e) {
      log(' Delete error (non-critical): $e');
      // Don't throw - deleting old photo is not critical
    }
  }
}
