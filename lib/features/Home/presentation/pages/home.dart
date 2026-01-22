import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/features/Authentication/data/model/user_model.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Bookmark/cubit/bookmark_cubit.dart';
import 'package:mistakes/features/Home/data/local/images/home_image.dart';
import 'package:mistakes/features/Home/presentation/cubit/home_cubit.dart';
import 'package:mistakes/features/Profile/presentation/cubit/mentor_cubit.dart';
import 'package:mistakes/features/Profile/presentation/cubit/profile_cubit.dart';
import 'package:mistakes/features/Rating&Reviews/pages/cubit/review_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../constants/utils/app_colors.dart';
import '../widgets/src/home_appbar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeAppbar(size: size),
          SizedBox(height: size.height * 0.025),
          // const AppDivider(),
          SizedBox(height: size.height * 0.02),
          HomeCarousel(size: size),
          10.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: const ApptextField(
              size: 21,
              title: 'What do you need?',
              prefixIcon: Icons.search,
              hintText: 'Example : Mentors, Years..',
            ),
          ),
          10.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InAppText(
                  text: 'Suggested Mentors',
                  color: AppColors.blue,
                  fontweight: FontWeight.w500,
                  size: 21,
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, Routename.allMentors),
                  child: const InAppText(text: 'View All', size: 16),
                ),
              ],
            ),
          ),
          10.verticalSpace,
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  5,
                  (index) => MentorList(
                    size: size,
                    mentorId: 'mentor$index',
                    mentorName: 'Mentor Name $index',
                    rating: '4.5',
                    expertise: 'Expertise $index',
                    yoe: 'YOE $index',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MentorList extends StatelessWidget {
  const MentorList({
    super.key,
    required this.size,
    required this.mentorId,
    required this.mentorName,
    this.rating,
    this.expertise,
    this.yoe,
    this.profileImage,
    this.onBookmarkTap,
  });

  final Size size;
  final String mentorId, mentorName;
  final String? rating, expertise, yoe, profileImage;
  final VoidCallback? onBookmarkTap;

  @override
  Widget build(BuildContext context) {
    final watchBookmarksCubit = context.watch<BookmarksCubit>();
    final readAuthCubit = context.read<AuthenticationCubit>();
    final readHomeCubit = context.read<HomeCubit>();

    return AppshadowContainer(
      onTap: () {
        final mentor = readHomeCubit.allUsers.firstWhere(
          (user) => user.id == mentorId,
          orElse: () => UserModel(),
        );
        context.read<ProfileCubit>().setSelectedMentor(mentor);
        // readHomeCubit.toggleLike(mentorId);
      },
      shadowcolour: AppColors.inactive.withAlpha(100),
      border: true,
      color: AppColors.white,
      borderColor: AppColors.background.withAlpha(100),
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.01,
      ),
      padding: EdgeInsets.all(size.width * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              profileImage != null
                  ? Padding(
                      padding: EdgeInsets.only(right: size.width * 0.02),
                      child: AppNetwokImage(
                        height: size.height * 0.068,
                        width: size.height * 0.068,
                        imageUrl: profileImage!,
                        isCircular: true,
                      ),
                    )
                  : AppshadowContainer(
                      child: Image.asset(
                        HomeImages.avatar,
                        height: size.height * 0.08,
                      ),
                    ),
              SizedBox(width: size.width * 0.009),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InAppText(
                    text: mentorName,
                    fontweight: FontWeight.w700,
                    size: 20,
                  ),
                  Row(
                    children: [
                      InAppText(
                        text: expertise ?? 'Graphic Designer',
                        size: 18,
                      ),
                      SizedBox(width: size.width * 0.018),
                      InAppText(text: "${yoe}yrs exp", size: 18),
                    ],
                  ),
                  SizedBox(height: size.width * 0.01),
                  AppButton(
                    onTap: () {
                      final mentor = readHomeCubit.allUsers.firstWhere(
                        (user) => user.id == mentorId,
                        orElse: () => UserModel(),
                      );
                      context.read<ProfileCubit>().setSelectedMentor(mentor);
                      context.read<ProfileCubit>().checkMatchStatus(
                        menteeId: readAuthCubit.user.id ?? "",
                        mentorId: mentorId,
                      );

                      context.read<ReviewCubit>().loadMentorReviews(mentorId);
                      context.read<ReviewCubit>().checkExistingReview(
                        mentorId: mentorId,
                        menteeId: readAuthCubit.user.id ?? "",
                      );
                      context.read<MentorCubit>().loadActiveMentees(mentorId);
                      final move = Navigator.pushNamed(
                        context,
                        Routename.mentorDetails,
                      );
                      Future.delayed(const Duration(seconds: 3), () {
                        move;
                      });
                    },
                    buttonColor: AppColors.background,
                    width: size.width * 0.6,
                    height: size.height * 0.05,
                    label: "View Profile",
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              // readHomeCubit.toggleLike(mentorId);
              final userId = context.read<AuthenticationCubit>().user.id;
              if (userId != null) {
                context.read<BookmarksCubit>().toggleMentorBookmark(
                  context: context,
                  menteeId: userId,
                  mentorId: mentorId,
                );
              }
            },
            child: Icon(
              watchBookmarksCubit.mentorBookmarkStatus[mentorId] == true
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: watchBookmarksCubit.mentorBookmarkStatus[mentorId] == true
                  ? AppColors.errorColor
                  : AppColors.grey,
              size: 25.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return AppshadowContainer(
      color: Colors.transparent,
      radius: 1000.r,
      shadowcolour: AppColors.lightgrey.withAlpha(50),
      child: Divider(
        color: AppColors.grey.withAlpha(100),
        thickness: 2.0,
        height: 6.0,
      ),
    );
  }
}
