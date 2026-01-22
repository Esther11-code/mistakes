import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Goal/pages/widgets/add_goal_widget.dart';
import 'package:mistakes/features/Profile/presentation/cubit/mentor_cubit.dart';
import 'package:mistakes/features/Rating&Reviews/pages/cubit/review_cubit.dart';
import 'package:mistakes/global widgets/export.dart';
import '../../../constants/utils/app_colors.dart';

class AddFeedback extends StatelessWidget {
  const AddFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final reviewCubit = context.watch<ReviewCubit>();

    return BlocListener<ReviewCubit, ReviewState>(
      listener: (context, state) {
     if (state is ReviewFeedbackSubmittedState) {
       Fluttertoast.showToast(msg: "Feedback submitted successfully!", gravity: ToastGravity.TOP, backgroundColor: AppColors.success);
       Navigator.pop(context);
     }
      },
      child: AppScaffold(
        body: Column(
          children: [
            AppbarWidget(
              title: 'Add Review',
              size: size,
              onTap: () => Navigator.pop(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Your experience',
                        style: GoogleFonts.sansita(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        children: const [
                          TextSpan(
                            text: '*',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    ApptextField(
                      controller: reviewCubit.reviewController,
                      maxLine: 5,
                      hintText: 'Share your experience with this mentor',
                    ),

                    SizedBox(height: size.height * 0.03),
                    InAppText(
                      text: "Rate mentor",
                      size: 20,
                      fontweight: FontWeight.w500,
                    ),
                    SizedBox(height: size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        5,
                        (index) => GestureDetector(
                          onTap: () {
                            reviewCubit.showColor(index: index + 1);
                          },
                          child: Icon(
                            index + 1 <= reviewCubit.selectedStarIndex
                                ? Icons.star
                                : Icons.star_border,
                            size: 40.sp,
                            color: index + 1 <= reviewCubit.selectedStarIndex
                                ? AppColors.yellow
                                : AppColors.grey.withAlpha(60),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.04),
                    InfoBar(
                      size: size,
                      icon: Icons.lightbulb_outline,
                      text:
                          "Be honest and specific. Mention communication, support, and how helpful the mentor was.",
                    ),

                    SizedBox(height: size.height * 0.04),
                    AppButton(
                      isLoading: reviewCubit.state is ReviewFeedbackLoading,
                      onTap: () {
                        log("hii");
                        context.read<ReviewCubit>().submitMentorReview(
                          mentorId:
                              context.read<ReviewCubit>().currentMentorId ?? "",
                          menteeId:
                              context.read<AuthenticationCubit>().user.id ?? "",
                          matchId:
                              context
                                  .read<MentorCubit>()
                                  .currentMentorMatchId ??
                              "",
                        );
                      },
                      width: size.width,
                      buttonColor: AppColors.filledColor,
                      label: 'Submit Review',
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
}
