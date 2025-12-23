import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mistakes/features/Bookmark/pages/bookmark_setup.dart';
import 'package:mistakes/features/Chat/presentation/pages/chat_setup.dart';
import 'package:mistakes/features/Dashboard/pages/dashboard_setup.dart';
import 'package:mistakes/features/Home/presentation/pages/home_setup.dart';
import 'package:mistakes/features/Profile/presentation/pages/profile.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  int bottonnavSelectedIndex = 0;

  final screens = [
    const HomeSetup(),
    const BookmarkSetup(),
    const DashboardSetup(),
    const ChatSetup(),
    const ProfileSetUp(),
  ];

  void changebottomnavindex({required int index}) {
    emit(HomeLoadingState());
    bottonnavSelectedIndex = index;
    emit(HomeLoadedState());
  }
}
