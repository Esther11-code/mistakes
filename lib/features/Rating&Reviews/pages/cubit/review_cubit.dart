import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit() : super(ReviewInitial());
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
}
