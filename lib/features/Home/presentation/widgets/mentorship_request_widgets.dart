
  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/utils.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Chat/presentation/cubit/chat_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';


import '../../../../constants/utils/app_colors.dart';
import '../../../Profile/presentation/cubit/mentor_cubit.dart';
import '../cubit/home_cubit.dart';

Widget buildRequestCard(Map<String, dynamic> request, Size size, BuildContext context) {
    final mentee = request['mentee'] as Map<String, dynamic>;
    final message = request['message'] as String?;
    final goals = request['goals'] as List<dynamic>?;
    final createdAt = DateTime.parse(request['created_at'] as String);
    final createdAtString = request['created_at'] as String;
    final matchId = request['match_id'] as String;

    final menteeName = mentee['full_name'] ?? mentee['username'] ?? 'Unknown';
    final menteeExpertise = mentee['expertise'] ?? 'No expertise listed';
    final menteeAvatar = mentee['profile_photo_url'];
    final isNew = DateTime.now().difference(createdAt).inHours < 24;
    final initials = context.read<ChatCubit>().getInitials(menteeName);

    return AppshadowContainer(
      onTap: () {
        context.read<MentorCubit>().setSelectedRequest(request);
        Navigator.pushNamed(context, Routename.requestDetails);
      },
      margin: EdgeInsets.only(bottom: size.height * 0.02),
      padding: EdgeInsets.all(size.width * 0.04),
      shadowcolour: AppColors.blue.withAlpha(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAvatar(menteeAvatar, initials, size),

              SizedBox(width: size.width * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InAppText(
                            text: menteeName,
                            size: 20,
                            fontweight: FontWeight.w700,
                            color: AppColors.blue,
                          ),
                        ),
                        // New Badge
                        if (isNew)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.03,
                              vertical: size.height * 0.006,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.orange),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.new_releases_outlined,
                                  size: 16.sp,
                                  color: AppColors.orange,
                                ),
                                SizedBox(width: size.width * 0.02),
                                InAppText(
                                  text: "New",
                                  color: AppColors.orange,
                                  fontweight: FontWeight.w600,
                                  size: 13,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.008),
                    Row(
                      children: [
                        Icon(
                          Icons.work_outline,
                          size: 16.sp,
                          color: AppColors.filledColor,
                        ),
                        SizedBox(width: size.width * 0.02),
                        Expanded(
                          child: InAppText(
                            text: menteeExpertise,
                            fontweight: FontWeight.w500,
                            color: AppColors.filledColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.002),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14.sp,
                          color: AppColors.grey,
                        ),
                        SizedBox(width: size.width * 0.02),
                        InAppText(
                          text:
                              'Requested ${Utils.getTimeAgo(createdAtString)}',
                          size: 15,
                          color: AppColors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (goals != null && goals.isNotEmpty) ...[
            SizedBox(height: size.height * 0.015),
            Container(height: size.height * 0.001, color: AppColors.inactive),
            SizedBox(height: size.height * 0.015),
            Row(
              children: [
                Icon(Icons.flag_outlined, size: 18.sp, color: AppColors.blue),
                SizedBox(width: size.width * 0.02),
                InAppText(
                  text: 'Goals:',

                  fontweight: FontWeight.w600,
                  color: AppColors.blue,
                ),
              ],
            ),
            SizedBox(height: size.height * 0.015),
            Wrap(
              spacing: size.width * 0.02,
              runSpacing: size.height * 0.015,
              children: goals.take(3).map((goal) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03,
                    vertical: size.height * 0.008,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withAlpha(10),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InAppText(
                    text: goal.toString(),
                    size: 16,
                    color: AppColors.blue,
                  ),
                );
              }).toList(),
            ),
            if (goals.length > 3)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: InAppText(
                  text: '+${goals.length - 3} more',
                  size: 16,
                  color: AppColors.grey,
                ),
              ),
          ],

          if (message != null && message.isNotEmpty) ...[
            SizedBox(height: size.height * 0.015),
            Container(height: 1, color: AppColors.inactive),
            SizedBox(height: size.height * 0.015),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withAlpha(10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.format_quote,
                    size: 18.sp,
                    color: AppColors.blue,
                  ),
                ),
                SizedBox(width: size.width * 0.03),
                Expanded(
                  child: InAppText(
                    text: message,
                    size: 16,
                    color: AppColors.lightblack,
                    maxline: 3,
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: size.height * 0.02),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  buttonColor: AppColors.success,
                  onTap: () => acceptRequest(matchId, context),
                  label: "Accept",
                ),
              ),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: AppButton(
                  border: true,
                  bordercolor: AppColors.errorColor,
                  buttonColor: AppColors.white,
                  onTap: () => declineRequest(matchId, context),
                  label: "Decline",
                  labelColor: AppColors.errorColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildAvatar(String? avatarUrl, String initials, Size size) {
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return Container(
        width: size.height * 0.08,
        height: size.height * 0.08,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.blue.withAlpha(30),
            width: size.width * 0.003,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.blue.withAlpha(20),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.network(
            avatarUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return buildGradientAvatar(initials, size);
            },
          ),
        ),
      );
    }

    return buildGradientAvatar(initials, size);
  }

  Widget buildGradientAvatar(String initials, Size size) {
    return Container(
      width: size.height * 0.08,
      height: size.height * 0.08,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.blue, AppColors.filledColor],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withAlpha(20),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Future<void> acceptRequest(String matchId, BuildContext context) async {
    final size = MediaQuery.sizeOf(context);
    final mentorCubit = context.read<MentorCubit>();
    final userId = context.read<HomeCubit>().user.id;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        title: InAppText(
          text: 'Accept Request',
          size: 20,
          fontweight: FontWeight.w600,
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InAppText(
              textAlign: TextAlign.center,
              text: 'Are you sure you want to accept this mentorship request?',
            ),
            SizedBox(height: size.height * 0.02),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: InAppText(text: 'Cancel'),
                  ),
                ),
                Expanded(
                  child: AppButton(
                    onTap: () {
                      context.read<MentorCubit>().acceptRequest(
                        matchId,
                        context.read<AuthenticationCubit>().user.id ?? "",
                      );
                      Navigator.pop(context, true);
                    },
                    textSize: 20,
                    buttonColor: AppColors.success,
                    label: 'Accept',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      if (userId != null) {
        await mentorCubit.acceptRequest(matchId, userId);
      }
    }
  }

  Future<void> declineRequest(String matchId, BuildContext context) async {
    final size = MediaQuery.sizeOf(context);
    final mentorCubit = context.read<MentorCubit>();
    final userId = context.read<HomeCubit>().user.id;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        title: InAppText(
          text: 'Decline Request',
          size: 20,
          fontweight: FontWeight.w600,
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InAppText(
              textAlign: TextAlign.center,
              text: 'Are you sure you want to decline this mentorship request?',
            ),
            SizedBox(height: size.height * 0.02),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: InAppText(text: 'Cancel'),
                  ),
                ),
                Expanded(
                  child: AppButton(
                    onTap: () => Navigator.pop(context, true),
                    textSize: 20,
                    buttonColor: AppColors.errorColor,
                    label: 'Decline',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      if (userId != null) {
        await mentorCubit.declineRequest(matchId, userId);
      }
    }
  }

