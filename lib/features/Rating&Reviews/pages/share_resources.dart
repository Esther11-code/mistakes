// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Rating&Reviews/pages/cubit/review_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

class ShareResources extends StatefulWidget {
  const ShareResources({super.key});

  @override
  State<ShareResources> createState() => _ShareResourcesState();
}

class _ShareResourcesState extends State<ShareResources> {
  @override
  void initState() {
    super.initState();
    context.read<ReviewCubit>().loadAvailableMentees(
      context.read<AuthenticationCubit>().user.id ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final cubit = context.watch<ReviewCubit>();

    return AppScaffold(
      body: BlocListener<ReviewCubit, ReviewState>(
        listener: (context, state) {
          if (state is ReviewFeedbackLoadedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Resource shared successfully!')),
            );
           Navigator.pop(context);
          }
          if (state is ReviewErrorState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: Column(
          children: [
            AppbarWidget(
              title: 'Share Resource',
              size: size,
              onTap: () => Navigator.pop(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.025),

                    // Resource Type Selection
                    Text.rich(
                      TextSpan(
                        text: 'Resource Type',
                        style: GoogleFonts.ptSans(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: '*',
                            style: GoogleFonts.ptSans(
                              color: AppColors.errorColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.015),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: size.width * 0.03,
                        mainAxisSpacing: size.height * 0.015,
                        childAspectRatio: 1,
                      ),
                      itemCount: cubit.resourceTypes.length,
                      itemBuilder: (context, index) {
                        return ResourceTypeChip(
                          icon: cubit.resourceTypeIcons[index],
                          label: cubit.resourceTypes[index],
                          isSelected: cubit.selectedResourceTypeIndex == index,
                          size: size,
                          onTap: () => cubit.selectResourceType(index),
                        );
                      },
                    ),

                    SizedBox(height: size.height * 0.025),

                    // Resource Title
                    Text.rich(
                      TextSpan(
                        text: 'Resource Title',
                        style: GoogleFonts.ptSans(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: '*',
                            style: GoogleFonts.ptSans(
                              color: AppColors.errorColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.012),
                    AppshadowContainer(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                        vertical: size.height * 0.005,
                      ),
                      color: AppColors.white,
                      child: ApptextField(
                        controller: cubit.resourceTitleController,
                        hintText: "e.g., React Hooks Documentation",
                        prefixIconn: Icon(Icons.title_outlined, size: 20.sp),
                        keyboardType: TextInputType.text,
                      ),
                    ),

                    SizedBox(height: size.height * 0.025),

                    // URL
                    Text.rich(
                      TextSpan(
                        text: 'URL',
                        style: GoogleFonts.ptSans(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: '*',
                            style: GoogleFonts.ptSans(
                              color: AppColors.errorColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.012),
                    AppshadowContainer(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                        vertical: size.height * 0.005,
                      ),
                      color: AppColors.white,
                      child: ApptextField(
                        controller: cubit.resourceUrlController,
                        hintText: "e.g., https://...",
                        keyboardType: TextInputType.url,
                        prefixIconn: Icon(Icons.link_outlined, size: 20.sp),
                      ),
                    ),

                    SizedBox(height: size.height * 0.025),

                    // Description
                    InAppText(
                      text: "Description",
                      size: 20.sp,
                      fontweight: FontWeight.w600,
                    ),
                    SizedBox(height: size.height * 0.012),
                    AppshadowContainer(
                      padding: EdgeInsets.all(size.width * 0.04),
                      color: AppColors.white,
                      child: ApptextField(
                        controller: cubit.resourceDescriptionController,
                        maxLine: 5,
                        hintText: "Why you're sharing this resource...",
                      ),
                    ),

                    SizedBox(height: size.height * 0.025),

                    // Share With
                    InAppText(
                      text: "Share With",
                      size: 20.sp,
                      fontweight: FontWeight.w600,
                    ),
                    SizedBox(height: size.height * 0.012),

                    // Individual Mentees
                    if (cubit.availableMentees.isNotEmpty)
                      ...cubit.availableMentees.map((mentee) {
                        final isSelected = cubit.selectedMenteeIds.contains(
                          mentee['mentee_id'],
                        );
                        return Padding(
                          padding: EdgeInsets.only(bottom: size.height * 0.012),
                          child: MenteeSelectCard(
                            name: mentee['full_name'] ?? mentee['username'],
                            category: mentee['expertise'] ?? 'N/A',
                            isSelected: isSelected,
                            gradient: LinearGradient(
                              colors: [AppColors.blue, AppColors.filledColor],
                            ),
                            size: size,
                            onTap: () => cubit.toggleMenteeSelection(
                              mentee['mentee_id'],
                            ),
                          ),
                        );
                      }),

                    // Share with All
                    GestureDetector(
                      onTap: () => cubit.toggleShareWithAll(),
                      child: AppshadowContainer(
                        padding: EdgeInsets.all(size.width * 0.04),
                        color: cubit.shareWithAll
                            ? AppColors.filledColor
                            : AppColors.inactive.withAlpha(30),
                        border: cubit.shareWithAll,
                        borderColor: AppColors.blue.withAlpha(100),
                        child: Row(
                          children: [
                            Container(
                              width: size.width * 0.15,
                              height: size.width * 0.15,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.orange,
                                    AppColors.orange.withAlpha(100),
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.group,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                            ),
                            SizedBox(width: size.width * 0.03),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InAppText(
                                    text: "All Mentees",
                                    fontweight: FontWeight.w600,
                                    color: cubit.shareWithAll
                                        ? AppColors.white
                                        : AppColors.blue,
                                  ),
                                  InAppText(
                                    text: "Share with everyone",
                                    size: 16,
                                    color: cubit.shareWithAll
                                        ? AppColors.white.withAlpha(180)
                                        : AppColors.grey,
                                  ),
                                ],
                              ),
                            ),
                            Radio(
                              value: true,
                              groupValue: cubit.shareWithAll,
                              onChanged: (value) => cubit.toggleShareWithAll(),
                              activeColor: AppColors.white,
                              fillColor: MaterialStateProperty.all(
                                cubit.shareWithAll
                                    ? AppColors.white
                                    : AppColors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.04),

                    // Buttons
                    BlocBuilder<ReviewCubit, ReviewState>(
                      builder: (context, state) {
                        final isLoading = state is ReviewFeedbackLoading;

                        return AppButton(
                          isLoading: isLoading,
                          onTap: isLoading
                              ? null
                              : () => cubit.shareResource(
                                  context.read<AuthenticationCubit>().user.id ??
                                      "",
                                ),
                          width: size.width,
                          buttonColor: AppColors.background,
                          label: 'Share Resource',
                          textSize: 17,
                        );
                      },
                    ),
                    SizedBox(height: size.height * 0.015),
                    AppButton(
                      onTap: () => Navigator.pop(context),
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

class ResourceTypeChip extends StatelessWidget {
  final IconData icon;
  final String label;

  final bool isSelected;
  final Size size;
  final VoidCallback? onTap;

  const ResourceTypeChip({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.size,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.filledColor,
                    AppColors.filledColor.withAlpha(80),
                  ],
                )
              : null,
          color: isSelected
              ? AppColors.filledColor
              : AppColors.grey.withAlpha(10),
          borderRadius: BorderRadius.circular(size.width * 0.03),
          border: Border.all(
            color: isSelected
                ? AppColors.filledColor
                : AppColors.grey.withAlpha(50),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.grey.withAlpha(50),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22.sp,
              color: isSelected ? AppColors.white : AppColors.blackColor,
            ),
            SizedBox(height: 4),
            InAppText(
              text: label,

              fontweight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.white : AppColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }
}

class MenteeSelectCard extends StatelessWidget {
  final String name;
  final String category;
  final bool isSelected;
  final Gradient gradient;
  final Size size;
  final VoidCallback? onTap;

  const MenteeSelectCard({
    super.key,
    required this.name,
    required this.category,
    required this.isSelected,
    required this.gradient,
    required this.size,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppshadowContainer(
      onTap: onTap,
      padding: EdgeInsets.all(size.width * 0.04),
      color: isSelected ? AppColors.filledColor : AppColors.white,
      border: isSelected,
      borderColor: AppColors.blue.withAlpha(100),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(size.width * 0.02),
            width: size.width * 0.15,
            height: size.width * 0.15,
            decoration: BoxDecoration(
              gradient: gradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.blue.withAlpha(30),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: AppText(
                text: name.split(' ').map((e) => e[0]).join(),
                fontweight: FontWeight.w900,
                color: AppColors.white,
              ),
            ),
          ),
          SizedBox(width: size.width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InAppText(
                  text: name,

                  fontweight: FontWeight.w600,
                  color: isSelected ? AppColors.white : AppColors.blue,
                ),
                SizedBox(height: size.height * 0.005),
                Row(
                  children: [
                    Icon(
                      Icons.code,
                      size: 18.sp,
                      color: isSelected ? AppColors.white : AppColors.blue,
                    ),
                    SizedBox(width: size.width * 0.012),
                    Expanded(
                      child: InAppText(
                        text: category,
                        maxline: 3,
                        size: 16,
                        color: isSelected ? AppColors.white : AppColors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Radio(
            value: true,
            groupValue: isSelected,
            onChanged: (value) {},
            activeColor: AppColors.white,
            splashRadius: size.width * 0.09,
            toggleable: true,
          ),
        ],
      ),
    );
  }
}
