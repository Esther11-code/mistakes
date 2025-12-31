import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mistakes/features/Authentication/data/model/user_model.dart';
import 'package:mistakes/features/Bookmark/pages/bookmark_setup.dart';
import 'package:mistakes/features/Chat/presentation/pages/chat_setup.dart';
import 'package:mistakes/features/Dashboard/pages/dashboard_setup.dart';
import 'package:mistakes/features/Home/presentation/pages/home_setup.dart';
import 'package:mistakes/features/Profile/presentation/pages/profile.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  List<UserModel> allUsers = [];
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

    List<String> likedMentorIds = [];

  void toggleLike(String mentorId) {
    emit(HomeLoadingState());
    if (likedMentorIds.contains(mentorId)) {
      likedMentorIds.remove(mentorId);
    } else {
      likedMentorIds.add(mentorId);
    }
    emit(HomeLikeToggledState());
  }

  bool isLiked(String mentorId) {
    return likedMentorIds.contains(mentorId);
  }

    Future<void> searchAndFilter({
    String? query,
    String? role,
    String? expertise,
    double? rating,
    int? experience,
    bool reload = false,
  }) async {
    // Load data if needed
    if (reload || allUsers.isEmpty) {
      emit(UserSearchLoadingState());

      try {
        await Future.delayed(Duration(seconds: 1));
        
        // TODO: Replace with actual API call
        // allUsers = await repository.getUsers();
        
        allUsers = [
          ...UserModel.sampleMentors,
          ...UserModel.sampleMentees,
        ];
      } catch (e) {
        emit(UserSearchErrorState(e.toString()));
        return;
      }
    }

    // Filter the data
    final searchQuery = (query ?? '').toLowerCase();
    
    List<UserModel> filtered = allUsers.where((user) {
      // Role filter
      bool matchesRole = role == null ||
          role == 'All' ||
          user.role!.toLowerCase() == role.toLowerCase();

      // Search filter
      bool matchesSearch = searchQuery.isEmpty ||
          user.name!.toLowerCase().contains(searchQuery) ||
          user.email!.toLowerCase().contains(searchQuery) ||
          user.expertise!.toLowerCase().contains(searchQuery) ||
          user.skills!.any((skill) => skill.toLowerCase().contains(searchQuery)) ||
          user.interests!.any((interest) => interest.toLowerCase().contains(searchQuery));

      // Expertise filter
      bool matchesExpertise = expertise == null ||
          expertise == 'All' ||
          user.expertise == expertise;

      // Rating filter (for mentors only)
      bool matchesRating = rating == null ||
          (user.isMentor && user.rating != null && user.rating! >= rating);

      // Experience filter (for mentors only)
      bool matchesExperience = experience == null ||
          (user.isMentor && user.yearsOfExperience != null && user.yearsOfExperience! >= experience);

      return matchesRole && matchesSearch && matchesExpertise && matchesRating && matchesExperience;
    }).toList();

    emit(UserSearchLoadedState(
      users: filtered,
      searchQuery: searchQuery,
      roleFilter: role,
      expertiseFilter: expertise,
      minRating: rating,
      minExperience: experience,
    ));
  }

  // Helper getters
  List<String> getExpertiseList() {
    return allUsers.map((u) => u.expertise!).toSet().toList();
  }

  List<String> getAllSkills() {
    return allUsers.expand((u) => u.skills!).toSet().toList();
  }

  List<String> getAllInterests() {
    return allUsers.expand((u) => u.interests!).toSet().toList();
  }

  List<UserModel> getMentors() {
    return allUsers.where((u) => u.isMentor).toList();
  }

  List<UserModel> getMentees() {
    return allUsers.where((u) => u.isMentee).toList();
  }

}

