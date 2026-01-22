part of 'bookmark_cubit.dart';



abstract class BookmarksState extends Equatable {
  const BookmarksState();

  @override
  List<Object> get props => [];
}

class BookmarksInitial extends BookmarksState {}

class BookmarksLoadingState extends BookmarksState {}

class BookmarksLoadedState extends BookmarksState {}

class MentorBookmarkAddedState extends BookmarksState {}

class MentorBookmarkRemovedState extends BookmarksState {}

class ResourceBookmarkAddedState extends BookmarksState {}

class ResourceBookmarkRemovedState extends BookmarksState {}

class BookmarksErrorState extends BookmarksState {
  final String error;

  const BookmarksErrorState(this.error);

  @override
  List<Object> get props => [error];
}