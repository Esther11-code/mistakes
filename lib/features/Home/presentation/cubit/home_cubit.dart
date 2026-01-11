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

  // Current user (set from AuthenticationCubit)
  UserModel user = UserModel();

  // All users loaded from database
  List<UserModel> allUsers = [];
  List<UserModel> filteredUsers = [];
  
  // Available filters
  List<String> expertiseList = [];
  List<String> allSkills = [];
  
  // Current filters
  String? currentSearchQuery;
  String? currentRoleFilter;
  String? currentExpertiseFilter;

  // Bottom navigation
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
  List<String> likedMentorIds = [];

  void toggleLike(String mentorId) {
    emit(HomeLoadingState());
    if (likedMentorIds.contains(mentorId)) {
      likedMentorIds.remove(mentorId);
    } else {
      likedMentorIds.add(mentorId);
    }
    log('Toggled like for mentor: $mentorId');
    emit(HomeLikeToggledState());
    emit(HomeLoadedState());
  }

  bool isLiked(String mentorId) {
    return likedMentorIds.contains(mentorId);
  }

  // ============================================================================
  // LOAD ALL USERS
  // ============================================================================
  Future<void> loadUsers() async {
    emit(UserSearchLoadingState());
    try {
      allUsers = await homeRepo.getAllUsers();
      filteredUsers = allUsers;
      
      // Load filter options
      expertiseList = await homeRepo.getExpertiseList();
      allSkills = await homeRepo.getAllSkills();
      
      log('✅ Loaded ${allUsers.length} users');
      log('Mentors: ${getMentors().length}');
      log('Mentees: ${getMentees().length}');
      
      emit(UserSearchLoadedState(
        users: filteredUsers,
        searchQuery: '',
        roleFilter: null,
        expertiseFilter: null,
        minRating: null,
        minExperience: null,
      ));
    } catch (e) {
      log('❌ Error loading users: $e');
      emit(UserSearchErrorState(e.toString()));
    }
  }

  // ============================================================================
  // SEARCH AND FILTER
  // ============================================================================
  Future<void> searchAndFilter({
    String? query,
    String? role,
    String? expertise,
    double? rating,
    int? experience,
    bool reload = false,
  }) async {
    // Reload from database if requested or if empty
    if (reload || allUsers.isEmpty) {
      await loadUsers();
      if (state is UserSearchErrorState) return;
    }

    emit(UserSearchLoadingState());

    try {
      // Store current filters
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

   
      // Apply experience filter (mentors only)
      if (experience != null) {
        filtered = filtered.where((user) {
          return user.isMentor && 
                 user.yearsExperience != null && 
                 user.yearsExperience! >= experience;
        }).toList();
      }

      filteredUsers = filtered;

      log('🔍 Filtered to ${filtered.length} users');
      log('Query: "$query", Role: $role, Expertise: $expertise');

      emit(UserSearchLoadedState(
        users: filtered,
        searchQuery: query ?? '',
        roleFilter: role,
        expertiseFilter: expertise,
        minRating: rating,
        minExperience: experience,
      ));
    } catch (e) {
      log('❌ Error filtering users: $e');
      emit(UserSearchErrorState(e.toString()));
    }
  }

  // ============================================================================
  // LOAD MENTORS ONLY
  // ============================================================================
  Future<void> loadMentors() async {
    emit(UserSearchLoadingState());
    try {
      final mentors = await homeRepo.getMentors();
      filteredUsers = mentors;
      
      log('✅ Loaded ${mentors.length} mentors');
      
      emit(UserSearchLoadedState(
        users: mentors,
        searchQuery: '',
        roleFilter: 'mentor',
        expertiseFilter: null,
        minRating: null,
        minExperience: null,
      ));
    } catch (e) {
      log('❌ Error loading mentors: $e');
      emit(UserSearchErrorState(e.toString()));
    }
  }

  // ============================================================================
  // HELPER GETTERS
  // ============================================================================
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
    return allSkills; // Same as skills in your schema
  }

  // Clear filters
  void clearFilters() {
    currentSearchQuery = null;
    currentRoleFilter = null;
    currentExpertiseFilter = null;
    filteredUsers = allUsers;
    
    emit(UserSearchLoadedState(
      users: filteredUsers,
      searchQuery: '',
      roleFilter: null,
      expertiseFilter: null,
      minRating: null,
      minExperience: null,
    ));
  }

  void updateState() {
    emit(HomeLoadingState());
    emit(HomeLoadedState());
  }
}