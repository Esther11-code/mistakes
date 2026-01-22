import 'dart:developer';
import 'package:mistakes/main.dart';

class BookmarkRepo {
  Future<void> addMentorBookmark({
    required String menteeId,
    required String mentorId,
  }) async {
    try {
      log('Adding mentor bookmark');
      final existing = await supabase
          .from('bookmarks')
          .select()
          .eq('mentee_id', menteeId)
          .eq('mentor_id', mentorId)
          .maybeSingle();

      if (existing != null) {
        throw Exception('Mentor already bookmarked');
      }

      await supabase.from('bookmarks').insert({
        'mentee_id': menteeId,
        'mentor_id': mentorId,
        'created_at': DateTime.now().toIso8601String(),
      });

      log('Mentor bookmark added');
    } catch (e) {
      log(' Error: $e');
      rethrow;
    }
  }
  Future<void> removeMentorBookmark({
    required String menteeId,
    required String mentorId,
  }) async {
    try {
      log('Removing mentor bookmark');
      await supabase
          .from('bookmarks')
          .delete()
          .eq('mentee_id', menteeId)
          .eq('mentor_id', mentorId);

      log('Bookmark removed');
    } catch (e) {
      log(' Error: $e');
      rethrow;
    }
  }
  Future<bool> isMentorBookmarked({
    required String menteeId,
    required String mentorId,
  }) async {
    try {
      final result = await supabase
          .from('bookmarks')
          .select()
          .eq('mentee_id', menteeId)
          .eq('mentor_id', mentorId)
          .maybeSingle();

      return result != null;
    } catch (e) {
      log(' Error: $e');
      return false;
    }
  }
  Future<List<Map<String, dynamic>>> getBookmarkedMentors(
    String menteeId,
  ) async {
    try {
      log('Loading mentor bookmarks');

      final response = await supabase
          .from('bookmarks')
          .select('id, mentor_id, created_at')
          .eq('mentee_id', menteeId)
          .order('created_at', ascending: false);

      final bookmarks = <Map<String, dynamic>>[];
      for (var bookmark in response) {
        final mentorProfile = await supabase
            .from('profiles')
            .select('*')
            .eq('user_id', bookmark['mentor_id'])
            .single();

        final interests = mentorProfile['area_of_interest'] != null
            ? List<String>.from(mentorProfile['area_of_interest'])
            : <String>[];

        bookmarks.add({
          'bookmark_id': bookmark['id'],
          'mentor_id': bookmark['mentor_id'],
          'mentor_name': mentorProfile['full_name'],
          'mentor_username': mentorProfile['username'],
          'mentor_bio': mentorProfile['bio'],
          'mentor_photo': mentorProfile['profile_photo_url'],
          'mentor_expertise': mentorProfile['expertise'],
          'mentor_experience': mentorProfile['years_experience'],
          'mentor_skills': interests,
          'bookmarked_at': bookmark['created_at'],
        });
      }

      log('Found ${bookmarks.length} mentor bookmarks');
      return bookmarks;
    } catch (e) {
      log(' Error: $e');
      rethrow;
    }
  }


  Future<void> addResourceBookmark({
    required String userId,
    required String resourceId,
  }) async {
    try {
      log('Adding resource bookmark');

      final existing = await supabase
          .from('resource_bookmarks')
          .select()
          .eq('user_id', userId)
          .eq('resource_id', resourceId)
          .maybeSingle();

      if (existing != null) {
        throw Exception('Resource already bookmarked');
      }

      await supabase.from('resource_bookmarks').insert({
        'user_id': userId,
        'resource_id': resourceId,
        'created_at': DateTime.now().toIso8601String(),
      });

      log('Resource bookmark added');
    } catch (e) {
      log(' Error: $e');
      rethrow;
    }
  }

  Future<void> removeResourceBookmark({
    required String userId,
    required String resourceId,
  }) async {
    try {
      log('Removing resource bookmark');

      await supabase
          .from('resource_bookmarks')
          .delete()
          .eq('user_id', userId)
          .eq('resource_id', resourceId);

      log('Resource bookmark removed');
    } catch (e) {
      log(' Error: $e');
      rethrow;
    }
  }
  Future<bool> isResourceBookmarked({
    required String userId,
    required String resourceId,
  }) async {
    try {
      final result = await supabase
          .from('resource_bookmarks')
          .select()
          .eq('user_id', userId)
          .eq('resource_id', resourceId)
          .maybeSingle();

      return result != null;
    } catch (e) {
      log(' Error: $e');
      return false;
    }
  }
  Future<List<Map<String, dynamic>>> getBookmarkedResources(
    String userId,
  ) async {
    try {
      log('Loading resource bookmarks');

      final response = await supabase
          .from('resource_bookmarks')
          .select('id, resource_id, created_at')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final bookmarks = <Map<String, dynamic>>[];
      for (var bookmark in response) {
        final resource = await supabase
            .from('resources')
            .select('*')
            .eq('id', bookmark['resource_id'])
            .single();

        bookmarks.add({
          'bookmark_id': bookmark['id'],
          'resource_id': bookmark['resource_id'],
          'resource_title': resource['title'],
          'resource_description': resource['description'],
          'resource_type': resource['type'], 
          'resource_url': resource['url'],
          'resource_thumbnail': resource['thumbnail'],
          'bookmarked_at': bookmark['created_at'],
        });
      }

      log('Found ${bookmarks.length} resource bookmarks');
      return bookmarks;
    } catch (e) {
      log(' Error: $e');
      rethrow;
    }
  }
}
