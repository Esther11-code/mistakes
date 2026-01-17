import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mistakes/features/Profile/data/remote/mentor_repo.dart';

part 'mentor_state.dart';

class MentorCubit extends Cubit<MentorState> {
  final MentorRepo mentorRepo;

  MentorCubit(this.mentorRepo) : super(MentorInitial());

  // Mentor data
  Map<String, int> stats = {
    'activeMentees': 0,
    'pendingRequests': 0,
    'completedMentorships': 0,
    'totalHours': 0,
  };

  List<Map<String, dynamic>> recentActivities = [];
  List<Map<String, dynamic>> thisWeeksTasks = [];
  List<Map<String, dynamic>> activeMentees = [];
  List<Map<String, dynamic>> incomingRequests = [];

  TextEditingController welcomeMessageController = TextEditingController();

  Map<String, dynamic>? selectedMenteeDetails;

  // ============================================================================
  // LOAD ALL MENTOR DATA
  // ============================================================================
  Future<void> loadMentorDashboard(String mentorId) async {
    emit(MentorLoadingState());
    try {
      // Load all data in parallel
      await Future.wait([
        loadMentorStats(mentorId),
        loadRecentActivities(mentorId),
        loadThisWeeksTasks(mentorId),
        loadActiveMentees(mentorId),
        loadIncomingRequests(mentorId),
      ]);

      emit(MentorLoadedState());
    } catch (e) {
      log(' Error loading mentor dashboard: $e');
      emit(MentorErrorState(e.toString()));
    }
  }

  // ============================================================================
  // LOAD MENTOR STATS
  // ============================================================================
  Future<void> loadMentorStats(String mentorId) async {
    try {
      stats = await mentorRepo.getMentorStats(mentorId);
      log('Loaded mentor stats: $stats');
    } catch (e) {
      log(' Error loading stats: $e');
      rethrow;
    }
  }

  // ============================================================================
  // LOAD RECENT ACTIVITIES
  // ============================================================================
  Future<void> loadRecentActivities(String mentorId) async {
    try {
      recentActivities = await mentorRepo.getRecentActivities(mentorId);
      log('Loaded ${recentActivities.length} recent activities');
    } catch (e) {
      log(' Error loading activities: $e');
      rethrow;
    }
  }

  // ============================================================================
  // LOAD THIS WEEK'S TASKS
  // ============================================================================
  Future<void> loadThisWeeksTasks(String mentorId) async {
    try {
      thisWeeksTasks = await mentorRepo.getThisWeeksTasks(mentorId);
      log('Loaded ${thisWeeksTasks.length} tasks for this week');
    } catch (e) {
      log(' Error loading tasks: $e');
      rethrow;
    }
  }

  // ============================================================================
  // LOAD ACTIVE MENTEES
  // ============================================================================
  Future<void> loadActiveMentees(String mentorId) async {
    try {
      activeMentees = await mentorRepo.getActiveMentees(mentorId);
      log('Loaded ${activeMentees.length} active mentees');
    } catch (e) {
      log(' Error loading active mentees: $e');
      rethrow;
    }
  }

  // ============================================================================
  // LOAD INCOMING REQUESTS
  // ============================================================================
  Future<void> loadIncomingRequests(String mentorId) async {
    try {
      incomingRequests = await mentorRepo.getIncomingRequestsWithDetails(
        mentorId,
      );
      log('Loaded ${incomingRequests.length} incoming requests');
    } catch (e) {
      log(' Error loading incoming requests: $e');
      rethrow;
    }
  }

  // ============================================================================
  // LOAD MENTEE DETAILS (for request details page)
  // ============================================================================
  Future<void> loadMenteeDetails(String menteeId) async {
    emit(MentorLoadingState());
    try {
      selectedMenteeDetails = await mentorRepo.getMenteeDetails(menteeId);
      log('Loaded mentee details for $menteeId');
      emit(MentorLoadedState());
    } catch (e) {
      log(' Error loading mentee details: $e');
      emit(MentorErrorState(e.toString()));
    }
  }

  // ============================================================================
  // ACCEPT/DECLINE (reuse from ProfileCubit or move here)
  // ============================================================================
  Future<void> acceptRequest(String matchId, String mentorId) async {
    emit(MentorLoadingState());
    try {
      await mentorRepo.acceptRequest(matchId);

      // Reload data
      await loadIncomingRequests(mentorId);
      await loadMentorStats(mentorId);

      emit(MentorRequestAcceptedState());
      emit(MentorLoadedState());
    } catch (e) {
      log(' Error accepting request: $e');
      emit(MentorErrorState(e.toString()));
    }
  }

  Future<void> declineRequest(String matchId, String mentorId) async {
    emit(MentorLoadingState());
    try {
      await mentorRepo.declineRequest(matchId);

      // Reload data
      await loadIncomingRequests(mentorId);
      await loadMentorStats(mentorId);

      emit(MentorRequestDeclinedState());
      emit(MentorLoadedState());
    } catch (e) {
      log(' Error declining request: $e');
      emit(MentorErrorState(e.toString()));
    }
  }

  Map<String, dynamic>? selectedRequest;

  void setSelectedRequest(Map<String, dynamic> request) {
    emit(MentorLoadingState());
    selectedRequest = request;
    log('Selected request: ${request['match_id']}');
    emit(MentorRequestSelectedState());
  }

  // void clearSelectedRequest() {
  //   emit(MentorLoadingState());
  //   selectedRequest = null;
  //   emit(MentorLoadedState());
  // }

  Map<String, dynamic>? get selectedMentee =>
      selectedRequest?['mentee'] as Map<String, dynamic>?;

  String? get selectedMessage => selectedRequest?['message'] as String?;

  List<dynamic>? get selectedGoals =>
      selectedRequest?['goals'] as List<dynamic>?;

  String? get selectedMatchId => selectedRequest?['match_id'] as String?;

  DateTime? get selectedCreatedAt => selectedRequest != null
      ? DateTime.parse(selectedRequest!['created_at'] as String)
      : null;

  String get selectedMenteeName =>
      selectedMentee?['full_name'] ?? selectedMentee?['username'] ?? 'Unknown';

  String get selectedMenteeExpertise =>
      selectedMentee?['expertise'] ?? 'Not specified';

  String get selectedMenteeBio => selectedMentee?['bio'] ?? 'No bio available';

  String? get selectedMenteeAvatar => selectedMentee?['profile_photo_url'];

  String? get selectedMenteeLocation => selectedMentee?['location'];

  String get selectedMenteeUsername => selectedMentee?['username'] ?? '';
}
