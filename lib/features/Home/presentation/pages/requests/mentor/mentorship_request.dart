import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mistakes/config/detail/route_name.dart';
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
    _loadRequests();
  }

  Future<void> _loadRequests() async {
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
                // Show success/error messages
                if (state is MentorRequestAcceptedState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Request accepted successfully!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                } else if (state is MentorRequestDeclinedState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Request declined'),
                      backgroundColor: AppColors.errorColor,
                    ),
                  );
                } else if (state is MentorErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: AppColors.errorColor,
                    ),
                  );
                }
              },
              builder: (context, state) {
                final cubit = context.read<MentorCubit>();

                // Loading state
                if (state is MentorLoadingState &&
                    cubit.incomingRequests.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.filledColor,
                    ),
                  );
                }

                // Empty state
                if (cubit.incomingRequests.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          size: 80,
                          color: AppColors.grey.withOpacity(0.5),
                        ),
                        SizedBox(height: 16),
                        InAppText(
                          text: 'No Pending Requests',
                          size: 20,
                          fontweight: FontWeight.w600,
                          color: AppColors.grey,
                        ),
                        SizedBox(height: 8),
                        InAppText(
                          text: 'You don\'t have any mentorship requests yet',
                          size: 14,
                          color: AppColors.grey,
                        ),
                      ],
                    ),
                  );
                }

                // List of requests
                return RefreshIndicator(
                  onRefresh: _loadRequests,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                      ),
                      child: Column(
                        children: [
                          // Display count
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: size.height * 0.02,
                            ),
                            child: Row(
                              children: [
                                InAppText(
                                  text:
                                      '${cubit.incomingRequests.length} Pending ${cubit.incomingRequests.length == 1 ? 'Request' : 'Requests'}',
                                  size: 16,
                                  fontweight: FontWeight.w600,
                                  color: AppColors.grey,
                                ),
                              ],
                            ),
                          ),

                          // Request cards
                          ...cubit.incomingRequests.map((request) {
                            return _buildRequestCard(request, size);
                          }).toList(),
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

  // ============================================================================
  // BUILD REQUEST CARD
  // ============================================================================
  Widget _buildRequestCard(Map<String, dynamic> request, Size size) {
    final mentee = request['mentee'] as Map<String, dynamic>;
    final message = request['message'] as String?;
    final goals = request['goals'] as List<dynamic>?;
    final createdAt = DateTime.parse(request['created_at'] as String);
    final matchId = request['match_id'] as String;

    // Get mentee info
    final menteeName = mentee['full_name'] ?? mentee['username'] ?? 'Unknown';
    final menteeExpertise = mentee['expertise'] ?? 'No expertise listed';
    final menteeAvatar = mentee['profile_photo_url'];

    // Check if request is less than 24 hours old
    final isNew = DateTime.now().difference(createdAt).inHours < 24;

    // Get initials for avatar
    final initials = _getInitials(menteeName);

    return AppshadowContainer(
      onTap: () {
        // Navigate to details page with the request data
        Navigator.pushNamed(
          context,
          Routename.requestDetails,
          arguments: request, // Pass the request data
        );
      },
      margin: EdgeInsets.only(bottom: size.height * 0.02),
      padding: EdgeInsets.all(size.width * 0.04),
      shadowcolour: AppColors.blue.withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Avatar, Info, and Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar (with network image or gradient fallback)
              _buildAvatar(menteeAvatar, initials, size),

              SizedBox(width: size.width * 0.03),

              // Name and Info
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
                                  AppColors.orange.withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.orange.withOpacity(0.2),
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
                                  size: 16,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4),
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
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.work_outline,
                          size: 16,
                          color: AppColors.filledColor,
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: InAppText(
                            text: menteeExpertise,
                            size: 15,
                            fontweight: FontWeight.w500,
                            color: AppColors.filledColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: AppColors.grey,
                        ),
                        SizedBox(width: 5),
                        InAppText(
                          text: 'Requested ${_formatDate(createdAt)}',
                          size: 14,
                          color: AppColors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Show goals if available
          if (goals != null && goals.isNotEmpty) ...[
            SizedBox(height: size.height * 0.015),
            Container(height: 1, color: AppColors.inactive),
            SizedBox(height: size.height * 0.015),

            Row(
              children: [
                Icon(Icons.flag_outlined, size: 18, color: AppColors.blue),
                SizedBox(width: 8),
                InAppText(
                  text: 'Goals:',
                  size: 15,
                  fontweight: FontWeight.w600,
                  color: AppColors.blue,
                ),
              ],
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: goals.take(3).map((goal) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03,
                    vertical: size.height * 0.008,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InAppText(
                    text: goal.toString(),
                    size: 13,
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
                  size: 13,
                  color: AppColors.grey,
                ),
              ),
          ],

          // Message
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
                    color: AppColors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.format_quote,
                    size: 18,
                    color: AppColors.blue,
                  ),
                ),
                SizedBox(width: size.width * 0.03),
                Expanded(
                  child: InAppText(
                    text: message,
                    size: 15,
                    color: AppColors.lightblack,
                    maxline: 3,
                  ),
                ),
              ],
            ),
          ],

          // Action buttons
          SizedBox(height: size.height * 0.02),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  buttonColor: AppColors.success,
                  onTap: () => _acceptRequest(matchId),
                  label: "Accept",
                  textSize: 16,
                ),
              ),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: AppButton(
                  border: true,
                  bordercolor: AppColors.errorColor,
                  buttonColor: AppColors.white,
                  onTap: () => _declineRequest(matchId),
                  label: "Decline",
                  labelColor: AppColors.errorColor,
                  textSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // BUILD AVATAR
  // ============================================================================
  Widget _buildAvatar(String? avatarUrl, String initials, Size size) {
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return Container(
        width: size.height * 0.08,
        height: size.height * 0.08,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.blue.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.blue.withOpacity(0.2),
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
              return _buildGradientAvatar(initials, size);
            },
          ),
        ),
      );
    }

    return _buildGradientAvatar(initials, size);
  }

  Widget _buildGradientAvatar(String initials, Size size) {
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
            color: AppColors.blue.withOpacity(0.2),
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
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // ACCEPT REQUEST
  // ============================================================================
  Future<void> _acceptRequest(String matchId) async {
    // Show confirmation dialog
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
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            child: Text('Accept'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final mentorCubit = context.read<MentorCubit>();
      final userId = context.read<HomeCubit>().user.id;

      if (userId != null) {
        await mentorCubit.acceptRequest(matchId, userId);
      }
    }
  }

  // ============================================================================
  // DECLINE REQUEST
  // ============================================================================
  Future<void> _declineRequest(String matchId) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Decline Request'),
        content: Text(
          'Are you sure you want to decline this mentorship request?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
            ),
            child: Text('Decline'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final mentorCubit = context.read<MentorCubit>();
      final userId = context.read<HomeCubit>().user.id;

      if (userId != null) {
        await mentorCubit.declineRequest(matchId, userId);
      }
    }
  }

  // ============================================================================
  // HELPER FUNCTIONS
  // ============================================================================
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0].substring(0, 2).toUpperCase();
    }
    return 'UN';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }
}
