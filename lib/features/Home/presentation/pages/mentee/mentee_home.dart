import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Bookmark/cubit/bookmark_cubit.dart';
import 'package:mistakes/features/Chat/presentation/cubit/chat_cubit.dart';
import 'package:mistakes/features/Home/presentation/cubit/home_cubit.dart';
import 'package:mistakes/features/Home/presentation/pages/home.dart';
import 'package:mistakes/features/Home/presentation/widgets/src/home_appbar.dart';
import 'package:mistakes/features/Profile/presentation/cubit/mentor_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';
import 'package:mistakes/global%20widgets/widgets/milestone.dart';

class MenteeHome extends StatefulWidget {
  const MenteeHome({super.key});

  @override
  State<MenteeHome> createState() => MenteeHomeState();
}

class MenteeHomeState extends State<MenteeHome> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load mentors when screen opens
    context.read<HomeCubit>().searchAndFilter(role: 'mentor', reload: true);
    final userId = context.read<AuthenticationCubit>().user.id;
    if (userId != null) {
      context.read<BookmarksCubit>().loadBookmarkedMentors(userId);
      context.read<MentorCubit>().loadMenteeMentor(userId);
      context.read<MentorCubit>().checkActiveMentor(userId);
    }
    checkPendingAchievements();
  }

  Future<void> checkPendingAchievements() async {
    final userId = context.read<AuthenticationCubit>().user.id;
    if (userId == null) return;

    // Check through MentorRepo (reuse it)
    final mentorRepo = context.read<MentorCubit>().mentorRepo;

    final achievement = await mentorRepo.checkPendingMentorshipAchievement(
      userId,
    );

    if (achievement != null && mounted) {
      // Show the celebration
      await checkAndShowAchievement(
        context,
        'first_mentorship_started',
        AchievementType.mentorshipStarted,
        welcomeMessage: achievement['welcome_message'],
        mentorName: achievement['mentor_name'],
        continueButtonText: 'Start Learning',
      );
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchHomeCubit = context.watch<HomeCubit>();
    final watchMentorCubit = context.watch<MentorCubit>();
    return AppScaffold(
      body: BlocListener<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is UserSearchErrorState) {
            Fluttertoast.showToast(msg: state.error);
            searchController.clear();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeAppbar(size: size),
            SizedBox(height: size.height * 0.025),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.02),
                    if (watchMentorCubit.hasMentor)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04,
                        ),
                        child: _buildActiveMentorCard(
                          context,
                          size,
                          watchMentorCubit,
                        ),
                      ),

                    Visibility(
                      visible: !watchMentorCubit.hasMentor,
                      child: HomeCarousel(size: size),
                    ),
                    SizedBox(height: size.height * 0.025),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          context.read<HomeCubit>().searchAndFilter(
                            query: value,
                            role: 'mentor',
                          );
                        },
                        decoration: InputDecoration(
                          labelText: 'What do you need?',
                          labelStyle: GoogleFonts.ptSans(
                            fontSize: 20.sp,
                            color: AppColors.blackColor,
                          ),
                          hintText: 'Example: Mentors, Years..',
                          hintStyle: GoogleFonts.ptSans(
                            fontSize: 15.sp,
                            color: AppColors.grey,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.blackColor,
                          ),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: AppColors.grey,
                                  ),
                                  onPressed: () {
                                    searchController.clear();
                                    context.read<HomeCubit>().searchAndFilter(
                                      query: '',
                                      role: 'mentor',
                                    );
                                    setState(() {});
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              size.width * 0.03,
                            ),
                            borderSide: BorderSide(color: AppColors.inactive),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              size.width * 0.03,
                            ),
                            borderSide: BorderSide(color: AppColors.inactive),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              size.width * 0.03,
                            ),
                            borderSide: BorderSide(
                              color: AppColors.blue,
                              width: size.width * 0.002,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.025),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlocBuilder<HomeCubit, HomeState>(
                            builder: (context, state) {
                              if (state is UserSearchLoadedState &&
                                  searchController.text.isNotEmpty) {
                                return InAppText(
                                  text:
                                      '${state.users.length} Mentor${state.users.length != 1 ? 's' : ''} Found',

                                  fontweight: FontWeight.w600,
                                  size: 20,
                                );
                              }
                              return InAppText(
                                text: 'Suggested Mentors',
                                fontweight: FontWeight.w600,
                                size: 20,
                              );
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              context.read<HomeCubit>().searchAndFilter(
                                role: 'mentor',
                                reload: true,
                              );

                              Navigator.pushNamed(
                                context,
                                Routename.allMentors,
                              );
                            },
                            child: const InAppText(text: 'View All', size: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        if (state is UserSearchLoadingState) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(size.height * 0.05),
                              child: LoadingAnimationWidget.dotsTriangle(
                                size: 70.sp,
                                color: AppColors.background,
                              ),
                            ),
                          );
                        }
                        if (state is UserSearchLoadedState) {
                          if (state.users.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(size.height * 0.05),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 70.sp,
                                      color: AppColors.grey.withAlpha(50),
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                    InAppText(
                                      text: "No mentors found",
                                      size: 20,
                                      fontweight: FontWeight.w600,
                                      color: AppColors.lightblack,
                                    ),
                                    InAppText(
                                      text: "Try a different search term",

                                      color: AppColors.lightblack,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          final displayMentors = state.users.take(5).toList();

                          return Column(
                            children: displayMentors.map((mentor) {
                              return MentorList(
                                onBookmarkTap: () {},
                                size: size,
                                mentorId: mentor.id ?? "0",
                                mentorName: mentor.name ?? "rey",
                                profileImage: mentor.profilePhotoUrl,
                                expertise: mentor.expertise ?? "Expertise",
                                yoe:
                                    "${mentor.yearsExperience?.toString() ?? 0}",
                              );
                            }).toList(),
                          );
                        }
                        return watchHomeCubit.getMentors().isEmpty
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.all(size.height * 0.05),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.no_accounts,
                                        size: 70.sp,
                                        color: AppColors.grey.withAlpha(50),
                                      ),
                                      SizedBox(height: size.height * 0.01),
                                      InAppText(
                                        text: "No mentors available",
                                        size: 20,
                                        fontweight: FontWeight.w600,
                                        color: AppColors.lightblack,
                                      ),
                                      InAppText(
                                        text: "Please try again later",

                                        color: AppColors.lightblack,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Column(
                                children: List.generate(
                                  watchHomeCubit.filteredUsers.length,
                                  (index) => MentorList(
                                    profileImage: watchHomeCubit
                                        .filteredUsers[index]
                                        .profilePhotoUrl,
                                    onBookmarkTap: () {
                                      final userId = context
                                          .read<AuthenticationCubit>()
                                          .user
                                          .id;
                                      if (userId != null) {
                                        context
                                            .read<BookmarksCubit>()
                                            .toggleMentorBookmark(
                                              context: context,
                                              menteeId: userId,
                                              mentorId:
                                                  watchHomeCubit
                                                      .filteredUsers[index]
                                                      .id ??
                                                  "0",
                                            );
                                      }
                                    },
                                    size: size,
                                    mentorId:
                                        watchHomeCubit
                                            .filteredUsers[index]
                                            .id ??
                                        'mentor$index',
                                    mentorName:
                                        watchHomeCubit
                                            .filteredUsers[index]
                                            .name ??
                                        'Mentor $index',

                                    expertise:
                                        watchHomeCubit
                                            .filteredUsers[index]
                                            .expertise ??
                                        'Expertise $index',
                                    yoe:
                                        "${watchHomeCubit.filteredUsers[index].yearsExperience?.toString() ?? 0}",
                                  ),
                                ),
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ⭐ NEW: Active Mentor Card Widget
  Widget _buildActiveMentorCard(
    BuildContext context,
    Size size,
    MentorCubit mentorCubit,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(size.width * 0.009),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.background, AppColors.filledColor],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.stars_rounded,
                color: Colors.white,
                size: 27.sp,
              ),
            ),
            SizedBox(width: size.width * 0.02),
            InAppText(
              text: "Your Mentor",
              size: 20,
              fontweight: FontWeight.w700,
              color: AppColors.blue,
            ),
          ],
        ),
        SizedBox(height: size.height * 0.01),

        AppshadowContainer(
          padding: EdgeInsets.all(size.width * 0.03),
          color: AppColors.white,
          shadowcolour: AppColors.lightgrey.withAlpha(100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        mentorCubit.currentMentorAvatar != null
                            ? AppNetwokImage(
                                height: size.height * 0.08,
                                width: size.height * 0.08,
                                imageUrl: mentorCubit.currentMentorAvatar!,
                                isCircular: true,
                              )
                            : CircleAvatar(
                                backgroundColor: AppColors.filledColor,
                                radius: size.height * 0.04,
                                child: Icon(
                                  Icons.person,
                                  size: 30.sp,
                                  color: AppColors.white,
                                ),
                              ),
                        SizedBox(width: size.width * 0.02),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InAppText(
                              text: mentorCubit.currentMentorName ?? 'Unknown',
                              size: 20,
                              fontweight: FontWeight.w700,
                              color: AppColors.blue,
                            ),
                            InAppText(
                              text: mentorCubit.currentMentorExpertise ?? '',

                              color: AppColors.lightblack,
                            ),
                            SizedBox(height: size.height * 0.005),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16.sp,
                                  color: AppColors.lightblack.withAlpha(100),
                                ),
                                SizedBox(width: size.width * 0.01),
                                InAppText(
                                  text: mentorCubit.mentorshipStartedAt != null
                                      ? 'Since ${DateFormat('MMM yyyy').format(mentorCubit.mentorshipStartedAt!)}'
                                      : '',
                                  size: 14,
                                  color: AppColors.lightblack.withAlpha(100),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      final readChatCubit = context.read<ChatCubit>();
                      final conversation = readChatCubit.conversations
                          .firstWhere(
                            (conversation) =>
                                conversation.otherUserId ==
                                mentorCubit.currentMentorId,
                          );
                      readChatCubit.startConversationWith(
                        otherUserId: conversation.otherUserId,
                        currentUserIsMentor: context
                            .read<AuthenticationCubit>()
                            .user
                            .isMentor,
                        user: context.read<AuthenticationCubit>().user,
                      );
                      Navigator.pushNamed(context, Routename.menteeChat);
                    },
                    child: Container(
                      padding: EdgeInsets.all(size.width * 0.025),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.background, AppColors.filledColor],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.message_rounded,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    size,
                    '${mentorCubit.totalGoalsWithMentor ?? 0}',
                    'Goals',
                    Icons.flag_outlined,
                  ),
                  _buildStatItem(
                    context,
                    size,
                    '${mentorCubit.completedGoalsWithMentor ?? 0}',
                    'Completed',
                    Icons.check_circle_outline,
                  ),
                  _buildStatItem(
                    context,
                    size,
                    '${mentorCubit.currentMentorYearsExperience ?? 0}',
                    'Years Exp',
                    Icons.work_outline,
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: size.height * 0.015),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    Size size,
    String value,
    String label,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, size: 20.sp, color: AppColors.filledColor),
        SizedBox(height: size.height * 0.005),
        InAppText(
          text: value,
          fontweight: FontWeight.w700,
          color: AppColors.blue,
        ),
        InAppText(text: label, size: 14, color: AppColors.grey),
      ],
    );
  }
}
