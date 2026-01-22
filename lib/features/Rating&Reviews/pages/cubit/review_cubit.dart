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
  TextEditingController reviewController = TextEditingController();

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

  String? currentGoalId;
  String? currentUserId;
  String? currentMentorId;
  String? currentMenteeId;
  String? currentMatchId;
  MentorReviewModel? existingReview;


  List<MentorReviewModel> mentorReviews = [];
  Map<String, dynamic> ratingStats = {};

  
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

      log('Goal feedback submitted');
      emit(ReviewFeedbackAddedState());
    } catch (e) {
      log('Error submitting goal feedback: $e');
      emit(ReviewErrorState("Error submitting goal feedback"));
    }
  }


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
      currentMentorId = mentorId;
      if (existingReview != null) {
        reviewController.text = existingReview!.reviewText;
        selectedStarIndex = existingReview!.rating;
        log('Found existing review');
      }

      emit(ReviewLoadedState());
    } catch (e) {
      log('Error checking existing review: $e');
      emit(ReviewLoadedState());
    }
  }
  Future<void> submitMentorReview({
    required String mentorId,
    required String menteeId,
    required String matchId,
  }) async {
    emit(ReviewFeedbackLoading());
    try {
      if (reviewController.text.trim().isEmpty) {
        emit(ReviewErrorState('Please enter a review'));

        return;
      }

      if (selectedStarIndex == 0) {
        emit(ReviewErrorState('Please select a rating'));

        return;
      }

      if (existingReview != null) {
        await feedbackRepo.updateMentorReview(
          reviewId: existingReview!.id,
          rating: selectedStarIndex,
          reviewText: reviewController.text.trim(),
        );
        log('Mentor review updated');
      } else {
        await feedbackRepo.submitMentorReview(
          mentorId: mentorId,
          menteeId: menteeId,
          matchId: matchId,
          rating: selectedStarIndex,
          reviewText: reviewController.text.trim(),
        );
        log('Mentor review submitted');
      }

      reviewController.clear();
      selectedStarIndex = 0;
      existingReview = null;

      emit(ReviewFeedbackSubmittedState());
    } catch (e) {
      log('Error submitting mentor review: $e');
      emit(ReviewErrorState(e.toString()));
    }
  }
  Future<void> loadMentorReviews(String mentorId) async {
    emit(ReviewLoading());
    try {
      mentorReviews = await feedbackRepo.getMentorReviews(mentorId);
      ratingStats = await feedbackRepo.getMentorRatingStats(mentorId);
      currentMentorId = mentorId;
      log('Loaded ${mentorReviews.length} reviews');
      log('Average rating: ${ratingStats['average_rating']}');

      emit(ReviewLoadedState());
    } catch (e) {
      log('Error loading mentor reviews: $e');
      emit(ReviewErrorState(e.toString()));
    }
  }

  void clearForm() {
    feedbackController.clear();
    selectedStarIndex = 0;
    existingReview = null;
    emit(ReviewLoadedState());
  }

  int selectedResourceTypeIndex = 0;
  List<String> resourceTypes = [
    'Video',
    'Article',
    'Course',
    'Book',
    'Project',
    'Docs',
  ];

  List<IconData> resourceTypeIcons = [
    Icons.play_circle_outline,
    Icons.article_outlined,
    Icons.school_outlined,
    Icons.menu_book_outlined,
    Icons.folder_outlined,
    Icons.description_outlined,
  ];
  TextEditingController resourceTitleController = TextEditingController();
  TextEditingController resourceUrlController = TextEditingController();
  TextEditingController resourceDescriptionController = TextEditingController();

  List<Map<String, dynamic>> availableMentees = [];
  List<String> selectedMenteeIds = [];
  bool shareWithAll = false;

  void selectResourceType(int index) {
    emit(ReviewLoading());
    selectedResourceTypeIndex = index;
    log('Selected Resource Type: ${resourceTypes[index]}');
    emit(ReviewLoadedState());
  }

  void toggleMenteeSelection(String menteeId) {
    emit(ReviewLoading());
    if (selectedMenteeIds.contains(menteeId)) {
      selectedMenteeIds.remove(menteeId);
    } else {
      selectedMenteeIds.add(menteeId);
    }
   
    if (selectedMenteeIds.isNotEmpty) {
      shareWithAll = false;
    }
    log('Selected Mentees: $selectedMenteeIds');
    emit(ReviewLoadedState());
  }

  void toggleShareWithAll() {
    emit(ReviewLoading());
    shareWithAll = !shareWithAll;
    if (shareWithAll) {
      selectedMenteeIds.clear();
    }
    log('Share With All: $shareWithAll');
    emit(ReviewLoadedState());
  }

  Future<void> loadAvailableMentees(String mentorId) async {
    emit(ReviewLoading());
    try {
      availableMentees = await feedbackRepo.getMentorActiveMentees(mentorId);
      log('Loaded ${availableMentees.length} mentees for sharing');
      emit(ReviewLoadedState());
    } catch (e) {
      log('Error loading mentees: $e');
      emit(ReviewErrorState("Error loading mentees"));
    }
  }


  Future<void> shareResource(String mentorId) async {
    emit(ReviewFeedbackLoading());
    try {
      if (resourceTitleController.text.trim().isEmpty) {
        emit(ReviewErrorState('Please enter a resource title'));
        return;
      }

      if (resourceUrlController.text.trim().isEmpty) {
        emit(ReviewErrorState('Please enter a resource URL'));
        return;
      }

      if (!shareWithAll && selectedMenteeIds.isEmpty) {
        emit(
          ReviewErrorState('Please select mentees or choose "Share with All"'),
        );
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

      clearResourceForm();

      log('Resource shared successfully');
      emit(ReviewFeedbackLoadedState());
    } catch (e) {
      log('Error sharing resource: $e');
      emit(ReviewErrorState("Error sharing resource"));
    }
  }

  void clearResourceForm() {
    resourceTitleController.clear();
    resourceUrlController.clear();
    resourceDescriptionController.clear();
    selectedResourceTypeIndex = 0;
    selectedMenteeIds.clear();
    shareWithAll = false;
    emit(ReviewLoadedState());
  }

  List<Map<String, dynamic>> sharedResources = [];

  Future<void> loadSharedResources(String menteeId) async {
    emit(ReviewLoading());
    try {
      sharedResources = await feedbackRepo.getSharedResources(menteeId);
      log('Loaded ${sharedResources.length} shared resources');
      emit(ReviewLoadedState());
    } catch (e) {
      log('Error loading shared resources: $e');
      emit(ReviewErrorState("Failed to load shared resources"));
    }
  }

  Future<void> markResourceAsRead({
    required String resourceId,
    required String menteeId,
  }) async {
    try {
      await feedbackRepo.markResourceAsRead(
        resourceId: resourceId,
        menteeId: menteeId,
      );
      log('Resource marked as read');
    } catch (e) {
      log('Error marking resource as read: $e');
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
