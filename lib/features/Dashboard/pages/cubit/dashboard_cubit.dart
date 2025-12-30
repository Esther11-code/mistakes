import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

  int selectedStatusIndex = 1;
   List<String> status = ['All', 'Needs Action', 'On Track'];
   void changeStatus(int index) {
    emit(DashboardStatusChanged());
    selectedStatusIndex = index;
    log('Selected Status Index: $selectedStatusIndex');
    emit(DashboardLoadedState());
  }

  int selectedMenteeIndex = 0;
  void setSelectedMenteeIndex(int index) {
    emit(DashboardMenteeChanged());
    selectedMenteeIndex = index;
    log('Selected Mentee Index: $selectedMenteeIndex');
    emit(DashboardLoadedState());  
  }
}
