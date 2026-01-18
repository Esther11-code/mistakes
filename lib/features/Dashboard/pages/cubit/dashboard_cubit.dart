// lib/features/Dashboard/pages/cubit/dashboard_cubit.dart
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mistakes/features/Authentication/data/model/user_model.dart';
import 'package:mistakes/features/Dashboard/data/local/model/mentor_model.dart';
import 'package:mistakes/features/Dashboard/data/local/remote/dash_repo.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardRepo dashboardRepo;

  DashboardCubit(this.dashboardRepo) : super(DashboardInitial());

  UserModel user = UserModel();

  int selectedStatusIndex = 1;
  List<String> status = ['All', 'Needs Action', 'On Track'];

  int selectedMenteeIndex = 0;
  List<MenteeModel> allMentees = [];
  List<MenteeModel> filteredMentees = [];

  // ⭐ Selected mentee with detailed data
  MenteeModel? selectedMentee;
  Map<String, dynamic> selectedMenteeDetails = {};
  List<Map<String, dynamic>> selectedMenteeRecentGoals = [];

  // ============================================================================
  // LOAD MENTEES
  // ============================================================================
  loadMentees({required UserModel user}) async {
    emit(DashboardLoadingState());
    try {
      allMentees = await dashboardRepo.getMentees(mentorId: user.id!);
      filterMentees();
      log('Mentees loaded: ${allMentees.length}');
      emit(DashboardLoadedState());
    } catch (e) {
      log('Error loading mentees: $e');
      emit(DashboardErrorState(error: e.toString()));
      emit(DashboardLoadedState());
    }
  }

  // ============================================================================
  // FILTER MENTEES
  // ============================================================================
  void filterMentees() {
    switch (selectedStatusIndex) {
      case 0: // All
        filteredMentees = allMentees;
        break;
      case 1: // Needs Action
        filteredMentees = allMentees.where((mentee) {
          return mentee.needsAction;
        }).toList();
        break;
      case 2: // On Track
        filteredMentees = allMentees.where((mentee) {
          return mentee.isOnTrack;
        }).toList();
        break;
      default:
        filteredMentees = allMentees;
    }
    log(
      'Filtered mentees: ${filteredMentees.length} (Status: ${status[selectedStatusIndex]})',
    );
  }

  // ============================================================================
  // CHANGE STATUS FILTER
  // ============================================================================
  void changeStatus(int index) {
    emit(DashboardLoadingState());
    selectedStatusIndex = index;
    log('Selected Status: ${status[index]}');
    filterMentees();
    emit(DashboardStatusChanged());
    emit(DashboardLoadedState());
  }

  // ============================================================================
  // SET SELECTED MENTEE BY INDEX
  // ============================================================================
  void setSelectedMenteeIndex(int index) {
    emit(DashboardLoadingState());
    selectedMenteeIndex = index;
    log('Selected Mentee Index: $selectedMenteeIndex');
    emit(DashboardMenteeChanged());
    emit(DashboardLoadedState());
  }

  // ============================================================================
  // ⭐ SET SELECTED MENTEE (Direct)
  // ============================================================================
  Future<void> setSelectedMentee(MenteeModel mentee) async {
    emit(DashboardLoadingState());
    try {
      selectedMentee = mentee;
      log('🔵 Loading detailed data for mentee: ${mentee.name}');

      // Load detailed data for this mentee
      await loadMenteeDetails(mentee.id, mentee.matchId);

      emit(DashboardMenteeChanged());
      emit(DashboardLoadedState());
    } catch (e) {
      log('❌ Error loading mentee details: $e');
      emit(DashboardErrorState(error: e.toString()));
      emit(DashboardLoadedState());
    }
  }

  // ============================================================================
  // ⭐ LOAD MENTEE DETAILS
  // ============================================================================
  Future<void> loadMenteeDetails(String menteeId, String matchId) async {
    try {
      // Get mentorship start date
      final matchData = await dashboardRepo.getMatchDetails(matchId);

      // Get recent goals (last 5)
      selectedMenteeRecentGoals = await dashboardRepo.getMenteeRecentGoals(
        menteeId: menteeId,
        limit: 5,
      );

      // Store additional details
      selectedMenteeDetails = {
        'match_id': matchId,
        'started_at': matchData['responded_at'] ?? matchData['created_at'],
        'recent_goals': selectedMenteeRecentGoals,
      };

      log('✅ Loaded details for mentee: $menteeId');
    } catch (e) {
      log('❌ Error loading mentee details: $e');
      rethrow;
    }
  }

  // ============================================================================
  // ⭐ DYNAMIC STATS GETTERS
  // ============================================================================

  // Calculate months together
  int get monthsTogether {
    if (selectedMenteeDetails['started_at'] == null) return 0;

    final startDate = DateTime.parse(selectedMenteeDetails['started_at']);
    final now = DateTime.now();

    final months =
        (now.year - startDate.year) * 12 + (now.month - startDate.month);

    return months;
  }

  // Get active goals count
  int get activeGoalsCount {
    return selectedMentee?.totalGoals ??
        0 - (selectedMentee?.goalsCompleted ?? 0);
  }

  // Get completed goals count
  int get completedGoalsCount {
    return selectedMentee?.goalsCompleted ?? 0;
  }

  // Get overall progress percentage
  int get overallProgressPercentage {
    return selectedMentee?.overallProgress ?? 0;
  }

  // Get stats list for GridView
  List<Map<String, dynamic>> get menteeStats {
    return [
      {'stat': '${selectedMentee?.totalGoals ?? 0}', 'title': 'Total Goals'},
      {'stat': '$completedGoalsCount', 'title': 'Completed'},
      {'stat': '$monthsTogether', 'title': 'Months Together'},
      {'stat': '$overallProgressPercentage%', 'title': 'Progress'},
    ];
  }

  // Get recent goals
  List<Map<String, dynamic>> get recentGoals {
    return selectedMenteeRecentGoals;
  }

  // ============================================================================
  // CLEAR SELECTED MENTEE
  // ============================================================================
  void clearSelectedMentee() {
    selectedMentee = null;
    selectedMenteeDetails = {};
    selectedMenteeRecentGoals = [];
    emit(DashboardLoadedState());
  }

  // ============================================================================
  // UPDATE STATE
  // ============================================================================
  void updateState() {
    emit(DashboardLoadingState());
    emit(DashboardLoadedState());
  }
}
