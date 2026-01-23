import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mistakes/features/Authentication/data/model/user_model.dart';
import 'package:mistakes/features/Bookmark/pages/bookmark_setup.dart';
import 'package:mistakes/features/Chat/presentation/pages/message_list.dart';
import 'package:mistakes/features/Dashboard/pages/dashboard_setup.dart';
import 'package:mistakes/features/Home/data/remote/home_repo.dart';

import 'package:mistakes/features/Home/presentation/pages/home_setup.dart';
import 'package:mistakes/features/Profile/presentation/pages/profile.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeRepo homeRepo;

  HomeCubit(this.homeRepo) : super(HomeInitial());

  UserModel user = UserModel();

  List<UserModel> allUsers = [];
  List<UserModel> filteredUsers = [];

  List<String> expertiseList = [];
  List<String> allSkills = [];

  String? currentSearchQuery;
  String? currentRoleFilter;
  String? currentExpertiseFilter;

  int bottonnavSelectedIndex = 0;

  final screens = [
    const HomeSetup(),
    const BookmarkSetup(),
    const DashboardSetup(),
    const MessageListPage(),
    const ProfileSetUp(),
  ];

  void changebottomnavindex({required int index}) {
    emit(HomeLoadingState());
    bottonnavSelectedIndex = index;
    emit(HomeLoadedState());
  }

  // Like/Bookmark functionality
  // List<String> likedMentorIds = [];

  // void toggleLike(String mentorId) {
  //   emit(HomeLoadingState());
  //   if (likedMentorIds.contains(mentorId)) {
  //     log('Removing like for mentor: $mentorId');
  //     likedMentorIds.remove(mentorId);
  //   } else {
  //     log('Adding like for mentor: $mentorId');
  //     likedMentorIds.add(mentorId);
  //   }
  //   log('Toggled like for mentor: $mentorId');
  //   emit(HomeLikeToggledState());
  //   emit(HomeLoadedState());
  // }

  // bool isLiked(String mentorId) {
  //   return likedMentorIds.contains(mentorId);
  // }

  Future<void> loadUsers() async {
    emit(UserSearchLoadingState());
    try {
      allUsers = await homeRepo.getAllUsers();
      filteredUsers = allUsers;

      expertiseList = await homeRepo.getExpertiseList();
      allSkills = await homeRepo.getAllSkills();

      log('Loaded ${allUsers.length} users');
      log('Mentors: ${getMentors().length}');
      log('Mentees: ${getMentees().length}');

      emit(
        UserSearchLoadedState(
          users: filteredUsers,
          searchQuery: '',
          roleFilter: null,
          expertiseFilter: null,
          minRating: null,
          minExperience: null,
        ),
      );
    } catch (e) {
      log(' Error loading users: $e');
      emit(UserSearchErrorState("Error loading Users"));
    }
  }

  Future<void> searchAndFilter({
    String? query,
    String? role,
    String? expertise,
    double? rating,
    int? experience,
    bool reload = false,
  }) async {
    if (reload || allUsers.isEmpty) {
      await loadUsers();
      if (state is UserSearchErrorState) return;
    }

    emit(UserSearchLoadingState());

    try {
      currentSearchQuery = query;
      currentRoleFilter = role;
      currentExpertiseFilter = expertise;

      // Start with all users
      List<UserModel> filtered = List.from(allUsers);

      // Apply search query
      if (query != null && query.isNotEmpty) {
        final searchQuery = query.toLowerCase();
        filtered = filtered.where((user) {
          return user.name!.toLowerCase().contains(searchQuery) ||
              (user.email?.toLowerCase().contains(searchQuery) ?? false) ||
              (user.bio?.toLowerCase().contains(searchQuery) ?? false) ||
              (user.expertise?.toLowerCase().contains(searchQuery) ?? false) ||
              (user.username?.toLowerCase().contains(searchQuery) ?? false) ||
              user.interests!.any((i) => i.toLowerCase().contains(searchQuery));
        }).toList();
      }

      // Apply role filter
      if (role != null && role != 'All') {
        filtered = filtered.where((user) {
          if (role.toLowerCase() == 'mentor') {
            return user.isMentor;
          } else if (role.toLowerCase() == 'mentee') {
            return user.isMentee;
          }
          return true;
        }).toList();
      }

      // Apply expertise filter
      if (expertise != null && expertise != 'All') {
        filtered = filtered.where((user) {
          return user.expertise == expertise;
        }).toList();
      }

      if (experience != null) {
        filtered = filtered.where((user) {
          return user.isMentor &&
              user.yearsExperience != null &&
              user.yearsExperience! >= experience;
        }).toList();
      }

      filteredUsers = filtered;

      log('Filtered to ${filtered.length} users');
      log('Query: "$query", Role: $role, Expertise: $expertise');

      emit(
        UserSearchLoadedState(
          users: filtered,
          searchQuery: query ?? '',
          roleFilter: role,
          expertiseFilter: expertise,
          minRating: rating,
          minExperience: experience,
        ),
      );
    } catch (e) {
      log(' Error filtering users: $e');
      emit(UserSearchErrorState(e.toString()));
    }
  }
  Future<void> loadMentors() async {
    emit(UserSearchLoadingState());
    try {
      final mentors = await homeRepo.getMentors();
      filteredUsers = mentors;

      log('Loaded ${mentors.length} mentors');

      searchAndFilter(role: 'mentor', reload: true);
      log('Filtered to ${filteredUsers.length} mentors');
      emit(
        UserSearchLoadedState(
          users: mentors,
          searchQuery: '',
          roleFilter: 'mentor',
          expertiseFilter: null,
          minRating: null,
          minExperience: null,
        ),
      );
    } catch (e) {
      log(' Error loading mentors: $e');
      emit(UserSearchErrorState(e.toString()));
    }
  }

  List<UserModel> getMentors() {
    return allUsers.where((u) => u.isMentor).toList();
  }

  List<UserModel> getMentees() {
    return allUsers.where((u) => u.isMentee).toList();
  }

  List<String> getExpertiseList() {
    return expertiseList;
  }

  List<String> getAllSkills() {
    return allSkills;
  }

  List<String> getAllInterests() {
    return allSkills; 
  }

  // Clear filters
  void clearFilters() {
    currentSearchQuery = null;
    currentRoleFilter = null;
    currentExpertiseFilter = null;
    filteredUsers = allUsers;

    emit(
      UserSearchLoadedState(
        users: filteredUsers,
        searchQuery: '',
        roleFilter: null,
        expertiseFilter: null,
        minRating: null,
        minExperience: null,
      ),
    );
  }

  void updateState() {
    emit(HomeLoadingState());
    emit(HomeLoadedState());
  }
}
