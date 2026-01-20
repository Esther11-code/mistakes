import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mistakes/features/Rating&Reviews/data/model/mentor_review_model.dart';
import 'package:mistakes/features/Rating&Reviews/data/repo/feedback_repo.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final FeedbackRepo feedbackRepo;
  ReviewCubit(this.feedbackRepo) : super(ReviewInitial());
  TextEditingController feedbackController = TextEditingController();

  int selectedStatusIndex = 1;
  List<String> status = ['All', 'Needs Action', 'On Track'];
  bool displayFeedbackField = false;

  int selectedStarIndex = 0;
  void changeStatus(int index) {
    emit(ReviewStatusChanged());
    selectedStatusIndex = index;
    log('Selected Status Index: $selectedStatusIndex');
    emit(ReviewLoadedState());
  }

  void submitFeedback() {
    emit(ReviewFeedbackLoading());
    // Simulate feedback submission process
    Future.delayed(const Duration(seconds: 2), () {
      log('Feedback submitted: ${feedbackController.text}');
      feedbackController.clear();
      displayFeedbackField = true;
      emit(ReviewFeedbackLoadedState());
    });
  }

  void showColor({required int index}) {
    emit(ReviewLoading());
    selectedStarIndex = index;

    emit(ReviewLoadedState());
  }

  // Goal comment data
  String? currentGoalId;
  String? currentUserId;

  // Mentor review data
  String? currentMentorId;
  String? currentMenteeId;
  String? currentMatchId;
  MentorReviewModel? existingReview;

  // Reviews list
  List<MentorReviewModel> mentorReviews = [];
  Map<String, dynamic> ratingStats = {};

  // ============================================================================
  // GOAL COMMENTS (Mentor → Mentee Goal Feedback)
  // ============================================================================

  Future<void> submitGoalFeedback({
    required String goalId,
    required String userId,
  }) async {
    emit(ReviewFeedbackLoading());
    try {
      if (feedbackController.text.trim().isEmpty) {
        emit(ReviewErrorState('Please enter feedback'));
        return;
      }

      if (selectedStarIndex == 0) {
        emit(ReviewErrorState('Please select a rating'));
        return;
      }

      await feedbackRepo.addGoalComment(
        goalId: goalId,
        userId: userId,
        commentText: feedbackController.text.trim(),
        rating: selectedStarIndex,
      );

      feedbackController.clear();
      selectedStarIndex = 0;

      log('✅ Goal feedback submitted');
      emit(ReviewFeedbackAddedState());
    } catch (e) {
      log('❌ Error submitting goal feedback: $e');
      emit(ReviewErrorState(e.toString()));
    }
  }

  // ============================================================================
  // MENTOR REVIEWS (Mentee → Mentor)
  // ============================================================================

  // Check if review already exists
  Future<void> checkExistingReview({
    required String mentorId,
    required String menteeId,
  }) async {
    emit(ReviewLoading());
    try {
      existingReview = await feedbackRepo.getExistingReview(
        mentorId: mentorId,
        menteeId: menteeId,
      );

      if (existingReview != null) {
        // Pre-fill form with existing review
        feedbackController.text = existingReview!.reviewText;
        selectedStarIndex = existingReview!.rating;
        log('📝 Found existing review');
      }

      emit(ReviewLoadedState());
    } catch (e) {
      log('❌ Error checking existing review: $e');
      emit(ReviewLoadedState());
    }
  }

  // Submit or update mentor review
  Future<void> submitMentorReview({
    required String mentorId,
    required String menteeId,
    required String matchId,
  }) async {
    emit(ReviewFeedbackLoading());
    try {
      if (feedbackController.text.trim().isEmpty) {
        emit(ReviewErrorState('Please enter a review'));
        emit(ReviewLoadedState());
        return;
      }

      if (selectedStarIndex == 0) {
        emit(ReviewErrorState('Please select a rating'));
        emit(ReviewLoadedState());
        return;
      }

      if (existingReview != null) {
        // Update existing review
        await feedbackRepo.updateMentorReview(
          reviewId: existingReview!.id,
          rating: selectedStarIndex,
          reviewText: feedbackController.text.trim(),
        );
        log('✅ Mentor review updated');
      } else {
        // Submit new review
        await feedbackRepo.submitMentorReview(
          mentorId: mentorId,
          menteeId: menteeId,
          matchId: matchId,
          rating: selectedStarIndex,
          reviewText: feedbackController.text.trim(),
        );
        log('✅ Mentor review submitted');
      }

      feedbackController.clear();
      selectedStarIndex = 0;
      existingReview = null;

      emit(ReviewFeedbackLoadedState());
    } catch (e) {
      log('❌ Error submitting mentor review: $e');
      emit(ReviewErrorState(e.toString()));
      emit(ReviewLoadedState());
    }
  }

  // Load all reviews for a mentor
  Future<void> loadMentorReviews(String mentorId) async {
    emit(ReviewLoading());
    try {
      mentorReviews = await feedbackRepo.getMentorReviews(mentorId);
      ratingStats = await feedbackRepo.getMentorRatingStats(mentorId);

      log('✅ Loaded ${mentorReviews.length} reviews');
      log('📊 Average rating: ${ratingStats['average_rating']}');

      emit(ReviewLoadedState());
    } catch (e) {
      log('❌ Error loading mentor reviews: $e');
      emit(ReviewErrorState(e.toString()));
      emit(ReviewLoadedState());
    }
  }

  void clearForm() {
    feedbackController.clear();
    selectedStarIndex = 0;
    existingReview = null;
    emit(ReviewLoadedState());
  }

int selectedResourceTypeIndex = 0;
List<String> resourceTypes = ['Video', 'Article', 'Course', 'Book', 'Project', 'Docs'];
List<IconData> resourceTypeIcons = [
  Icons.play_circle_outline,
  Icons.article_outlined,
  Icons.school_outlined,
  Icons.menu_book_outlined,
  Icons.folder_outlined,
  Icons.description_outlined,
];

// Form controllers
TextEditingController resourceTitleController = TextEditingController();
TextEditingController resourceUrlController = TextEditingController();
TextEditingController resourceDescriptionController = TextEditingController();

// Mentee selection
List<Map<String, dynamic>> availableMentees = [];
List<String> selectedMenteeIds = [];
bool shareWithAll = false;

// Change selected resource type
void selectResourceType(int index) {
  emit(ReviewLoading());
  selectedResourceTypeIndex = index;
  log('Selected Resource Type: ${resourceTypes[index]}');
  emit(ReviewLoadedState());
}

// Toggle mentee selection
void toggleMenteeSelection(String menteeId) {
  emit(ReviewLoading());
  if (selectedMenteeIds.contains(menteeId)) {
    selectedMenteeIds.remove(menteeId);
  } else {
    selectedMenteeIds.add(menteeId);
  }
  // If selecting individual mentees, disable "share with all"
  if (selectedMenteeIds.isNotEmpty) {
    shareWithAll = false;
  }
  log('Selected Mentees: $selectedMenteeIds');
  emit(ReviewLoadedState());
}

// Toggle share with all mentees
void toggleShareWithAll() {
  emit(ReviewLoading());
  shareWithAll = !shareWithAll;
  // If sharing with all, clear individual selections
  if (shareWithAll) {
    selectedMenteeIds.clear();
  }
  log('Share With All: $shareWithAll');
  emit(ReviewLoadedState());
}

// Load available mentees for sharing
Future<void> loadAvailableMentees(String mentorId) async {
  emit(ReviewLoading());
  try {
    availableMentees = await feedbackRepo.getMentorActiveMentees(mentorId);
    log('✅ Loaded ${availableMentees.length} mentees for sharing');
    emit(ReviewLoadedState());
  } catch (e) {
    log('❌ Error loading mentees: $e');
    emit(ReviewErrorState(e.toString()));
    emit(ReviewLoadedState());
  }
}

// Share resource
Future<void> shareResource(String mentorId) async {
  emit(ReviewFeedbackLoading());
  try {
    // Validation
    if (resourceTitleController.text.trim().isEmpty) {
      emit(ReviewErrorState('Please enter a resource title'));
      emit(ReviewLoadedState());
      return;
    }

    if (resourceUrlController.text.trim().isEmpty) {
      emit(ReviewErrorState('Please enter a resource URL'));
      emit(ReviewLoadedState());
      return;
    }

    if (!shareWithAll && selectedMenteeIds.isEmpty) {
      emit(ReviewErrorState('Please select mentees or choose "Share with All"'));
      emit(ReviewLoadedState());
      return;
    }

    await feedbackRepo.shareResource(
      mentorId: mentorId,
      resourceType: resourceTypes[selectedResourceTypeIndex],
      title: resourceTitleController.text.trim(),
      url: resourceUrlController.text.trim(),
      description: resourceDescriptionController.text.trim(),
      shareWithAll: shareWithAll,
      menteeIds: shareWithAll ? [] : selectedMenteeIds,
    );

    // Clear form
    clearResourceForm();

    log('✅ Resource shared successfully');
    emit(ReviewFeedbackLoadedState());
  } catch (e) {
    log('❌ Error sharing resource: $e');
    emit(ReviewErrorState(e.toString()));
    emit(ReviewLoadedState());
  }
}

// Clear resource form
void clearResourceForm() {
  resourceTitleController.clear();
  resourceUrlController.clear();
  resourceDescriptionController.clear();
  selectedResourceTypeIndex = 0;
  selectedMenteeIds.clear();
  shareWithAll = false;
  emit(ReviewLoadedState());
}

// For mentees - load shared resources
List<Map<String, dynamic>> sharedResources = [];

Future<void> loadSharedResources(String menteeId) async {
  emit(ReviewLoading());
  try {
    sharedResources = await feedbackRepo.getSharedResources(menteeId);
    log('✅ Loaded ${sharedResources.length} shared resources');
    emit(ReviewLoadedState());
  } catch (e) {
    log('❌ Error loading shared resources: $e');
    emit(ReviewErrorState(e.toString()));
    emit(ReviewLoadedState());
  }
}

// Mark resource as read
Future<void> markResourceAsRead({
  required String resourceId,
  required String menteeId,
}) async {
  try {
    await feedbackRepo.markResourceAsRead(
      resourceId: resourceId,
      menteeId: menteeId,
    );
    log('✅ Resource marked as read');
  } catch (e) {
    log('❌ Error marking resource as read: $e');
  }
}

@override
Future<void> close() {
  feedbackController.dispose();
  resourceTitleController.dispose();
  resourceUrlController.dispose();
  resourceDescriptionController.dispose();
  return super.close();
}
}
