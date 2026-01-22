import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/constants/utils/utils.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Bookmark/pages/cubit/bookmark_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../constants/utils/app_colors.dart';
import '../../../Home/presentation/widgets/home.dart';

class ResourceBookmarkCard extends StatelessWidget {
  const ResourceBookmarkCard({
    super.key,
    required this.size,
    required this.resourceTitle,
    required this.resourceDescription,
    required this.resourceType,
    required this.resourceUrl,
    required this.bookmarkedAt,
    required this.onRemove,
  });

  final Size size;
  final String? resourceTitle;
  final String? resourceDescription;
  final String? resourceType;
  final String? resourceUrl;
  final String? bookmarkedAt;
  final VoidCallback onRemove;

  IconData getResourceIcon() {
    switch (resourceType?.toLowerCase()) {
      case 'article':
        return Icons.article;
      case 'video':
        return Icons.play_circle_outline;
      case 'course':
        return Icons.school;
      case 'book':
        return Icons.menu_book;
      default:
        return Icons.link;
    }
  }

  Color getResourceColor() {
    switch (resourceType?.toLowerCase()) {
      case 'article':
        return AppColors.blue;
      case 'video':
        return AppColors.errorColor;
      case 'course':
        return AppColors.success;
      case 'book':
        return AppColors.orange;
      default:
        return AppColors.grey;
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
      child: Row(
        children: [
          // Icon
          AppshadowContainer(
            width: size.width * 0.15,
            height: size.width * 0.15,
            color: getResourceColor().withAlpha(50),
            child: Icon(
              getResourceIcon(),
              color: getResourceColor(),
              size: 24.sp,
            ),
          ),

          SizedBox(width: size.width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InAppText(
                  text: resourceTitle ?? "Resource Title",
                  fontweight: FontWeight.w700,
                  size: 16,
                  maxline: 2,
                ),
                SizedBox(height: 4),
                InAppText(
                  text: resourceDescription ?? "No description",
                  fontweight: FontWeight.w400,
                  size: 14,
                  color: AppColors.grey,
                  maxline: 2,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    AppshadowContainer(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      color: getResourceColor().withAlpha(50),
                      borderRadius: BorderRadius.circular(12),
                      child: InAppText(
                        text: (resourceType ?? "link").toUpperCase(),
                        color: getResourceColor(),
                        fontweight: FontWeight.w600,
                        size: 12,
                      ),
                    ),
                    Spacer(),
                    InAppText(
                      text: "Saved ${Utils.getTimeAgo(bookmarkedAt)}",
                      fontweight: FontWeight.w400,
                      size: 12,
                      color: AppColors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: size.width * 0.02),

          // Remove Button
          IconButton(
            onPressed: onRemove,
            icon: Icon(
              Icons.bookmark,
              color: AppColors.errorColor,
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class BuildResourcesTab extends StatelessWidget {
  const BuildResourcesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final cubit = context.watch<BookmarksCubit>();
    if (cubit.bookmarkedResources.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 80.sp, color: AppColors.blue),
            SizedBox(height: size.height * 0.02),
            InAppText(
              text: 'No saved resources',
              color: AppColors.blue,
              fontweight: FontWeight.w600,
            ),
            SizedBox(height: size.height * 0.01),
            InAppText(
              text: 'Bookmark resources to save them here',
              size: 16,
              color: AppColors.blue,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: List.generate(cubit.bookmarkedResources.length, (index) {
          final resource = cubit.bookmarkedResources[index];
          return ResourceBookmarkCard(
            size: size,
            resourceTitle: resource['resource_title'],
            resourceDescription: resource['resource_description'],
            resourceType: resource['resource_type'],
            resourceUrl: resource['resource_url'],
            bookmarkedAt: resource['bookmarked_at'],
            onRemove: () {
              final userId = context.read<AuthenticationCubit>().user.id;
              if (userId != null) {
                context.read<BookmarksCubit>().toggleResourceBookmark(
                  userId: userId,
                  resourceId: resource['resource_id'],
                );
              }
            },
          );
        }),
      ),
    );
  }
}

class BuildMentorsTab extends StatelessWidget {
  const BuildMentorsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final cubit = context.watch<BookmarksCubit>();
    if (cubit.bookmarkedMentors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border, size: 80.sp, color: AppColors.blue),
            SizedBox(height: size.height * 0.02),
            InAppText(
              text: 'No saved mentors',
              size: 18,
              color: AppColors.blue,
              fontweight: FontWeight.w600,
            ),
            SizedBox(height: size.height * 0.01),
            InAppText(
              text: 'Bookmark mentors to save them here',
              color: AppColors.blue,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: List.generate(cubit.bookmarkedMentors.length, (index) {
          final mentor = cubit.bookmarkedMentors[index];
          return MentorList(
            size: size,
            mentorId: mentor['mentor_id'],
            mentorName: mentor['mentor_name'],
            expertise: mentor['mentor_expertise'],
            profileImage: mentor['mentor_photo'],
            yoe: "${mentor['mentor_experience']?.toString()}",
          );
        }),
      ),
    );
  }
}
