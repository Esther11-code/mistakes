import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Profile/presentation/cubit/mentor_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

class AcceptMentorship extends StatelessWidget {
  const AcceptMentorship({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final readMentorCubit = context.read<MentorCubit>();
    final watchMentorCubit = context.watch<MentorCubit>();
    return BlocListener<MentorCubit, MentorState>(
      listener: (context, state) {
        if (state is MentorRequestAcceptedState) {
          showAdaptiveDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              contentPadding: EdgeInsets.all(size.width * 0.04),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 60.sp,
                    color: AppColors.filledColor,
                  ),
                  SizedBox(height: size.height * 0.02),
                  InAppText(
                    text: 'Mentorship Started!',
                    fontweight: FontWeight.w700,
                    size: 22,
                    color: AppColors.blue,
                  ),
                  SizedBox(height: size.height * 0.01),
                  InAppText(
                    text:
                        '${watchMentorCubit.selectedMenteeName.split(' ').first} has been notified. You can now start your mentorship journey together!',
                    textAlign: TextAlign.center,
                    color: AppColors.lightblack,
                    maxline: 3,
                  ),
                  SizedBox(height: size.height * 0.03),
                  AppButton(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    width: size.width,
                    buttonColor: AppColors.filledColor,
                    label: 'Okay',
                  ),
                ],
              ),
            ),
          );
        }
      },
      child: AppScaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppbarWidget(
              title: 'Accept Mentee',
              size: size,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.04),
                    Container(
                      width: size.width * 0.4,
                      height: size.width * 0.4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.blue, AppColors.filledColor],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.handshake_rounded,
                          size: 70.sp,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.025),
                    InAppText(
                      text: "Start Mentorship",
                      size: 26,
                      fontweight: FontWeight.w700,
                      color: AppColors.blue,
                    ),

                    SizedBox(height: size.height * 0.015),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.05,
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.grey,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(text: "You're about to accept "),
                            TextSpan(
                              text: watchMentorCubit.selectedMenteeName,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.blue,
                              ),
                            ),
                            TextSpan(
                              text:
                                  " as your mentee. This will start a long-term mentorship relationship.",
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.04),
                    Container(
                      width: size.width,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(
                            Icons.message_outlined,
                            color: AppColors.blue,
                            size: 25.sp,
                          ),
                          SizedBox(width: size.width * 0.02),
                          InAppText(
                            text: "Welcome Message",
                            size: 20,
                            fontweight: FontWeight.w700,
                            color: AppColors.blue,
                          ),
                          SizedBox(width: size.width * 0.02),
                          AppshadowContainer(
                            color: AppColors.inactive,
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.03,
                              vertical: size.height * 0.009,
                            ),
                            child: InAppText(
                              text: "Optional",
                              size: 16,
                              color: AppColors.filledColor,
                              fontweight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: size.height * 0.015),

                    AppshadowContainer(
                      padding: EdgeInsets.zero,
                      color: AppColors.white,
                      child: ApptextField(
                        controller: watchMentorCubit.welcomeMessageController,
                        hintText: "Write a welcome message...",
                        maxLine: 5,
                      ),
                    ),

                    SizedBox(height: size.height * 0.025),
                    AppshadowContainer(
                      width: size.width,
                      padding: EdgeInsets.only(left: size.width * 0.02),
                      color: AppColors.filledColor,
                      child: AppshadowContainer(
                        width: size.width,
                        padding: EdgeInsets.all(size.width * 0.02),
                        color: AppColors.inactive,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              color: AppColors.blue,
                              size: 25.sp,
                            ),
                            SizedBox(width: size.width * 0.01),

                            Expanded(
                              child: InAppText(
                                text:
                                    "Set clear expectations early. Discuss meeting frequency, communication methods, and goal-setting in your first session.",

                                color: AppColors.lightblack,
                                maxline: 5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.04),
                    AppButton(
                      isLoading: watchMentorCubit.state
                          is MentorLoadingState,
                      onTap: () {
                        final readAuthCubit = context
                            .read<AuthenticationCubit>();
                        if (readAuthCubit.user.isMentor) {
                          Future.delayed(const Duration(milliseconds: 500), () {
                            readMentorCubit.acceptRequest(
                              readMentorCubit.selectedMatchId!,
                              readAuthCubit.user.id ?? "",
                            );
                          });
                        }
                      },
                      width: size.width,
                      buttonColor: AppColors.background,
                      label: 'Start Mentorship',
                      textSize: 17,
                    ),

                    SizedBox(height: size.height * 0.015),

                    AppButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      width: size.width,
                      bordercolor: AppColors.errorColor,
                      label: 'Cancel',
                      labelColor: AppColors.errorColor,
                      buttonColor: Colors.transparent,
                      textSize: 17,
                    ),

                    SizedBox(height: size.height * 0.03),
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
