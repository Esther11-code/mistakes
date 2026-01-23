import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mistakes/features/Profile/data/remote/mentor_repo.dart';

part 'mentor_state.dart';

class MentorCubit extends Cubit<MentorState> {
  final MentorRepo mentorRepo;

  MentorCubit(this.mentorRepo) : super(MentorInitial());

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
  Future<void> loadMentorDashboard(String mentorId) async {
    emit(MentorLoadingState());
    try {
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

  Future<void> loadMentorStats(String mentorId) async {
    try {
      stats = await mentorRepo.getMentorStats(mentorId);
      log('Loaded mentor stats: $stats');
    } catch (e) {
      log(' Error loading stats: $e');
      rethrow;
    }
  }

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

  Future<void> loadThisWeeksTasks(String mentorId) async {
    emit(MentorLoadingState());
    try {
      thisWeeksTasks = await mentorRepo.getThisWeeksTasks(mentorId);
      log('Loaded ${thisWeeksTasks.length} tasks for this week');
      await mentorRepo.debugThisWeeksTasks(mentorId);

      emit(MentorLoadedState());
    } catch (e) {
      log(' Error loading tasks: $e');
      rethrow;
    }
  }

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

  Future<void> acceptRequest(String matchId, String mentorId) async {
    emit(MentorLoadingState());
    try {
      await mentorRepo.acceptRequest(
        matchId,
        welcomeMessage: welcomeMessageController.text,
      );
      final menteeId = selectedRequest?['mentee_id'] as String?;
      if (menteeId != null) {
        final mentorName = await mentorRepo.getMentorName(mentorId);
        await mentorRepo.saveAchievementForMentee(
          menteeId,
          'first_mentorship_started',
          metadata: {
            'mentor_name': mentorName,
            'welcome_message': welcomeMessageController.text,
          },
        );

        log('Achievement saved for mentee: $menteeId');
      }
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
  List<dynamic>? get selectedInterests =>
      selectedRequest?['area_of_interest'] as List<dynamic>?;

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
  bool acceptingNewRequests = true;
  int maxActiveMentees = 5;
  bool autoReply = false;
  Map<String, bool> notificationSettings = {
    'new_requests': false,
    'messages': true,
    'goal_completions': true,
  };
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

  Future<void> updateMaxMentees(String mentorId, int newMax) async {
    try {
      await mentorRepo.updateMaxActiveMentees(mentorId, newMax);

      maxActiveMentees = newMax;

      emit(MentorSettingsUpdatedState('Max active mentees updated to $newMax'));
    } catch (e) {
      log('Error updating max mentees: $e');
      emit(MentorErrorState(e.toString()));
    }
  }

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

  Map<String, dynamic>? currentMentor;
  List<Map<String, dynamic>> allMentorships = [];
  Future<void> loadMenteeMentor(String menteeId) async {
    emit(MentorLoadingState());
    try {
      currentMentor = await mentorRepo.getMenteeMentorDetails(menteeId);

      if (currentMentor == null) {
        log('Mentee has no active mentor');
        emit(MentorLoadedState());
      } else {
        log('Loaded current mentor: ${currentMentor!['full_name']}');
        emit(MentorLoadedState());
      }
    } catch (e) {
      log('Error loading mentee\'s mentor: $e');
      emit(MentorErrorState(e.toString()));
    }
  }

  Future<void> loadAllMenteeMentorships(String menteeId) async {
    emit(MentorLoadingState());
    try {
      allMentorships = await mentorRepo.getAllMenteeMentorships(menteeId);
      log('Loaded ${allMentorships.length} mentorships');
      emit(MentorLoadedState());
    } catch (e) {
      log('Error loading mentorships: $e');
      emit(MentorErrorState(e.toString()));
    }
  }

  String? get currentMentorName => currentMentor?['full_name'] ?? "No mentor";
  String? get currentMentorId => currentMentor?['mentor_id'] ?? "";
  String? get currentMentorBio => currentMentor?['bio'] ?? "No bio";
  String? get currentMentorExpertise =>
      currentMentor?['expertise'] ?? "No expertise";
  String? get currentMentorAvatar => currentMentor?['profile_photo_url'];
  int? get currentMentorYearsExperience =>
      currentMentor?['years_experience'] ?? 0;
  String? get currentMentorLinkedIn => currentMentor?['linkedin_url'];
  String? get currentMentorMatchId => currentMentor?['match_id'];
  String? get currentMentorUsername => currentMentor?['username'];
  List<dynamic>? get currentMentorSkills =>
      currentMentor?['skills'] ?? "No skills";
  int? get totalGoalsWithMentor => currentMentor?['total_goals'];
  int? get completedGoalsWithMentor => currentMentor?['completed_goals'];
  String? get mentorshipWelcomeMessage => currentMentor?['welcome_message'];
  DateTime? get mentorshipStartedAt =>
      currentMentor?['mentorship_started_at'] != null
      ? DateTime.parse(currentMentor!['mentorship_started_at'])
      : null;

  bool get hasMentor => currentMentor != null;
  bool hasActiveMentor = false;
  Future<void> checkActiveMentor(String menteeId) async {
    try {
      hasActiveMentor = await mentorRepo.hasActiveMentor(menteeId);
      log('Has active mentor: $hasActiveMentor');
      emit(MentorLoadedState());
    } catch (e) {
      log('Error checking active mentor: $e');
    }
  }

  Future<void> endMentorship(String matchId, String reason) async {
    emit(MentorLoadingState());
    try {
      await mentorRepo.endMentorship(matchId, reason);
      currentMentor = null;
      hasActiveMentor = false;

      log('Mentorship ended successfully');
      emit(MentorshipEndedState());
    } catch (e) {
      log('Error ending mentorship: $e');
      emit(MentorErrorState(e.toString()));
    }
  }
}
