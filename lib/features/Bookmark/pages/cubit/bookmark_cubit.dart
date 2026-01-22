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
  final List<String> bookmarkTabs = ['Mentors', 'Resources'];
  int selectedTabIndex = 0;

  bool isBookmarked = false;
  bool showBookmark = true;
  List<Map<String, dynamic>> bookmarkedMentors = [];
  List<Map<String, dynamic>> bookmarkedResources = [];
  Map<String, bool> mentorBookmarkStatus = {};
  Map<String, bool> resourceBookmarkStatus = {};
  void changeTab(int index) {
    emit(BookmarksLoadingState());
    selectedTabIndex = index;
    emit(BookmarksLoadedState());
  }

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

        log('Mentor bookmark removed');
        emit(MentorBookmarkRemovedState());
      } else {
        await bookmarksRepo.addMentorBookmark(
          menteeId: menteeId,
          mentorId: mentorId,
        );
        mentorBookmarkStatus[mentorId] = true;

        log('Mentor bookmark added');
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
      log(' Error toggling mentor bookmark: $e');
      emit(BookmarksErrorState(e.toString()));
    }
  }

  Future<void> loadBookmarkedMentors(String menteeId) async {
    emit(BookmarksLoadingState());
    try {
      bookmarkedMentors = await bookmarksRepo.getBookmarkedMentors(menteeId);
      for (var mentor in bookmarkedMentors) {
        mentorBookmarkStatus[mentor['mentor_id']] = true;
      }

      log('Loaded ${bookmarkedMentors.length} mentor bookmarks');
      emit(BookmarksLoadedState());
    } catch (e) {
      log(' Error loading mentor bookmarks: $e');
      emit(BookmarksErrorState('Failed to load bookmarks'));
    }
  }

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
      log('Error checking mentor bookmark: $e');
    }
  }


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

        log('Resource bookmark removed');
        emit(ResourceBookmarkRemovedState());
      } else {
        await bookmarksRepo.addResourceBookmark(
          userId: userId,
          resourceId: resourceId,
        );
        resourceBookmarkStatus[resourceId] = true;

        log('Resource bookmark added');
        emit(ResourceBookmarkAddedState());
      }

      emit(BookmarksLoadedState());
    } catch (e) {
      log('Error toggling resource bookmark: $e');
      emit(BookmarksErrorState("Something went wrong. Please try again later."));
    }
  }

  Future<void> loadBookmarkedResources(String userId) async {
    emit(BookmarksLoadingState());
    try {
      bookmarkedResources = await bookmarksRepo.getBookmarkedResources(userId);
      for (var resource in bookmarkedResources) {
        resourceBookmarkStatus[resource['resource_id']] = true;
      }

      log('Loaded ${bookmarkedResources.length} resource bookmarks');
      emit(BookmarksLoadedState());
    } catch (e) {
      log('Error loading resource bookmarks: $e');
      emit(BookmarksErrorState('Failed to load bookmarks'));
    }
  }

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
      log(' Error checking resource bookmark: $e');
    }
  }

  Future<void> loadAllBookmarks(String userId) async {
    emit(BookmarksLoadingState());
    try {
      await Future.wait([
        loadBookmarkedMentors(userId),
        loadBookmarkedResources(userId),
      ]);

      log('Loaded all bookmarks');
      emit(BookmarksLoadedState());
    } catch (e) {
      log(' Error loading bookmarks: $e');
      emit(BookmarksErrorState('Failed to load bookmarks'));
    }
  }
}
