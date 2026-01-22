
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/constants/utils/utils.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../constants/utils/app_colors.dart';

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
