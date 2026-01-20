// lib/features/Dashboard/presentation/pages/shared_resources.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Rating&Reviews/pages/cubit/review_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

// Simple Resource Model
class Resource {
  final String id;
  final String title;
  final String type;
  final String mentor;
  final String date;
  final String description;
  final IconData icon;
  final Color color;
  bool isBookmarked;

  Resource({
    required this.id,
    required this.title,
    required this.type,
    required this.mentor,
    required this.date,
    required this.description,
    required this.icon,
    required this.color,
    this.isBookmarked = false,
  });
}

class SharedResources extends StatefulWidget {
  const SharedResources({super.key});

  @override
  State<SharedResources> createState() => _SharedResourcesState();
}

class _SharedResourcesState extends State<SharedResources> {
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    context.read<ReviewCubit>().loadSharedResources(
      context.read<AuthenticationCubit>().user.id ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final cubit = context.watch<ReviewCubit>();

    // Filter resources based on selected filter
    final filteredResources = selectedFilter == 'All'
        ? cubit.sharedResources
        : cubit.sharedResources
              .where((r) => r['resource_type'] == selectedFilter)
              .toList();

    // Calculate counts for each filter
    final resourceCounts = {
      'All': cubit.sharedResources.length,
      'Video': cubit.sharedResources
          .where((r) => r['resource_type'] == 'Video')
          .length,
      'Article': cubit.sharedResources
          .where((r) => r['resource_type'] == 'Article')
          .length,
      'Course': cubit.sharedResources
          .where((r) => r['resource_type'] == 'Course')
          .length,
      'Book': cubit.sharedResources
          .where((r) => r['resource_type'] == 'Book')
          .length,
    };

    return AppScaffold(
      // color: AppColors.background,
      body: Column(
        children: [
          AppbarWidget(
            title: 'Shared Resources',
            size: size,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(height: size.height * 0.02),
          // Filter Chips
          Container(
            width: size.width,
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04,
              vertical: size.height * 0.015,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey.withAlpha(10),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', resourceCounts['All']!, size),
                  SizedBox(width: size.width * 0.02),
                  _buildFilterChip('Video', resourceCounts['Video']!, size),
                  SizedBox(width: size.width * 0.02),
                  _buildFilterChip('Article', resourceCounts['Article']!, size),
                  SizedBox(width: size.width * 0.02),
                  _buildFilterChip('Course', resourceCounts['Course']!, size),
                  SizedBox(width: size.width * 0.02),
                  _buildFilterChip('Book', resourceCounts['Book']!, size),
                ],
              ),
            ),
          ),

          // Resources List
          Expanded(
            child: filteredResources.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 80,
                          color: AppColors.grey.withAlpha(50),
                        ),
                        SizedBox(height: size.height * 0.02),
                        InAppText(
                          text: "No resources found",
                          size: 18,
                          fontweight: FontWeight.w600,
                          color: AppColors.grey,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(size.width * 0.04),
                    itemCount: filteredResources.length,
                    itemBuilder: (context, index) {
                      final resourceMap = filteredResources[index];
                      final resource = Resource(
                        id: resourceMap['id'] ?? '',
                        title: resourceMap['title'] ?? '',
                        type: resourceMap['resource_type'] ?? '',
                        mentor: resourceMap['mentor_name'] ?? '',
                        date: resourceMap['created_at'] ?? '',
                        description: resourceMap['description'] ?? '',
                        icon: Icons.description,
                        color: AppColors.blue,
                      );
                      return _buildResourceCard(resource, size);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int count, Size size) {
    final isSelected = selectedFilter == label;

    return GestureDetector(
      onTap: () => setState(() => selectedFilter = label),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.height * 0.01,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [AppColors.background, AppColors.filledColor],
                )
              : null,
          color: isSelected ? null : AppColors.grey.withAlpha(32),
          borderRadius: BorderRadius.circular(size.width * 0.09),
          border: Border.all(
            color: isSelected
                ? AppColors.background
                : AppColors.grey.withAlpha(50),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.grey.withAlpha(30),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InAppText(
              text: label,
              fontweight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.white : AppColors.grey,
            ),
            SizedBox(width: size.width * 0.01),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.02,
                vertical: size.width * 0.005,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.white.withAlpha(40)
                    : AppColors.grey.withAlpha(40),
                borderRadius: BorderRadius.circular(size.width * 0.025),
              ),
              child: InAppText(
                text: count.toString(),
                size: 14,
                fontweight: FontWeight.w700,
                color: isSelected ? AppColors.white : AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceCard(Resource resource, Size size) {
    return AppshadowContainer(
      onTap: () => _showResourceDetails(resource, size),
      margin: EdgeInsets.only(bottom: size.height * 0.03),
      padding: EdgeInsets.all(size.width * 0.04),
      shadowcolour: AppColors.blue.withAlpha(50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: size.width * 0.15,
            height: size.width * 0.15,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [resource.color, resource.color.withAlpha(70)],
              ),
              borderRadius: BorderRadius.circular(size.width * 0.09),
              boxShadow: [
                BoxShadow(
                  color: resource.color.withAlpha(30),
                  blurRadius: 10,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Icon(resource.icon, color: AppColors.white, size: 28.sp),
          ),
          SizedBox(width: size.width * 0.04),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.02,
                    vertical: size.height * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: resource.color.withAlpha(10),
                    borderRadius: BorderRadius.circular(size.width * 0.05),
                  ),
                  child: InAppText(
                    text: resource.type,
                    size: 14,
                    fontweight: FontWeight.w600,
                    color: resource.color,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                InAppText(
                  text: resource.title,

                  fontweight: FontWeight.w700,
                  maxline: 2,
                ),
                SizedBox(height: size.height * 0.01),
                InAppText(
                  text: resource.description,
                  size: 16,
                  color: AppColors.grey,
                  maxline: 2,
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 18.sp,
                      color: AppColors.grey,
                    ),
                    SizedBox(width: size.width * 0.02),
                    Expanded(
                      child: InAppText(
                        text: resource.mentor,
                        size: 14,
                        color: AppColors.grey,
                        maxline: 1,
                      ),
                    ),
                    SizedBox(width: size.width * 0.02),
                    Icon(Icons.access_time, size: 18.sp, color: AppColors.grey),
                    SizedBox(width: size.width * 0.02),
                    InAppText(
                      text: resource.date,
                      size: 14,
                      color: AppColors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bookmark
          GestureDetector(
            onTap: () =>
                setState(() => resource.isBookmarked = !resource.isBookmarked),
            child: Icon(
              resource.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              size: 24,
              color: resource.isBookmarked ? resource.color : AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _showResourceDetails(Resource resource, Size size) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: size.height * 0.48,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(size.width * 0.05),
            topRight: Radius.circular(size.width * 0.05),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
              width: size.width * 0.1,
              height: size.width * 0.01,
              decoration: BoxDecoration(
                color: AppColors.grey.withAlpha(30),
                borderRadius: BorderRadius.circular(size.width * 0.01),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(size.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(size.width * 0.04),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                resource.color,
                                resource.color.withAlpha(70),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                              size.width * 0.09,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: resource.color.withAlpha(30),
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Icon(
                            resource.icon,
                            color: AppColors.white,
                            size: 32.sp,
                          ),
                        ),
                        SizedBox(width: size.width * 0.04),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.04,
                                  vertical: size.height * 0.005,
                                ),
                                decoration: BoxDecoration(
                                  color: resource.color.withAlpha(10),
                                  borderRadius: BorderRadius.circular(
                                    size.width * 0.05,
                                  ),
                                ),
                                child: InAppText(
                                  text: resource.type,
                                  size: 14,
                                  fontweight: FontWeight.w600,
                                  color: resource.color,
                                ),
                              ),
                              SizedBox(height: size.height * 0.01),
                              InAppText(
                                text: resource.date,
                                size: 16,
                                color: AppColors.grey,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.025),
                    InAppText(
                      text: resource.title,
                      size: 24,
                      fontweight: FontWeight.w700,
                      color: AppColors.blue,
                      maxline: 3,
                    ),
                    SizedBox(height: size.height * 0.015),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: size.width * 0.05,
                          backgroundColor: resource.color,
                          child: Icon(
                            Icons.person,
                            color: AppColors.white,
                            size: 25.sp,
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        InAppText(
                          text: "Shared by ${resource.mentor}",
                          size: 16,
                          fontweight: FontWeight.w500,
                          color: AppColors.grey,
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.025),
                    InAppText(
                      text: "Description",

                      fontweight: FontWeight.w600,
                      color: AppColors.blue,
                    ),
                    SizedBox(height: size.height * 0.01),
                    InAppText(
                      text: resource.description,
                      size: 16,
                      color: AppColors.lightblack,
                      maxline: 10,
                    ),
                    SizedBox(height: size.height * 0.03),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            onTap: () {},
                            buttonColor: resource.color,
                            label: 'Open Resource',
                            textSize: 16,
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        Container(
                          width: size.width * 0.15,
                          height: size.width * 0.15,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.grey.withAlpha(30),
                              width: size.width * 0.005,
                            ),
                            borderRadius: BorderRadius.circular(
                              size.width * 0.075,
                            ),
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(
                                () => resource.isBookmarked =
                                    !resource.isBookmarked,
                              );
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              resource.isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: resource.isBookmarked
                                  ? resource.color
                                  : AppColors.blue,
                            ),
                          ),
                        ),
                      ],
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
