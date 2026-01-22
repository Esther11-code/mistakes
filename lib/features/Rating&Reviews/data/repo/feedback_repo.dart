import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/mentor_review_model.dart';
import 'package:mistakes/features/Goal/data/model/goal_comment_model.dart';

class FeedbackRepo {
  final supabase = Supabase.instance.client;
  Future<void> addGoalComment({
    required String goalId,
    required String userId,
    required String commentText,
    int? rating,
  }) async {
    try {
      await supabase.from('goal_comments').insert({
        'goal_id': goalId,
        'user_id': userId,
        'comment_text': commentText,
        'rating': rating,
      });

      log('Goal comment added with rating: $rating');
    } catch (e) {
      log('Error adding goal comment: $e');
      rethrow;
    }
  }
  Future<List<GoalCommentModel>> getGoalComments(String goalId) async {
    try {
      final response = await supabase
          .from('goal_comments')
          .select('''
            *,
            profiles!goal_comments_user_id_fkey(full_name, profile_photo_url)
          ''')
          .eq('goal_id', goalId)
          .order('created_at', ascending: false);

      return response.map<GoalCommentModel>((comment) {
        final profile = comment['profiles'];
        return GoalCommentModel(
          id: comment['id'],
          goalId: comment['goal_id'],
          userId: comment['user_id'],
          commentText: comment['comment_text'],
          rating: comment['rating'],
          createdAt: DateTime.parse(comment['created_at']),
          userName: profile?['full_name'],
          userAvatar: profile?['profile_photo_url'],
        );
      }).toList();
    } catch (e) {
      log('Error fetching goal comments: $e');
      rethrow;
    }
  }

  Future<void> submitMentorReview({
    required String mentorId,
    required String menteeId,
    required String matchId,
    required int rating,
    required String reviewText,
  }) async {
    try {
      final mentorProfile = await supabase
          .from('profiles')
          .select('id')
          .eq('user_id', mentorId)
          .single();

      final menteeProfile = await supabase
          .from('profiles')
          .select('id')
          .eq('user_id', menteeId)
          .single();

      await supabase.from('mentor_reviews').insert({
        'mentor_id': mentorProfile['id'],
        'mentee_id': menteeProfile['id'],
        'match_id': matchId,
        'rating': rating,
        'review_text': reviewText,
      });

      log('Mentor review submitted: $rating stars');
    } catch (e) {
      log('Error submitting mentor review: $e');
      rethrow;
    }
  }

  Future<void> updateMentorReview({
    required String reviewId,
    required int rating,
    required String reviewText,
  }) async {
    try {
      await supabase
          .from('mentor_reviews')
          .update({'rating': rating, 'review_text': reviewText})
          .eq('id', reviewId);

      log('Mentor review updated');
    } catch (e) {
      log('Error updating mentor review: $e');
      rethrow;
    }
  }
  Future<List<MentorReviewModel>> getMentorReviews(String mentorId) async {
    try {
      final mentorProfile = await supabase
          .from('profiles')
          .select('id')
          .eq('user_id', mentorId)
          .single();

      final response = await supabase
          .from('mentor_reviews')
          .select('''
            *,
            profiles!mentor_reviews_mentee_id_fkey(full_name, profile_photo_url)
          ''')
          .eq('mentor_id', mentorProfile['id'])
          .order('created_at', ascending: false);

      return response.map<MentorReviewModel>((review) {
        final profile = review['profiles'];
        return MentorReviewModel(
          id: review['id'],
          mentorId: review['mentor_id'],
          menteeId: review['mentee_id'],
          matchId: review['match_id'],
          rating: review['rating'],
          reviewText: review['review_text'],
          createdAt: DateTime.parse(review['created_at']),
          updatedAt: DateTime.parse(review['updated_at']),
          menteeName: profile?['full_name'],
          menteeAvatar: profile?['profile_photo_url'],
        );
      }).toList();
    } catch (e) {
      log('Error fetching mentor reviews: $e');
      rethrow;
    }
  }
  Future<Map<String, dynamic>> getMentorRatingStats(String mentorId) async {
    try {
      final mentorProfile = await supabase
          .from('profiles')
          .select('id')
          .eq('user_id', mentorId)
          .single();

      final reviews = await supabase
          .from('mentor_reviews')
          .select('rating')
          .eq('mentor_id', mentorProfile['id']);

      if (reviews.isEmpty) {
        return {
          'average_rating': 0.0,
          'total_reviews': 0,
          'rating_distribution': {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
        };
      }

      final totalRating = reviews.fold<int>(
        0,
        (sum, review) => sum + (review['rating'] as int),
      );
      final averageRating = totalRating / reviews.length;
      final distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
      for (var review in reviews) {
        final rating = review['rating'] as int;
        distribution[rating] = (distribution[rating] ?? 0) + 1;
      }

      return {
        'average_rating': double.parse(averageRating.toStringAsFixed(1)),
        'total_reviews': reviews.length,
        'rating_distribution': distribution,
      };
    } catch (e) {
      log('Error fetching mentor rating stats: $e');
      rethrow;
    }
  }

  Future<MentorReviewModel?> getExistingReview({
    required String mentorId,
    required String menteeId,
  }) async {
    try {
      final mentorProfile = await supabase
          .from('profiles')
          .select('id')
          .eq('user_id', mentorId)
          .single();

      final menteeProfile = await supabase
          .from('profiles')
          .select('id')
          .eq('user_id', menteeId)
          .single();

      final response = await supabase
          .from('mentor_reviews')
          .select('*')
          .eq('mentor_id', mentorProfile['id'])
          .eq('mentee_id', menteeProfile['id'])
          .maybeSingle();

      if (response == null) return null;

      return MentorReviewModel.fromJson(response);
    } catch (e) {
      log('Error checking existing review: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getMentorActiveMentees(
    String mentorId,
  ) async {
    try {
      final matchesResponse = await supabase
          .from('matches')
          .select('id, mentee_id')
          .eq('mentor_id', mentorId)
          .eq('status', 'accepted')
          .order('created_at', ascending: false);

      List<Map<String, dynamic>> mentees = [];

      for (var match in matchesResponse) {
        final menteeUserId = match['mentee_id']; 

        try {
          final menteeProfile = await supabase
              .from('profiles')
              .select(
                'id, user_id, full_name, username, profile_photo_url, area_of_interest, expertise',
              )
              .eq('user_id', menteeUserId) 
              .single();

          mentees.add({
            'mentee_id': menteeProfile['id'], 
            'user_id': menteeProfile['user_id'],
            'full_name': menteeProfile['full_name'],
            'expertise': menteeProfile['expertise'],
            'username': menteeProfile['username'],
            'profile_photo_url': menteeProfile['profile_photo_url'],
            'area_of_interest': menteeProfile['area_of_interest'] is List
                ? (menteeProfile['area_of_interest'] as List).join(', ')
                : menteeProfile['area_of_interest'] ?? 'Not specified',
            'match_id': match['id'],
          });
        } catch (e) {
          log('Skipping mentee $menteeUserId: $e');
        }
      }

      log('Fetched ${mentees.length} active mentees');
      return mentees;
    } catch (e) {
      log('Error fetching mentor mentees: $e');
      rethrow;
    }
  }


  Future<void> shareResource({
    required String mentorId,
    required String resourceType,
    required String title,
    required String url,
    String? description,
    required bool shareWithAll,
    required List<String> menteeIds,
  }) async {
    try {
      final mentorProfile = await supabase
          .from('profiles')
          .select('id')
          .eq('user_id', mentorId)
          .single();

      final resourceResponse = await supabase
          .from('shared_resources')
          .insert({
            'resource_type': resourceType,
            'resource_title': title,
            'resource_url': url,
            'description': description,
            'mentor_id': mentorProfile['id'],
            'share_with_all': shareWithAll,
          })
          .select()
          .single();

      final resourceId = resourceResponse['id'];
      if (!shareWithAll && menteeIds.isNotEmpty) {
        final shares = menteeIds
            .map(
              (menteeProfileId) => {
                'resource_id': resourceId,
                'mentee_id': menteeProfileId, 
              },
            )
            .toList();

        await supabase.from('resource_shares').insert(shares);
        log('Created ${shares.length} individual shares');
      }

      log('Resource shared successfully');
    } catch (e) {
      log('Error sharing resource: $e');
      rethrow;
    }
  }
  Future<List<Map<String, dynamic>>> getSharedResources(String menteeId) async {
    try {
      final menteeProfile = await supabase
          .from('profiles')
          .select('id')
          .eq('user_id', menteeId)
          .single();

      final menteeProfileId = menteeProfile['id'];
      final response = await supabase
          .from('shared_resources')
          .select('*')
          .or(
            'share_with_all.eq.true,id.in.(select resource_id from resource_shares where mentee_id=$menteeProfileId)',
          )
          .order('created_at', ascending: false);
      List<Map<String, dynamic>> resources = [];

      for (var resource in response) {
        try {
          final mentorProfile = await supabase
              .from('profiles')
              .select('full_name, username, profile_photo_url')
              .eq('id', resource['mentor_id'])
              .single();
          bool isRead = false;
          if (!resource['share_with_all']) {
            final shareStatus = await supabase
                .from('resource_shares')
                .select('is_read')
                .eq('resource_id', resource['id'])
                .eq('mentee_id', menteeProfileId)
                .maybeSingle();

            isRead = shareStatus?['is_read'] ?? false;
          }

          resources.add({
            'resource_id': resource['id'],
            'resource_type': resource['resource_type'],
            'resource_title': resource['resource_title'],
            'resource_url': resource['resource_url'],
            'description': resource['description'],
            'share_with_all': resource['share_with_all'],
            'created_at': resource['created_at'],
            'mentor_name':
                mentorProfile['full_name'] ?? mentorProfile['username'],
            'mentor_username': mentorProfile['username'],
            'mentor_avatar': mentorProfile['profile_photo_url'],
            'is_read': isRead,
          });
        } catch (e) {
          log('Skipping resource ${resource['id']}: $e');
        }
      }

      log('Fetched ${resources.length} shared resources');
      return resources;
    } catch (e) {
      log('Error fetching shared resources: $e');
      rethrow;
    }
  }
  Future<void> markResourceAsRead({
    required String resourceId,
    required String menteeId,
  }) async {
    try {
      final menteeProfile = await supabase
          .from('profiles')
          .select('id')
          .eq('user_id', menteeId)
          .single();

      await supabase
          .from('resource_shares')
          .update({'is_read': true})
          .eq('resource_id', resourceId)
          .eq('mentee_id', menteeProfile['id']);

      log('Resource marked as read');
    } catch (e) {
      log('Error marking resource as read: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getMentorSharedResources(
    String mentorId,
  ) async {
    try {
      final mentorProfile = await supabase
          .from('profiles')
          .select('id')
          .eq('user_id', mentorId)
          .single();

      final response = await supabase
          .from('shared_resources')
          .select('*')
          .eq('mentor_id', mentorProfile['id'])
          .order('created_at', ascending: false);

      List<Map<String, dynamic>> resources = [];

      for (var resource in response) {
        List<Map<String, dynamic>> sharedWith = [];
        int totalShares = 0;
        int readCount = 0;

        if (!resource['share_with_all']) {
          final shares = await supabase
              .from('resource_shares')
              .select('mentee_id, is_read')
              .eq('resource_id', resource['id']);

          totalShares = shares.length;
          readCount = shares.where((s) => s['is_read'] == true).length;
          for (var share in shares) {
            try {
              final menteeProfile = await supabase
                  .from('profiles')
                  .select('full_name, username')
                  .eq('id', share['mentee_id'])
                  .single();

              sharedWith.add({
                'mentee_id': share['mentee_id'],
                'name': menteeProfile['full_name'] ?? menteeProfile['username'],
                'is_read': share['is_read'],
              });
            } catch (e) {
              log('Skipping mentee ${share['mentee_id']}: $e');
            }
          }
        }

        resources.add({
          'resource_id': resource['id'],
          'resource_type': resource['resource_type'],
          'resource_title': resource['resource_title'],
          'resource_url': resource['resource_url'],
          'description': resource['description'],
          'share_with_all': resource['share_with_all'],
          'created_at': resource['created_at'],
          'total_shares': totalShares,
          'read_count': readCount,
          'shared_with': sharedWith,
        });
      }

      log('Fetched ${resources.length} mentor shared resources');
      return resources;
    } catch (e) {
      log('Error fetching mentor shared resources: $e');
      rethrow;
    }
  }
  Future<void> deleteSharedResource(String resourceId, String mentorId) async {
    try {
      final mentorProfile = await supabase
          .from('profiles')
          .select('id')
          .eq('user_id', mentorId)
          .single();

      await supabase
          .from('shared_resources')
          .delete()
          .eq('id', resourceId)
          .eq('mentor_id', mentorProfile['id']);

      log('Resource deleted');
    } catch (e) {
      log('Error deleting resource: $e');
      rethrow;
    }
  }
}
