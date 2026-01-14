import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mistakes/constants/utils/utils.dart';
import 'package:mistakes/features/Profile/presentation/cubit/profile_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';
import '../../../../../../constants/utils/app_colors.dart' show AppColors;

class MyRequest extends StatelessWidget {
  const MyRequest({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchProfileCubit = context.watch<ProfileCubit>();
    final readProfileCubit = context.read<ProfileCubit>();

    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(
            title: 'My Requests',
            size: size,
            onTap: () => Navigator.pop(context),
          ),
          SizedBox(height: size.height * 0.02),
          AppshadowContainer(
            border: true,
            borderColor: AppColors.filledColor,
            color: Colors.transparent,
            width: size.width * 0.92,
            padding: EdgeInsets.all(size.width * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                watchProfileCubit.currentRequestFilter.length,
                (int index) => Expanded(
                  child: AppshadowContainer(
                    color: watchProfileCubit.selectedStatusIndex == index
                        ? AppColors.filledColor
                        : Colors.transparent,
                    onTap: () => readProfileCubit.changeStatus(index),
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.009,
                      horizontal: size.width * 0.015,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InAppText(
                            text: watchProfileCubit.currentRequestFilter[index],
                            color:
                                watchProfileCubit.selectedStatusIndex == index
                                ? AppColors.white
                                : AppColors.grey,
                            fontweight: FontWeight.w600,
                            size: 16,
                          ),
                          if (watchProfileCubit.getStatusCount(index) > 0) ...[
                            SizedBox(width: size.width * 0.008),
                            CircleAvatar(
                              radius: size.width * 0.02,
                              backgroundColor:
                                  watchProfileCubit.selectedStatusIndex == index
                                  ? AppColors.white
                                  : AppColors.filledColor,
                              child: InAppText(
                                text:
                                    '${watchProfileCubit.getStatusCount(index)}',
                                color:
                                    watchProfileCubit.selectedStatusIndex ==
                                        index
                                    ? AppColors.filledColor
                                    : AppColors.white,
                                fontweight: FontWeight.bold,
                                size: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: size.height * 0.02),
          Expanded(
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoadingState) {
                  return Center(
                    child: LoadingAnimationWidget.inkDrop(
                      color: AppColors.blue,
                      size: 50.sp,
                    ),
                  );
                }

                if (watchProfileCubit.myPendingRequests.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 80.sp,
                          color: AppColors.lightblack,
                        ),
                        SizedBox(height: size.height * 0.02),
                        InAppText(
                          text:
                              'No ${watchProfileCubit.currentRequestFilter[watchProfileCubit.selectedStatusIndex].toLowerCase()} requests',

                          color: AppColors.blue,
                          fontweight: FontWeight.w600,
                        ),
                        SizedBox(height: size.height * 0.01),
                        InAppText(
                          text: 'Start by browsing mentors',
                          color: AppColors.grey,
                        ),
                      ],
                    ),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      watchProfileCubit.myPendingRequests.length,
                      (index) {
                        final request =
                            watchProfileCubit.myPendingRequests[index];
                        return MyRequestContainer(
                          size: size,
                          mentorName: request['mentor_name'],
                          mentorProfession: request['mentor_expertise'],
                          mentorPhoto: request['mentor_photo'],
                          requestStatus: request['status'],
                          requestDate: request['requested_at'],
                          message: request['message'],
                        );
                      },
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
}

class MyRequestContainer extends StatelessWidget {
  const MyRequestContainer({
    super.key,
    required this.size,
    this.requestStatus,
    this.mentorName,
    this.mentorProfession,
    this.mentorPhoto,
    this.requestDate,
    this.message,
  });

  final Size size;
  final String? requestStatus;
  final String? mentorName;
  final String? mentorProfession;
  final String? mentorPhoto;
  final String? requestDate;
  final String? message;

  Color getStatusColor() {
    switch (requestStatus?.toLowerCase()) {
      case 'pending':
        return AppColors.orange;
      case 'accepted':
        return AppColors.success;
      case 'declined':
        return AppColors.errorColor;
      default:
        return AppColors.grey;
    }
  }

  String getStatusMessage() {
    switch (requestStatus?.toLowerCase()) {
      case 'pending':
        return 'Your request is being reviewed by mentor.';
      case 'accepted':
        return 'Your request has been accepted! Start chatting.';
      case 'declined':
        return 'Your request was declined by the mentor.';
      default:
        return 'Request status unknown.';
    }
  }

  IconData getStatusIcon() {
    switch (requestStatus?.toLowerCase()) {
      case 'pending':
        return Icons.info;
      case 'accepted':
        return Icons.check_circle;
      case 'declined':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppshadowContainer(
      margin: EdgeInsets.symmetric(
        vertical: size.height * 0.01,
        horizontal: size.width * 0.04,
      ),
      padding: EdgeInsets.all(size.width * 0.04),
      shadowcolour: AppColors.lightgrey.withAlpha(100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              mentorPhoto != null && mentorPhoto!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(size.width * 0.075),
                      child: Image.network(
                        mentorPhoto!,
                        width: size.width * 0.15,
                        height: size.width * 0.15,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return AppshadowContainer(
                            width: size.width * 0.15,
                            height: size.width * 0.15,
                            color: AppColors.filledColor,
                            child: Icon(
                              Icons.person,
                              color: AppColors.white,
                              size: 20.sp,
                            ),
                          );
                        },
                      ),
                    )
                  : AppshadowContainer(
                      padding: EdgeInsets.all(size.width * 0.02),
                      width: size.width * 0.15,
                      height: size.width * 0.15,
                      color: AppColors.filledColor,
                      child: Icon(
                        Icons.person,
                        color: AppColors.white,
                        size: 20.sp,
                      ),
                    ),

              SizedBox(width: size.width * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InAppText(
                      text: mentorName ?? "Mentor Name",
                      fontweight: FontWeight.w800,
                      size: 18,
                    ),
                    SizedBox(height: size.height * 0.005),
                    InAppText(
                      text: mentorProfession ?? "Mentor Profession",
                      fontweight: FontWeight.w500,
                      size: 15,
                      color: AppColors.grey,
                    ),
                    SizedBox(height: size.height * 0.005),
                    InAppText(
                      text: "Requested ${Utils.getTimeAgo(requestDate)}",
                      fontweight: FontWeight.w400,
                      color: AppColors.blue.withAlpha(150),
                      size: 15,
                    ),
                  ],
                ),
              ),
              AppshadowContainer(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                  vertical: size.height * 0.008,
                ),
                borderRadius: BorderRadius.circular(size.width * 0.05),
                border: true,
                borderColor: getStatusColor().withAlpha(100),
                color: getStatusColor().withAlpha(50),
                child: InAppText(
                  text: (requestStatus ?? "unknown").toUpperCase(),
                  color: getStatusColor(),
                  fontweight: FontWeight.w700,
                  size: 13,
                ),
              ),
            ],
          ),
          if (message != null && message!.isNotEmpty) ...[
            AppshadowContainer(
              margin: EdgeInsets.only(top: size.height * 0.015),
              padding: EdgeInsets.all(size.width * 0.03),
              color: AppColors.grey.withAlpha(40),
              child: InAppText(
                text: '"$message"',
                size: 15,
                fontweight: FontWeight.w400,
                maxline: 3,
              ),
            ),
          ],
          AppshadowContainer(
            margin: EdgeInsets.only(top: size.height * 0.015),
            padding: EdgeInsets.all(size.width * 0.03),
            color: getStatusColor().withAlpha(30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(getStatusIcon(), color: getStatusColor(), size: 20.sp),
                SizedBox(width: size.width * 0.02),
                Expanded(
                  child: InAppText(
                    color: getStatusColor(),
                    text: getStatusMessage(),
                    size: 14,
                    fontweight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
