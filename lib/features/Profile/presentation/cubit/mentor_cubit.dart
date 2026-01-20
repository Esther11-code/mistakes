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
    emit(MentorLoadingState());
    try {
      recentActivities = await mentorRepo.getRecentActivities(mentorId);
      log('Loaded ${recentActivities.length} recent activities');
      emit(MentorLoadedState());
    } catch (e) {
      log(' Error loading activities: $e');
      rethrow;
    }
  }

  // ============================================================================
  // LOAD THIS WEEK'S TASKS
  // ============================================================================
  Future<void> loadThisWeeksTasks(String mentorId) async {
    emit(MentorLoadingState());
    try {
      thisWeeksTasks = await mentorRepo.getThisWeeksTasks(mentorId);
      log('Loaded ${thisWeeksTasks.length} tasks for this week');
      emit(MentorLoadedState());
    } catch (e) {
      log(' Error loading tasks: $e');
      rethrow;
    }
  }

  // ============================================================================
  // LOAD ACTIVE MENTEES
  // ============================================================================
  Future<void> loadActiveMentees(String mentorId) async {
    emit(MentorLoadingState());
    try {
      activeMentees = await mentorRepo.getActiveMentees(mentorId);
      log('Loaded ${activeMentees.length} active mentees');
      emit(MentorLoadedState());
    } catch (e) {
      log(' Error loading active mentees: $e');
      rethrow;
    }
  }

  // ============================================================================
  // LOAD INCOMING REQUESTS
  // ============================================================================
  Future<void> loadIncomingRequests(String mentorId) async {
    emit(MentorLoadingState());
    try {
      incomingRequests = await mentorRepo.getIncomingRequestsWithDetails(
        mentorId,
      );
      log('Loaded ${incomingRequests.length} incoming requests');
      emit(MentorLoadedState());
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
      await mentorRepo.acceptRequest(
        matchId,
        welcomeMessage: welcomeMessageController.text,
      );

      // Reload data
      await loadIncomingRequests(mentorId);
      await loadMentorStats(mentorId);

      emit(MentorRequestAcceptedState());
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

  // Settings data (stored in cubit, not state)
  bool acceptingNewRequests = true;
  int maxActiveMentees = 5;
  bool autoReply = false;
  Map<String, bool> notificationSettings = {
    'new_requests': false,
    'messages': true,
    'goal_completions': true,
  };

  // ============================================================================
  // LOAD MENTOR SETTINGS
  // ============================================================================
  Future<void> loadMentorSettings(String mentorId) async {
    emit(MentorLoadingState());
    try {
      final settings = await mentorRepo.getMentorSettings(mentorId);

      acceptingNewRequests = settings['accepting_requests'] ?? true;
      maxActiveMentees = settings['max_active_mentees'] ?? 5;
      autoReply = settings['auto_reply_enabled'] ?? false;

      notificationSettings = {
        'new_requests': settings['notify_new_requests'] ?? true,
        'messages': settings['notify_mentee_messages'] ?? true,
        'goal_completions': settings['notify_goal_completions'] ?? true,
      };

      emit(MentorSettingsLoadedState());
    } catch (e) {
      log('Error loading mentor settings: $e');
      emit(MentorErrorState(e.toString()));
    }
  }

  // ============================================================================
  // UPDATE ACCEPTING NEW REQUESTS
  // ============================================================================
  Future<void> toggleAcceptingNewRequests(String mentorId) async {
    try {
      final newValue = !acceptingNewRequests;
      await mentorRepo.updateAcceptingNewRequests(mentorId, newValue);

      acceptingNewRequests = newValue;

      emit(
        MentorSettingsUpdatedState(
          newValue
              ? 'Now accepting new requests'
              : 'No longer accepting new requests',
        ),
      );

      emit(MentorSettingsLoadedState());
    } catch (e) {
      log('Error toggling accepting new requests: $e');
      emit(MentorErrorState(e.toString()));
    }
  }

  // ============================================================================
  // UPDATE MAX ACTIVE MENTEES
  // ============================================================================
  Future<void> updateMaxMentees(String mentorId, int newMax) async {
    try {
      await mentorRepo.updateMaxActiveMentees(mentorId, newMax);

      maxActiveMentees = newMax;

      emit(MentorSettingsUpdatedState('Max active mentees updated to $newMax'));
      emit(MentorSettingsLoadedState());
    } catch (e) {
      log('Error updating max mentees: $e');
      emit(MentorErrorState(e.toString()));
    }
  }

  // ============================================================================
  // TOGGLE AUTO REPLY
  // ============================================================================
  Future<void> toggleAutoReply(String mentorId) async {
    try {
      final newValue = !autoReply;
      await mentorRepo.updateAutoReply(mentorId, newValue);

      autoReply = newValue;

      emit(
        MentorSettingsUpdatedState(
          newValue ? 'Auto-reply enabled' : 'Auto-reply disabled',
        ),
      );

      emit(MentorSettingsLoadedState());
    } catch (e) {
      log('Error toggling auto-reply: $e');
      emit(MentorErrorState(e.toString()));
    }
  }

  // ============================================================================
  // UPDATE NOTIFICATION SETTINGS
  // ============================================================================
  Future<void> toggleNotification(
    String mentorId,
    String notificationType,
  ) async {
    try {
      final currentValue = notificationSettings[notificationType] ?? false;
      final newValue = !currentValue;

      await mentorRepo.updateNotificationSetting(
        mentorId,
        notificationType,
        newValue,
      );

      notificationSettings[notificationType] = newValue;

      emit(
        MentorSettingsUpdatedState(
          '${notificationType.replaceAll('_', ' ')} notifications ${newValue ? 'enabled' : 'disabled'}',
        ),
      );

      emit(MentorSettingsLoadedState());
    } catch (e) {
      log('Error toggling notification: $e');
      emit(MentorErrorState(e.toString()));
    }
  }
}
