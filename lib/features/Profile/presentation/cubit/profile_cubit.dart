import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mistakes/features/Authentication/data/model/user_model.dart';
import 'package:mistakes/features/Profile/data/remote/match_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final MatchesRepo matchesRepo;

  ProfileCubit(this.matchesRepo) : super(ProfileInitial());

  UserModel user = UserModel();
  UserModel? selectedMentor;
  String? buttonText = 'Request Mentor';
  String? dialogText = 'Request Sent';
  String? requestStatus = 'Pending';
  String? dialogSubText = 'Your mentorship request has been sent successfully';

  // Request mentorship fields
  final TextEditingController messageController = TextEditingController();
  List<String> selectedGoals = [];

  // Available goals
  final List<Map<String, dynamic>> availableGoals = [
    // Career & Professional
    {'label': 'Career Growth', 'icon': Icons.trending_up, 'category': 'Career'},
    {
      'label': 'Job Interview Prep',
      'icon': Icons.work_outline,
      'category': 'Career',
    },
    {
      'label': 'Resume Building',
      'icon': Icons.description,
      'category': 'Career',
    },
    {'label': 'Networking', 'icon': Icons.group_add, 'category': 'Career'},

    // Technical Skills
    {'label': 'Technical Skills', 'icon': Icons.code, 'category': 'Technical'},
    {'label': 'Web Development', 'icon': Icons.web, 'category': 'Technical'},
    {
      'label': 'Mobile Development',
      'icon': Icons.phone_android,
      'category': 'Technical',
    },
    {'label': 'Data Science', 'icon': Icons.analytics, 'category': 'Technical'},

    // Soft Skills
    {'label': 'Leadership', 'icon': Icons.groups, 'category': 'Soft Skills'},
    {
      'label': 'Communication',
      'icon': Icons.chat_bubble_outline,
      'category': 'Soft Skills',
    },
    {
      'label': 'Problem Solving',
      'icon': Icons.lightbulb_outline,
      'category': 'Soft Skills',
    },
    {
      'label': 'Time Management',
      'icon': Icons.schedule,
      'category': 'Soft Skills',
    },

    // Business
    {
      'label': 'Entrepreneurship',
      'icon': Icons.business_center,
      'category': 'Business',
    },
    {
      'label': 'Business Strategy',
      'icon': Icons.timeline,
      'category': 'Business',
    },
    {
      'label': 'Project Management',
      'icon': Icons.assignment,
      'category': 'Business',
    },
  ];

  // Lists
  List<Map<String, dynamic>> myPendingRequests = [];
  List<Map<String, dynamic>> incomingRequests = [];
  List<Map<String, dynamic>> activeMentorships = [];

  /// Set selected mentor
  void setSelectedMentor(UserModel mentor) {
    emit(SelectedMentorLoadingState());
    selectedMentor = mentor;
    emit(SelectedMentorState());
  }

  /// Clear selected mentor
  void clearSelectedMentor() {
    selectedMentor = null;
    clearRequestForm();
    emit(ProfileInitial());
  }

  /// Toggle goal selection
  void toggleGoal(String goal) {
    if (selectedGoals.contains(goal)) {
      selectedGoals.remove(goal);
    } else {
      selectedGoals.add(goal);
    }
    emit(GoalsUpdatedState(selectedGoals: List.from(selectedGoals)));
  }

  /// Clear request form
  void clearRequestForm() {
    selectedGoals.clear();
    messageController.clear();
    emit(ProfileInitial());
  }

  /// Validate request
  bool validateRequest() {
    if (messageController.text.trim().isEmpty) {
      emit(ProfileErrorState('Please explain why you need mentorship'));
      return false;
    }

    if (selectedGoals.length < 2) {
      emit(ProfileErrorState('Please select at least 2 goals'));
      return false;
    }

    return true;
  }

  /// Send mentorship request
  Future<void> sendMentorshipRequest({
    required String menteeId,
    required String mentorId,
  }) async {
    if (!validateRequest()) {
      emit(ProfileLoadedState());
      return;
    }

    emit(ProfileLoadingState());
    try {
      // ⭐ Call repo method
      await matchesRepo.sendMentorshipRequest(
        menteeId: menteeId,
        mentorId: mentorId,
        message: messageController.text.trim(),
        goals: selectedGoals,
      );

      clearRequestForm();

      emit(RequestSentState());
    } catch (e) {
      log(' [ProfileCubit] Error: $e');
      emit(ProfileErrorState(e.toString()));
      emit(ProfileLoadedState());
    }
  }

  /// Load my pending requests (mentee)
  Future<void> loadMyPendingRequests(String menteeId) async {
    emit(ProfileLoadingState());
    try {
      myPendingRequests = await matchesRepo.getMyPendingRequests(menteeId);
      emit(ProfileLoadedState());
    } catch (e) {
      log(' [ProfileCubit] Error: $e');
      emit(ProfileErrorState('Failed to load requests'));
      emit(ProfileLoadedState());
    }
  }

  /// Load incoming requests (mentor)
  Future<void> loadIncomingRequests(String mentorId) async {
    emit(ProfileLoadingState());
    try {
      incomingRequests = await matchesRepo.getIncomingRequests(mentorId);
      emit(ProfileLoadedState());
    } catch (e) {
      log(' [ProfileCubit] Error: $e');
      emit(ProfileErrorState('Failed to load requests'));
      emit(ProfileLoadedState());
    }
  }

  /// Accept request
  Future<void> acceptRequest(String matchId) async {
    emit(ProfileLoadingState());
    try {
      await matchesRepo.acceptRequest(matchId);
      incomingRequests.removeWhere((r) => r['match_id'] == matchId);

      emit(RequestAcceptedState());
      emit(ProfileLoadedState());
    } catch (e) {
      log(' [ProfileCubit] Error: $e');
      emit(ProfileErrorState('Failed to accept request'));
      emit(ProfileLoadedState());
    }
  }

  /// Decline request
  Future<void> declineRequest(String matchId) async {
    emit(ProfileLoadingState());
    try {
      await matchesRepo.declineRequest(matchId);
      incomingRequests.removeWhere((r) => r['match_id'] == matchId);

      emit(RequestDeclinedState());
      emit(ProfileLoadedState());
    } catch (e) {
      log(' [ProfileCubit] Error: $e');
      emit(ProfileErrorState('Failed to decline request'));
      emit(ProfileLoadedState());
    }
  }

  /// Load active mentorships
  Future<void> loadActiveMentorships({
    required String userId,
    required bool isMentor,
  }) async {
    emit(ProfileLoadingState());
    try {
      activeMentorships = await matchesRepo.getActiveMentorships(
        userId: userId,
        isMentor: isMentor,
      );
      log('[ProfileCubit] Active mentorships loaded: $activeMentorships');
      emit(ProfileLoadedState());
    } catch (e) {
      log(' [ProfileCubit] Error: $e');
      emit(ProfileErrorState('Failed to load mentorships'));
      emit(ProfileLoadedState());
    }
  }

  /// Check match status
  Future<String?> checkMatchStatus({
    required String menteeId,
    required String mentorId,
  }) async {
    try {
      emit(ProfileLoadingState());
      final status = await matchesRepo.checkMatchStatus(
        menteeId: menteeId,
        mentorId: mentorId,
      );
      log('[ProfileCubit] Match status: $status');
      buttonText = status == null
          ? 'Request Mentor'
          : status == 'pending'
          ? 'Request Pending'
          : status == 'accepted'
          ? 'Mentorship Active'
          : 'Request Declined';
      requestStatus = status ?? 'Pending';
      dialogText = status == 'accepted'
          ? 'Mentorship Active'
          : status == 'pending'
          ? 'Request Pending'
          : 'Request Sent';
      dialogSubText = status == 'accepted'
          ? 'Your mentorship request has been accepted. Time to grow together.'
          : status == 'pending'
          ? 'Please wait while your request is pending review.'
          : 'Your mentorship request has been sent successfully.';
      emit(ProfileLoadedState());
      return status;
    } catch (e) {
      log(' [ProfileCubit] Error: $e');
      emit(ProfileErrorState('Failed to check match status'));
      return null;
    }
  }

  get isRequestButtonDisabled {
    if (buttonText == 'Request Mentor') {
      return false;
    } else {
      return true;
    }
  }

  // ⭐ Status filter options
  final List<String> currentRequestFilter = [
    'All',
    'Pending',
    'Accepted',
    'Declined',
  ];
  int selectedStatusIndex = 0;

  // ⭐ All requests (unfiltered)
  List<Map<String, dynamic>> allRequests = [];

  // ⭐ Change status filter
  void changeStatus(int index) {
    emit(ProfileLoadingState());
    selectedStatusIndex = index;

    // Filter requests based on selected status
    if (index == 0) {
      // All
      myPendingRequests = List.from(allRequests);
    } else {
      // Filter by status
      String status = currentRequestFilter[index].toLowerCase();
      myPendingRequests = allRequests
          .where((request) => request['status'] == status)
          .toList();
    }

    emit(ProfileLoadedState());
  }

  // ⭐ Load all requests (update existing function)
  Future<void> loadAllMyRequests(String menteeId) async {
    emit(ProfileLoadingState());
    try {
      log('🔵 [ProfileCubit] Loading all requests for mentee: $menteeId');

      // Load all requests
      allRequests = await matchesRepo.getMyRequestsByStatus(
        menteeId: menteeId,
        status: null, // Get all
      );

      // Apply current filter
      changeStatus(selectedStatusIndex);

      log('[ProfileCubit] Loaded ${allRequests.length} total requests');
    } catch (e) {
      log(' [ProfileCubit] Error: $e');
      emit(ProfileErrorState('Failed to load requests'));
      emit(ProfileLoadedState());
    }
  }

  // ⭐ Get count for each status
  int getStatusCount(int index) {
    if (index == 0) return allRequests.length; // All

    String status = currentRequestFilter[index].toLowerCase();
    return allRequests.where((r) => r['status'] == status).length;
  }

  @override
  Future<void> close() {
    messageController.dispose();
    return super.close();
  }
}
