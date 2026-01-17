import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/utils.dart';
import 'package:mistakes/features/Chat/presentation/cubit/chat_cubit.dart';
import 'package:mistakes/features/Home/presentation/cubit/home_cubit.dart';
import 'package:mistakes/features/Profile/presentation/cubit/mentor_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';
import '../../../../../../constants/utils/app_colors.dart';

class MentorshipRequest extends StatefulWidget {
  const MentorshipRequest({super.key});

  @override
  State<MentorshipRequest> createState() => _MentorshipRequestState();
}

class _MentorshipRequestState extends State<MentorshipRequest> {
  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future<void> loadRequests() async {
    final mentorCubit = context.read<MentorCubit>();
    final userId = context.read<HomeCubit>().user.id;

    if (userId != null) {
      await mentorCubit.loadIncomingRequests(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(title: 'Mentorship Requests', size: size),
          SizedBox(height: size.height * 0.02),

          Expanded(
            child: BlocConsumer<MentorCubit, MentorState>(
              listener: (context, state) {
                if (state is MentorRequestAcceptedState) {
                  Fluttertoast.showToast(
                    msg: 'Request accepted successfully!',
                    backgroundColor: AppColors.success,
                  );
                } else if (state is MentorRequestDeclinedState) {
                  Fluttertoast.showToast(
                    msg: 'Request declined successfully!',
                    backgroundColor: AppColors.errorColor,
                  );
                } else if (state is MentorErrorState) {
                  Fluttertoast.showToast(
                    msg: state.error,
                    backgroundColor: AppColors.errorColor,
                  );
                }
              },
              builder: (context, state) {
                final readMentorCubit = context.read<MentorCubit>();
                if (state is MentorLoadingState &&
                    readMentorCubit.incomingRequests.isEmpty) {
                  return Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: AppColors.background,
                      size: 50.sp,
                    ),
                  );
                }

                if (readMentorCubit.incomingRequests.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          size: 80.sp,
                          color: AppColors.blue.withAlpha(50),
                        ),
                        SizedBox(height: size.height * 0.02),
                        InAppText(
                          text: 'No Pending Requests',
                          size: 20,
                          fontweight: FontWeight.w600,
                          color: AppColors.blue,
                        ),
                        SizedBox(height: size.height * 0.01),
                        InAppText(
                          text: 'You don\'t have any mentorship requests yet',
                          size: 15,
                          color: AppColors.blue,
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: loadRequests,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: size.height * 0.02,
                            ),
                            child: Row(
                              children: [
                                InAppText(
                                  text:
                                      '${readMentorCubit.incomingRequests.length} Pending ${readMentorCubit.incomingRequests.length == 1 ? 'Request' : 'Requests'}',
                                  size: 16,
                                  fontweight: FontWeight.w600,
                                  color: AppColors.blue,
                                ),
                              ],
                            ),
                          ),

                          ...readMentorCubit.incomingRequests.map((request) {
                            return buildRequestCard(request, size);
                          }),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRequestCard(Map<String, dynamic> request, Size size) {
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
        Navigator.pushNamed(
          context,
          Routename.requestDetails,
        );
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
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.orange,
                                  AppColors.orange.withAlpha(70),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.orange.withAlpha(20),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.fiber_new,
                                  size: 16.sp,
                                  color: AppColors.white,
                                ),
                                SizedBox(width: size.width * 0.02),
                                InAppText(
                                  text: "New",
                                  color: AppColors.white,
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
                  onTap: () => acceptRequest(matchId),
                  label: "Accept",
                ),
              ),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: AppButton(
                  border: true,
                  bordercolor: AppColors.errorColor,
                  buttonColor: AppColors.white,
                  onTap: () => declineRequest(matchId),
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

  Future<void> acceptRequest(String matchId) async {
    final mentorCubit = context.read<MentorCubit>();
    final userId = context.read<HomeCubit>().user.id;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Accept Request'),
        content: Text(
          'Are you sure you want to accept this mentorship request?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          AppButton(
            onTap: () => Navigator.pop(context, true),
            buttonColor: AppColors.success,
            label: 'Accept',
            textSize: 20,
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (userId != null) {
        await mentorCubit.acceptRequest(matchId, userId);
      }
    }
  }

  Future<void> declineRequest(String matchId) async {
    final mentorCubit = context.read<MentorCubit>();
    final userId = context.read<HomeCubit>().user.id;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        title: Text('Decline Request'),
        content: Text(
          'Are you sure you want to decline this mentorship request?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          AppButton(
            onTap: () => Navigator.pop(context, true),
            textSize: 20,
            buttonColor: AppColors.errorColor,
            label: 'Decline',
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (userId != null) {
        await mentorCubit.declineRequest(matchId, userId);
      }
    }
  }
}
