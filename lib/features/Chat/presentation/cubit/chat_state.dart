part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

final class ChatLoadingState extends ChatState {}

final class ChatLoadedState extends ChatState {}

final class ChatNavigateState extends ChatState {}

final class ChatErrorState extends ChatState {
  const ChatErrorState({required this.error});
  final String error;

  @override
  List<Object> get props => [error];
}