import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
}
