import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mistakes/features/Home/presentation/widgets/my_request_widget.dart';
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
