

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mistakes/features/Onboarding/presentation/pages/onboarding_one.dart'
    show OnboardingOne;
import 'package:mistakes/features/Onboarding/presentation/pages/onboarding_two.dart';

import '../pages/onboarding_three.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  int currentIndex = 0;
  bool isLogin = true;


  final onboardingScreens = [
    OnboardingOne(),
    OnboardingTwo(),
    OnboardingThree(),
  ];
  void updateIndex({required int index}) {
    emit(OnboardingLoadingState());
    currentIndex = index;
    emit(OnboardingLoadedState());
  }

  void changeAuthMode({required bool isLogin}) {
    emit(OnboardingLoadingState());
    this.isLogin = isLogin;
    emit(OnboardingButtonChangedState());
  }


}
