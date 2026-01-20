import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mistakes/global%20widgets/export.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../config/detail/route_name.dart';
import '../../../../constants/utils/app_colors.dart';
import '../cubit/notification_cubit.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      context.read<NotificationCubit>().loadNotifications(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AppScaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: AppbarWidget(
              size: size,
              title: 'Notifications',
              onTap: () {
                Navigator.popAndPushNamed(context, Routename.bottomNav);
              },
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              width: size.width,
              color: AppColors.white,
              child: BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationLoadingState) {
                    return Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                        color: AppColors.background,
                        size: 50.sp,
                      ),
                    );
                  }

                  if (state is NotificationErrorState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 60.sp,
                            color: AppColors.errorColor,
                          ),
                          SizedBox(height: size.height * 0.02),
                          InAppText(
                            text: 'Failed to load notifications',
                            color: AppColors.errorColor,
                            fontweight: FontWeight.w600,
                          ),
                          SizedBox(height: size.height * 0.01),
                          InAppText(
                            text: state.error,
                            color: AppColors.grey,
                            size: 14,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  final notifications = context
                      .read<NotificationCubit>()
                      .notifications;

                  if (notifications.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_none,
                            size: 80.sp,
                            color: AppColors.blue,
                          ),
                          SizedBox(height: size.height * 0.02),
                          InAppText(
                            text: 'No notifications yet',
                            color: AppColors.blue,
                            fontweight: FontWeight.w600,
                            size: 18,
                          ),
                          SizedBox(height: size.height * 0.01),
                          InAppText(
                            text: 'We\'ll notify you when something happens',
                            color: AppColors.blue,
                            size: 14,
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      final userId =
                          Supabase.instance.client.auth.currentUser?.id;
                      if (userId != null) {
                        await context
                            .read<NotificationCubit>()
                            .refreshNotifications(userId);
                      }
                    },
                    color: AppColors.filledColor,
                    child: ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return _buildNotificationItem(
                          size: size,
                          notification: notification,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required Size size,
    required Map<String, dynamic> notification,
  }) {
    final type = notification['type'] as String;
    final title = notification['title'] as String;
    final message = notification['message'] as String;
    final avatar = notification['avatar'] as String?;
    final timestamp = notification['timestamp'] as DateTime;

    return AppshadowContainer(
      shadowcolour: AppColors.lightgrey.withAlpha(50),
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.03,
        vertical: size.width * 0.04,
      ),
      margin: EdgeInsets.symmetric(vertical: size.width * 0.015),
      width: size.width,
      color: AppColors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.width * 0.15,
            height: size.width * 0.15,
            decoration: BoxDecoration(
              color: _getNotificationColor(type).withAlpha(20),
              shape: BoxShape.circle,
              image: avatar != null
                  ? DecorationImage(
                      image: NetworkImage(avatar),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: avatar == null
                ? Icon(
                    _getNotificationIcon(type),
                    color: _getNotificationColor(type),
                    size: 24.sp,
                  )
                : null,
          ),
          SizedBox(width: size.width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InAppText(
                        text: title,
                        color: AppColors.blue,
                        fontweight: FontWeight.w600,
                      ),
                    ),
                    InAppText(
                      text: timeago.format(timestamp),
                      size: 14,
                      fontweight: FontWeight.w500,
                      color: AppColors.lightblack,
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.005),
                InAppText(
                  text: message,
                  color: AppColors.blue,
                  size: 15,
                  maxline: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'new_request':
        return Icons.person_add;
      case 'new_message':
        return Icons.message;
      case 'goal_completed':
        return Icons.emoji_events;
      case 'match_accepted':
        return Icons.check_circle;
      case 'match_declined':
        return Icons.cancel;
      case 'goal_comment':
        return Icons.comment;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'new_request':
        return Colors.blue;
      case 'new_message':
        return Colors.purple;
      case 'goal_completed':
        return AppColors.filledColor;
      case 'match_accepted':
        return Colors.green;
      case 'match_declined':
        return AppColors.errorColor;
      case 'goal_comment':
        return Colors.orange;
      default:
        return AppColors.blue;
    }
  }
}
