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
  
  int selectedStatusIndex = 1; // Default: "Needs Action"
  List<String> status = ['All', 'Needs Action', 'On Track'];
  
  int selectedMenteeIndex = 0;
  
  List<MenteeModel> allMentees = [];
  List<MenteeModel> filteredMentees = [];

  // Load mentees from database
  loadMentees() async {
    emit(DashboardLoadingState());
    try {
      allMentees = await dashboardRepo.getMentees(mentorId: user.id!);
      
      // Apply initial filter
      filterMentees();
      
      log('Mentees loaded: ${allMentees.length}');
      emit(DashboardLoadedState());
    } catch (e) {
      log('Error loading mentees: $e');
      emit(DashboardErrorState(error: e.toString()));
      emit(DashboardLoadedState());
    }
  }

  // Filter mentees based on selected status
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
    
    log('Filtered mentees: ${filteredMentees.length} (Status: ${status[selectedStatusIndex]})');
  }

  void changeStatus(int index) {
    emit(DashboardLoadingState());
    selectedStatusIndex = index;
    log('Selected Status: ${status[index]}');
    
    // Filter based on new status
    filterMentees();
    
    emit(DashboardStatusChanged());
    emit(DashboardLoadedState());
  }

  void setSelectedMenteeIndex(int index) {
    emit(DashboardLoadingState());
    selectedMenteeIndex = index;
    log('Selected Mentee Index: $selectedMenteeIndex');
    emit(DashboardMenteeChanged());
    emit(DashboardLoadedState());
  }

  // Get selected mentee
  MenteeModel? get selectedMentee {
    if (filteredMentees.isEmpty || selectedMenteeIndex >= filteredMentees.length) {
      return null;
    }
    return filteredMentees[selectedMenteeIndex];
  }

  void updateState() {
    emit(DashboardLoadingState());
    emit(DashboardLoadedState());
  }
}