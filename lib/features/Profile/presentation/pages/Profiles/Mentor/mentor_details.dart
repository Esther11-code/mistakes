import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Bookmark/cubit/bookmark_cubit.dart';
import 'package:mistakes/features/Chat/presentation/cubit/chat_cubit.dart';
import 'package:mistakes/features/Home/presentation/cubit/home_cubit.dart';
import 'package:mistakes/features/Home/presentation/pages/home.dart';
import 'package:mistakes/features/Profile/presentation/cubit/mentor_cubit.dart';
import 'package:mistakes/features/Profile/presentation/cubit/profile_cubit.dart';
import 'package:mistakes/features/Rating&Reviews/pages/cubit/review_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

class MentorDetails extends StatelessWidget {
  const MentorDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchProfileCubit = context.watch<ProfileCubit>();
    final mentor = watchProfileCubit.selectedMentor;
    final readReviewCubit = context.read<ReviewCubit>();
    final watchReviewCubit = context.watch<ReviewCubit>();
    final menteeId = context.read<AuthenticationCubit>().user.id ?? "";
    return BlocListener<BookmarksCubit, BookmarksState>(
      listener: (context, state) {
        if (state is MentorBookmarkAddedState) {
          Navigator.pushNamed(context, Routename.bookingSuccess);
        }
        if (state is MentorBookmarkRemovedState) {
          Fluttertoast.showToast(
            msg: "Mentor has been removed from Favorites",
            gravity: ToastGravity.TOP,
            backgroundColor: AppColors.orange,
          );
        }
      },
      child: AppScaffold(
        body: Column(
          children: [
            AppbarWidget(size: size, title: "Mentor Details"),
            SizedBox(height: size.height * 0.03),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(size.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppshadowContainer(
                        color: AppColors.white,
                        padding: EdgeInsets.all(size.width * 0.03),
                        shadowcolour: AppColors.lightgrey.withAlpha(100),
                        child: Column(
                          children: [
                            mentor?.profilePhotoUrl != null
                                ? AppNetwokImage(
                                    height: size.height * 0.15,
                                    width: size.height * 0.15,
                                    imageUrl: mentor?.profilePhotoUrl ?? "",
                                    isCircular: true,
                                  )
                                : CircleAvatar(
                                    backgroundColor: AppColors.filledColor,

                                    radius: size.height * 0.07,

                                    child: Icon(
                                      Icons.person,
                                      size: 50.sp,
                                      color: AppColors.white,
                                    ),
                                  ),
                            SizedBox(height: size.height * 0.02),
                            InAppText(
                              text: mentor?.name ?? "Mentor Name",
                              size: 20,
                              fontweight: FontWeight.bold,
                            ),
                            InAppText(
                              text: mentor?.expertise ?? "Mentor Expertise",
                              size: 16,
                            ),
                            SizedBox(height: size.height * 0.02),

                            AppshadowContainer(
                              alignment: Alignment.center,
                              color: AppColors.inactive,
                              border: true,
                              borderColor: AppColors.background,
                              width: size.width * 0.5,
                              padding: EdgeInsets.all(size.width * 0.02),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: AppColors.yellow,
                                    size: 20.sp,
                                  ),
                                  InAppText(
                                    text: "Expert",
                                    size: 16,
                                    color: AppColors.blue,
                                    fontweight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            AppDivider(),
                            SizedBox(height: size.height * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    InAppText(
                                      text: context
                                          .watch<MentorCubit>()
                                          .activeMentees
                                          .length
                                          .toString(),
                                      color: AppColors.blue,
                                      size: 18,
                                      fontweight: FontWeight.w600,
                                    ),
                                    InAppText(
                                      text:
                                          context
                                                  .watch<MentorCubit>()
                                                  .activeMentees
                                                  .length <=
                                              1
                                          ? "Mentee"
                                          : "Mentees",
                                      size: 16,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InAppText(
                                      text:
                                          "${mentor?.yearsExperience?.toString() ?? 0}yrs",
                                      color: AppColors.blue,
                                      size: 18,
                                      fontweight: FontWeight.w600,
                                    ),
                                    InAppText(text: "Experience", size: 16),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InAppText(
                                      text:
                                          "${watchReviewCubit.ratingStats['average_rating']}",
                                      color: AppColors.blue,
                                      size: 18,
                                      fontweight: FontWeight.w600,
                                    ),
                                    InAppText(
                                      text:
                                          watchReviewCubit
                                                  .ratingStats['average_rating'] !=
                                              null
                                          ? watchReviewCubit
                                                        .ratingStats['average_rating'] <=
                                                    1
                                                ? "Rating"
                                                : "Ratings"
                                          : "Rating",
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      InAppText(
                        text: "About Mentor",
                        size: 20,
                        fontweight: FontWeight.w600,
                      ),
                      SizedBox(height: size.height * 0.01),
                      AppshadowContainer(
                        color: AppColors.white,
                        padding: EdgeInsets.all(size.width * 0.03),
                        shadowcolour: AppColors.lightgrey.withAlpha(100),
                        child: InAppText(
                          textAlign: TextAlign.justify,
                          maxline: 10,
                          text:
                              mentor?.bio ??
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",

                          color: AppColors.blackColor,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      InAppText(
                        text: "Skills & Expertise",
                        size: 20,
                        fontweight: FontWeight.w600,
                      ),
                      SizedBox(height: size.height * 0.01),

                      Wrap(
                        alignment: WrapAlignment.start,
                        spacing: size.width * 0.02,
                        runSpacing: size.height * 0.02,
                        children: List.generate(
                          mentor?.interests?.length ?? 0,
                          (index) => IntrinsicWidth(
                            child: AppshadowContainer(
                              radius: size.height * 0.05,
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.04,
                                vertical: size.height * 0.01,
                              ),
                              border: true,
                              borderColor: AppColors.background,
                              color: AppColors.inactive,
                              child: InAppText(
                                text: mentor?.interests?[index] ?? "HTML",
                                color: AppColors.blue,
                                fontweight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, Routename.allReviews),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InAppText(
                              text: 'Reviews',
                              color: AppColors.blue,
                              fontweight: FontWeight.w500,
                              size: 21,
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                context,
                                Routename.allReviews,
                              ),
                              child: const InAppText(
                                text: 'View All',
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: size.height * 0.01),
                      watchReviewCubit.mentorReviews.isEmpty
                          ? Center(
                              child: InAppText(
                                text: "No Reviews yet",
                                size: 22,
                                fontweight: FontWeight.w500,
                                color: AppColors.blackColor,
                              ),
                            )
                          : Column(
                              children: List.generate(
                                watchReviewCubit.mentorReviews.length,
                                (index) => ReviewsContainer(
                                  size: size,
                                  index: index,
                                  username:
                                      watchReviewCubit
                                          .mentorReviews[index]
                                          .menteeName ??
                                      "",
                                  review: watchReviewCubit
                                      .mentorReviews[index]
                                      .reviewText,
                                  ratings: watchReviewCubit
                                      .mentorReviews[index]
                                      .rating
                                      .toString(),
                                ),
                              ),
                            ),
                      SizedBox(height: size.height * 0.02),
                      AppButton(
                        isLoading:
                            context.watch<BookmarksCubit>().state
                                is BookmarksLoadingState,
                        onTap: () {
                          final userId = context
                              .read<AuthenticationCubit>()
                              .user
                              .id;
                          final readBookmarkCubit = context
                              .read<BookmarksCubit>();
                          Future.delayed(const Duration(milliseconds: 500), () {
                            if (userId != null) {
                              readBookmarkCubit.toggleMentorBookmark(
                                context: context,
                                menteeId: userId,
                                mentorId: mentor?.id ?? "0",
                              );
                            }
                          });
                        },
                        border: true,
                        bordercolor: AppColors.blue,
                        buttonColor: AppColors.background,
                        width: size.width * 0.9,
                        height: size.height * 0.06,
                        textSize: 18,
                        label:
                            context
                                    .watch<BookmarksCubit>()
                                    .mentorBookmarkStatus[mentor?.id] ==
                                true
                            ? "Remove from Favorites"
                            : "Save to Favorites",
                        labelColor: AppColors.blue,
                      ),
                      SizedBox(height: size.height * 0.04),
                    ],
                  ),
                ),
              ),
            ),
            BlocBuilder<MentorCubit, MentorState>(
              builder: (context, state) {
                final mentorCubit = context.read<MentorCubit>();
                final isCurrentMentor =
                    mentorCubit.currentMentor?['mentor_id'] == mentor?.id;
                final readChatCubit = context.read<ChatCubit>();

                // If this is the user's current mentor
                if (isCurrentMentor) {
                  return Column(
                    children: [
                      // Message Mentor Button
                      AppButton(
                        onTap: () {
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
                        buttonColor: AppColors.blue,
                        width: size.width * 0.9,
                        height: size.height * 0.06,
                        textSize: 18,
                        label: "Message Mentor",
                      ),
                      SizedBox(height: size.height * 0.01),

                      // End Mentorship Button
                      AppButton(
                        onTap: () => _showEndMentorshipDialog(
                          context,
                          size,
                          mentorCubit,
                        ),
                        border: true,
                        bordercolor: AppColors.errorColor,
                        buttonColor: AppColors.white,
                        width: size.width * 0.9,
                        height: size.height * 0.06,
                        textSize: 18,
                        label: "End Mentorship",
                        labelColor: AppColors.errorColor,
                      ),
                    ],
                  );
                }

                // If user has a different active mentor
                if (mentorCubit.hasActiveMentor) {
                  return AppButton(
                    onTap: () {
                      Fluttertoast.showToast(
                        msg:
                            "You already have an active mentor. End your current mentorship first.",
                        gravity: ToastGravity.TOP,
                        backgroundColor: AppColors.orange,
                        toastLength: Toast.LENGTH_LONG,
                      );
                    },
                    buttonColor: AppColors.lightgrey,
                    width: size.width * 0.9,
                    height: size.height * 0.06,
                    textSize: 18,
                    label: "Already in Mentorship",
                  );
                }

                return AppButton(
                  onTap: watchProfileCubit.isRequestButtonDisabled
                      ? () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  size.width * 0.03,
                                ),
                              ),
                              contentPadding: EdgeInsets.all(size.width * 0.06),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 150.sp,
                                    color: AppColors.background,
                                  ),
                                  SizedBox(height: size.height * 0.02),
                                  InAppText(
                                    text:
                                        watchProfileCubit.dialogText ??
                                        'Request Sent',
                                    fontweight: FontWeight.w700,
                                    size: 22,
                                    color: AppColors.blue,
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  InAppText(
                                    text:
                                        watchProfileCubit.dialogSubText ??
                                        'Your mentorship request has been sent successfully',
                                    size: 15,
                                    textAlign: TextAlign.center,
                                    color: AppColors.grey,
                                    maxline: 2,
                                  ),
                                  SizedBox(height: size.height * 0.03),
                                  AppButton(
                                    onTap: () {
                                      final readProfileCubit = context
                                          .read<ProfileCubit>();

                                      Navigator.pop(context);
                                      readProfileCubit.loadAllMyRequests(
                                        menteeId,
                                      );
                                      Navigator.pushNamed(
                                        context,
                                        Routename.myRequests,
                                      );
                                    },
                                    width: size.width,
                                    buttonColor: AppColors.background,
                                    label: 'View My Requests',
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      : () {
                          Navigator.pushNamed(
                            context,
                            Routename.requestMentorship,
                          );
                        },
                  buttonColor: AppColors.blue,
                  width: size.width * 0.9,
                  height: size.height * 0.06,
                  textSize: 18,
                  label: watchProfileCubit.buttonText ?? "Request Mentor",
                );
              },
            ),

            SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
    );
  }

  void _showEndMentorshipDialog(
    BuildContext context,
    Size size,
    MentorCubit mentorCubit,
  ) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.all(size.width * 0.06),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 80.sp,
              color: AppColors.orange,
            ),
            SizedBox(height: size.height * 0.02),
            InAppText(
              text: 'End Mentorship',
              fontweight: FontWeight.w700,
              size: 22,
              color: AppColors.blue,
            ),
            SizedBox(height: size.height * 0.01),
            InAppText(
              text:
                  'Are you sure you want to end your mentorship with ${mentorCubit.currentMentorName}?',
              textAlign: TextAlign.center,
              color: AppColors.grey,
              maxline: 3,
            ),
            SizedBox(height: size.height * 0.02),

            // Reason TextField
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Optional: Tell us why (helps us improve)',
                hintStyle: TextStyle(color: AppColors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.inactive),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.inactive),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.blue),
                ),
              ),
            ),

            SizedBox(height: size.height * 0.03),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onTap: () => Navigator.pop(context),
                    label: 'Cancel',
                    buttonColor: AppColors.grey.withAlpha(30),
                    labelColor: AppColors.blackColor,
                    textSize: 17,
                  ),
                ),
                SizedBox(width: size.width * 0.03),
                Expanded(
                  child: BlocBuilder<MentorCubit, MentorState>(
                    builder: (context, state) {
                      return AppButton(
                        isLoading: state is MentorLoadingState,
                        onTap: () async {
                          final matchId =
                              mentorCubit.currentMentor?['match_id'];
                          if (matchId != null) {
                            await context.read<MentorCubit>().endMentorship(
                              matchId,
                              reasonController.text.trim(),
                            );

                            if (context.mounted) {
                              Navigator.pop(context); // Close dialog
                              Navigator.pop(context); // Go back to home

                              Fluttertoast.showToast(
                                msg: "Mentorship ended successfully",
                                gravity: ToastGravity.TOP,
                                backgroundColor: AppColors.filledColor,
                              );
                            }
                          }
                        },
                        label: 'End',
                        buttonColor: AppColors.errorColor,
                        textSize: 17,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewsContainer extends StatelessWidget {
  const ReviewsContainer({
    super.key,
    required this.size,
    required this.index,
    required this.username,
    required this.ratings,
    required this.review,
  });

  final Size size;
  final int index;
  final String username, ratings, review;

  @override
  Widget build(BuildContext context) {
    final watchReviewCubit = context.watch<ReviewCubit>();
    return AppshadowContainer(
      color: AppColors.white,
      padding: EdgeInsets.all(size.width * 0.03),
      margin: EdgeInsets.only(bottom: size.height * 0.02),
      shadowcolour: AppColors.lightgrey.withAlpha(100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: size.height * 0.025,
                backgroundColor: AppColors.filledColor,
                child: Icon(Icons.person, size: 20.sp, color: AppColors.white),
              ),
              SizedBox(width: size.width * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InAppText(
                    text: username,
                    size: 16,
                    color: AppColors.blue,
                    fontweight: FontWeight.w600,
                  ),
                  InAppText(
                    text: "2 days ago",
                    size: 14,
                    color: AppColors.blue.withAlpha(100),
                  ),
                ],
              ),
              Spacer(),
              Icon(Icons.star, size: 20.sp, color: AppColors.yellow),
              InAppText(
                text: ratings,
                size: 16,
                color: AppColors.blue,
                fontweight: FontWeight.w600,
              ),
            ],
          ),
          SizedBox(height: size.height * 0.01),

          SizedBox(height: size.height * 0.01),
          AppDivider(),
          SizedBox(height: size.height * 0.01),
          InAppText(text: review, color: AppColors.blackColor),
          SizedBox(height: size.height * 0.01),
        ],
      ),
    );
  }
}
