import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/constants/utils/utils.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Chat/presentation/cubit/chat_cubit.dart';
import 'package:mistakes/features/Profile/presentation/cubit/mentor_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

class RequestDetails extends StatelessWidget {
  const RequestDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocConsumer<MentorCubit, MentorState>(
      listener: (context, state) {
        if (state is MentorRequestAcceptedState) {
          Fluttertoast.showToast(
            msg: 'Request accepted successfully!',
            backgroundColor: AppColors.success,
          );
          Navigator.pop(context);
        } else if (state is MentorRequestDeclinedState) {
          Fluttertoast.showToast(
            msg: 'Request declined',
            backgroundColor: AppColors.errorColor,
          );
          Navigator.pop(context);
        } else if (state is MentorErrorState) {
          Fluttertoast.showToast(
            msg: state.error,
            backgroundColor: AppColors.errorColor,
          );
        }
      },
      builder: (context, state) {
        final readMentorCubit = context.read<MentorCubit>();
        final readChatCubit = context.read<ChatCubit>();
        final watchMentorCubit = context.watch<MentorCubit>();

        if (readMentorCubit.selectedRequest == null) {
          return AppScaffold(
            body: Column(
              children: [
                AppbarWidget(
                  title: 'Request Details',
                  size: size,
                  onTap: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64.sp,
                          color: AppColors.errorColor,
                        ),
                        SizedBox(height: size.height * 0.02),
                        InAppText(
                          text: 'No request selected',
                          color: AppColors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return AppScaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppbarWidget(
                title: 'Request Details',
                size: size,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: size.height * 0.02),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.02),
                      AppshadowContainer(
                        width: size.width,
                        padding: EdgeInsets.all(size.width * 0.05),
                        shadowcolour: AppColors.lightgrey.withAlpha(100),
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.pink.shade300,
                                    Colors.red.shade400,
                                  ],
                                ),
                                border: Border.all(
                                  color: AppColors.white,
                                  width: size.width * 0.008,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  readChatCubit.getInitials(
                                    readMentorCubit.selectedMenteeName,
                                  ),
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.015),
                            InAppText(
                              text: watchMentorCubit.selectedMenteeName,
                              size: 24,
                              fontweight: FontWeight.w700,
                              color: AppColors.blue,
                            ),
                            SizedBox(height: size.height * 0.005),
                            InAppText(
                              text: watchMentorCubit.selectedMenteeExpertise,
                              size: 16,
                              color: AppColors.blue.withAlpha(90),
                            ),
                            SizedBox(height: size.height * 0.01),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.04,
                                vertical: size.height * 0.008,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.blue.withAlpha(10),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 16.sp,
                                    color: AppColors.blue,
                                  ),
                                  SizedBox(width: 5),
                                  InAppText(
                                    text:
                                        "Requested ${Utils.getTimeAgo(watchMentorCubit.selectedCreatedAt?.toIso8601String())}",
                                    size: 14,
                                    color: AppColors.blue,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: size.height * 0.03),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.blue.withAlpha(10),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.person_outline,
                              color: AppColors.blue,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: size.width * 0.03),
                          InAppText(
                            text:
                                "About ${watchMentorCubit.selectedMenteeName.split(' ').first}",
                            size: 20,
                            fontweight: FontWeight.w700,
                            color: AppColors.blue,
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.015),
                      AppshadowContainer(
                        padding: EdgeInsets.all(size.width * 0.05),
                        shadowcolour: AppColors.grey.withAlpha(50),
                        color: AppColors.white,
                        child: InAppText(
                          maxline: 10,
                          text: readMentorCubit.selectedMenteeBio,
                          color: AppColors.lightblack,
                        ),
                      ),

                      SizedBox(height: size.height * 0.025),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.inactive,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.favorite_border,
                              color: AppColors.filledColor,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: size.width * 0.03),
                          InAppText(
                            text: "Reason for mentorship",
                            size: 20,
                            fontweight: FontWeight.w700,
                            color: AppColors.blue,
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.015),
                      Visibility(
                        visible:
                            watchMentorCubit.selectedMessage != null &&
                            watchMentorCubit.selectedMessage!.isNotEmpty,
                        child: AppshadowContainer(
                          padding: EdgeInsets.all(size.width * 0.05),
                          color: AppColors.inactive,
                          child: InAppText(
                            text: watchMentorCubit.selectedMessage ?? "",
                            color: AppColors.lightblack,
                          ),
                        ),
                      ),

                      SizedBox(height: size.height * 0.025),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.flag_outlined,
                              color: Colors.green.shade600,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: size.width * 0.03),
                          InAppText(
                            text: "Goal of Mentorship",
                            size: 20,
                            fontweight: FontWeight.w700,
                            color: AppColors.blue,
                          ),
                        ],
                      ),
                      AppshadowContainer(
                        padding: EdgeInsets.all(size.width * 0.04),
                        color: AppColors.white,
                        child: Column(
                          children: List.generate(
                            watchMentorCubit.selectedGoals?.length ?? 0,
                            (index) => Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(
                                        size.width * 0.02,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.green.shade700,
                                        size: 18.sp + (index * 2),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.03),
                                    Expanded(
                                      child: InAppText(
                                        text:
                                            watchMentorCubit
                                                .selectedGoals?[index] ??
                                            "",

                                        color: AppColors.lightblack,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: size.height * 0.015),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: size.height * 0.025),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.blue.withAlpha(10),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.interests,
                              color: AppColors.filledColor,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: size.width * 0.03),
                          InAppText(
                            text: "Interests",
                            size: 20,
                            fontweight: FontWeight.w700,
                            color: AppColors.blue,
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.015),
                      Wrap(
                        spacing: size.width * 0.025,
                        runSpacing: size.height * 0.012,
                        children: List.generate(
                          watchMentorCubit.selectedInterests?.length ?? 0,
                          (index) => Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.04,
                              vertical: size.height * 0.01,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.inactive,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.blue.withAlpha(30),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: InAppText(
                              text:
                                  readMentorCubit.selectedInterests?[index] ??
                                  "",
                              fontweight: FontWeight.w500,
                              color: AppColors.lightblack,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: size.height * 0.04),
                      AppButton(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routename.acceptMentorship,
                          );
                        },
                        width: size.width,
                        buttonColor: AppColors.background,
                        label:
                            'Accept ${readMentorCubit.selectedMenteeName.split(' ').first} as Mentee',
                        textSize: 17,
                      ),
                      SizedBox(height: size.height * 0.015),
                      AppButton(
                        isLoading: state is MentorLoadingState,
                        onTap: () {
                          final readAuthCubit = context
                              .read<AuthenticationCubit>();
                          if (readAuthCubit.user.isMentor) {
                            Future.delayed(
                              const Duration(milliseconds: 500),
                              () {
                                readMentorCubit.declineRequest(
                                  readMentorCubit.selectedMatchId!,
                                  readAuthCubit.user.id ?? "",
                                );
                              },
                            );
                          }
                        },
                        width: size.width,
                        bordercolor: AppColors.errorColor,
                        label: 'Decline Request',
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
        );
      },
    );
  }
}
