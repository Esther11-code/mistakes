import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mistakes/features/Bookmark/data/remote/bookmark_repo.dart';
import 'package:mistakes/global%20widgets/widgets/milestone.dart';

part 'bookmark_state.dart';

class BookmarksCubit extends Cubit<BookmarksState> {
  final BookmarkRepo bookmarksRepo;

  BookmarksCubit(this.bookmarksRepo) : super(BookmarksInitial());

  // ⭐ Tab management
  final List<String> bookmarkTabs = ['Mentors', 'Resources'];
  int selectedTabIndex = 0;

  bool isBookmarked = false;
  bool showBookmark = true;

  // ⭐ Data lists
  List<Map<String, dynamic>> bookmarkedMentors = [];
  List<Map<String, dynamic>> bookmarkedResources = [];

  // ⭐ Bookmark status tracking
  Map<String, bool> mentorBookmarkStatus = {}; // mentorId -> isBookmarked
  Map<String, bool> resourceBookmarkStatus = {}; // resourceId -> isBookmarked

  /// Change tab
  void changeTab(int index) {
    emit(BookmarksLoadingState());
    selectedTabIndex = index;
    emit(BookmarksLoadedState());
  }

  /// Get count for each tab
  int getTabCount(int index) {
    switch (index) {
      case 0:
        return bookmarkedMentors.length;
      case 1:
        return bookmarkedResources.length;
      default:
        return 0;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // MENTOR BOOKMARKS
  // ═══════════════════════════════════════════════════════════

  /// Toggle mentor bookmark
  Future<void> toggleMentorBookmark({
    required BuildContext context,
    required String menteeId,
    required String mentorId,
  }) async {
    emit(BookmarksLoadingState());
    try {
      final isCurrentlyBookmarked = mentorBookmarkStatus[mentorId] ?? false;

      if (isCurrentlyBookmarked) {
        await bookmarksRepo.removeMentorBookmark(
          menteeId: menteeId,
          mentorId: mentorId,
        );
        mentorBookmarkStatus[mentorId] = false;
        bookmarkedMentors.removeWhere((m) => m['mentor_id'] == mentorId);

        log('[BookmarksCubit] Mentor bookmark removed');
        emit(MentorBookmarkRemovedState());
      } else {
        await bookmarksRepo.addMentorBookmark(
          menteeId: menteeId,
          mentorId: mentorId,
        );
        mentorBookmarkStatus[mentorId] = true;

        log('[BookmarksCubit] Mentor bookmark added');
        if (context.mounted) {
  await checkAndShowAchievement(
    context,
    'first_bookmark_added',
    AchievementType.firstBookmark,
  );
}
        emit(MentorBookmarkAddedState());
      }

      emit(BookmarksLoadedState());
    } catch (e) {
      log(' [BookmarksCubit] Error toggling mentor bookmark: $e');
      emit(BookmarksErrorState(e.toString()));
      emit(BookmarksLoadedState());
    }
  }

  /// Load bookmarked mentors
  Future<void> loadBookmarkedMentors(String menteeId) async {
    emit(BookmarksLoadingState());
    try {
      bookmarkedMentors = await bookmarksRepo.getBookmarkedMentors(menteeId);

      // Update bookmark status map
      for (var mentor in bookmarkedMentors) {
        mentorBookmarkStatus[mentor['mentor_id']] = true;
      }

      log(
        '[BookmarksCubit] Loaded ${bookmarkedMentors.length} mentor bookmarks',
      );
      emit(BookmarksLoadedState());
    } catch (e) {
      log(' [BookmarksCubit] Error loading mentor bookmarks: $e');
      emit(BookmarksErrorState('Failed to load bookmarks'));
      emit(BookmarksLoadedState());
    }
  }

  /// Check if mentor is bookmarked
  Future<void> checkMentorBookmark({
    required String menteeId,
    required String mentorId,
  }) async {
    emit(BookmarksLoadingState());
    try {
      final isBookmarked = await bookmarksRepo.isMentorBookmarked(
        menteeId: menteeId,
        mentorId: mentorId,
      );
      mentorBookmarkStatus[mentorId] = isBookmarked;
      emit(BookmarksLoadedState());
    } catch (e) {
      log(' [BookmarksCubit] Error checking mentor bookmark: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════
  // RESOURCE BOOKMARKS
  // ═══════════════════════════════════════════════════════════

  /// Toggle resource bookmark
  Future<void> toggleResourceBookmark({
    required String userId,
    required String resourceId,
  }) async {
    emit(BookmarksLoadingState());
    try {
      final isCurrentlyBookmarked = resourceBookmarkStatus[resourceId] ?? false;

      if (isCurrentlyBookmarked) {
        await bookmarksRepo.removeResourceBookmark(
          userId: userId,
          resourceId: resourceId,
        );
        resourceBookmarkStatus[resourceId] = false;
        bookmarkedResources.removeWhere((r) => r['resource_id'] == resourceId);

        log('[BookmarksCubit] Resource bookmark removed');
        emit(ResourceBookmarkRemovedState());
      } else {
        await bookmarksRepo.addResourceBookmark(
          userId: userId,
          resourceId: resourceId,
        );
        resourceBookmarkStatus[resourceId] = true;

        log('[BookmarksCubit] Resource bookmark added');
        emit(ResourceBookmarkAddedState());
      }

      emit(BookmarksLoadedState());
    } catch (e) {
      log(' [BookmarksCubit] Error toggling resource bookmark: $e');
      emit(BookmarksErrorState(e.toString()));
      emit(BookmarksLoadedState());
    }
  }

  /// Load bookmarked resources
  Future<void> loadBookmarkedResources(String userId) async {
    emit(BookmarksLoadingState());
    try {
      bookmarkedResources = await bookmarksRepo.getBookmarkedResources(userId);

      // Update bookmark status map
      for (var resource in bookmarkedResources) {
        resourceBookmarkStatus[resource['resource_id']] = true;
      }

      log(
        '[BookmarksCubit] Loaded ${bookmarkedResources.length} resource bookmarks',
      );
      emit(BookmarksLoadedState());
    } catch (e) {
      log(' [BookmarksCubit] Error loading resource bookmarks: $e');
      emit(BookmarksErrorState('Failed to load bookmarks'));
      emit(BookmarksLoadedState());
    }
  }

  /// Check if resource is bookmarked
  Future<void> checkResourceBookmark({
    required String userId,
    required String resourceId,
  }) async {
    try {
      final isBookmarked = await bookmarksRepo.isResourceBookmarked(
        userId: userId,
        resourceId: resourceId,
      );
      resourceBookmarkStatus[resourceId] = isBookmarked;
      emit(BookmarksLoadedState());
    } catch (e) {
      log(' [BookmarksCubit] Error checking resource bookmark: $e');
    }
  }

  /// Load all bookmarks (mentors + resources)
  Future<void> loadAllBookmarks(String userId) async {
    emit(BookmarksLoadingState());
    try {
      await Future.wait([
        loadBookmarkedMentors(userId),
        loadBookmarkedResources(userId),
      ]);

      log('[BookmarksCubit] Loaded all bookmarks');
      emit(BookmarksLoadedState());
    } catch (e) {
      log(' [BookmarksCubit] Error loading bookmarks: $e');
      emit(BookmarksErrorState('Failed to load bookmarks'));
      emit(BookmarksLoadedState());
    }
  }
}
