import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mistakes/features/Notification/data/remote/notification_repo.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationRepo notificationRepo;

  NotificationCubit(this.notificationRepo) : super(NotificationInitial());

  List<Map<String, dynamic>> notifications = [];
  Future<void> loadNotifications(String userId) async {
    emit(NotificationLoadingState());
    try {
      notifications = await notificationRepo.getNotifications(userId);
      log('Loaded ${notifications.length} notifications');
      emit(NotificationLoadedState());
    } catch (e) {
      log('Error loading notifications: $e');
      emit(NotificationErrorState(e.toString()));
    }
  }
  int get unreadCount =>
      notifications.where((n) => n['is_read'] == false).length;
  Future<void> refreshNotifications(String userId) async {
    try {
      notifications = await notificationRepo.getNotifications(userId);
      log('Refreshed ${notifications.length} notifications');
      emit(NotificationLoadedState());
    } catch (e) {
      log('Error refreshing notifications: $e');
      emit(NotificationErrorState("Failed to refresh notifications"));
    }
  }
}
