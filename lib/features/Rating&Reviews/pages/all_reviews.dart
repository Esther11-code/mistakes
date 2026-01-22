import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/features/Profile/presentation/cubit/mentor_cubit.dart';
import 'package:mistakes/features/Profile/presentation/pages/Profiles/Mentor/mentor_details.dart';
import 'package:mistakes/features/Rating&Reviews/pages/cubit/review_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../constants/utils/app_colors.dart';
import '../../Home/presentation/widgets/home.dart';

class AllReviews extends StatelessWidget {
  const AllReviews({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchReviewCubit = context.watch<ReviewCubit>();
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppbarWidget(
            title: 'Reviews',
            size: size,
            onTap: () => Navigator.pop(context),
          ),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppshadowContainer(
                      color: AppColors.white,
                      padding: EdgeInsets.all(size.width * 0.03),
                      shadowcolour: AppColors.lightgrey.withAlpha(100),
                      child: Column(
                        children: [
                          InAppText(
                            text:
                                "${watchReviewCubit.ratingStats['average_rating']}",
                            size: 21,
                            fontweight: FontWeight.w800,
                          ),
                          SizedBox(height: size.height * 0.008),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              5,
                              (index) => Icon(
                                Icons.star,
                                color: AppColors.yellow,
                                size: 20.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.008),
                          InAppText(
                            text:
                                "Based on ${watchReviewCubit.mentorReviews.length} reviews",
                            size: 16,
                          ),
                          SizedBox(height: size.height * 0.02),
                          AppDivider(),

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
                                InAppText(
                                  text: "90% Positive Reviews",
                                  size: 16,
                                  color: AppColors.blue,
                                  fontweight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    InAppText(
                      text: "User Reviews",
                      size: 20,
                      color: AppColors.blue,
                      fontweight: FontWeight.w700,
                    ),
                    SizedBox(height: size.height * 0.02),
                    Column(
                      children: List.generate(
                        watchReviewCubit.mentorReviews.length,
                        (index) => ReviewsContainer(
                          size: size,
                          index: index,
                          review:
                              watchReviewCubit.mentorReviews[index].reviewText,
                          username:
                              watchReviewCubit
                                  .mentorReviews[index]
                                  .menteeName ??
                              "",
                          ratings: watchReviewCubit.mentorReviews[index].rating
                              .toString(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          context.watch<MentorCubit>().currentMentorId ==
                  watchReviewCubit.currentMentorId
              ? Padding(
                  padding: EdgeInsets.all(size.width * 0.03),
                  child: Column(
                    children: [
                      AppButton(
                        buttonColor: AppColors.blue,
                        label: "Add Review",
                        onTap: () {
                          Navigator.pushNamed(context, Routename.addFeedback);
                        },
                      ),
                      SizedBox(height: size.height * 0.04),
                    ],
                  ),
                )
              : SizedBox(height: size.height * 0.04),
        ],
      ),
    );
  }
}
