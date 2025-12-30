import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/global%20widgets/export.dart';

class ShareResources extends StatelessWidget {
  const ShareResources({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(
            title: 'Share Resource',
            size: size,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.025),
                  Text.rich(
                    TextSpan(
                      text: 'Resource Type',
                      style: GoogleFonts.ptSans(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                      children: [
                        TextSpan(
                          text: '*',
                          style: GoogleFonts.ptSans(
                            color: AppColors.errorColor,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.015),
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: size.width * 0.03,
                    mainAxisSpacing: size.height * 0.015,
                    childAspectRatio: 1,
                    children: [
                      ResourceTypeChip(
                        icon: Icons.play_circle_outline,
                        label: "Video",

                        isSelected: true,
                        size: size,
                      ),
                      ResourceTypeChip(
                        icon: Icons.article_outlined,
                        label: "Article",
                        isSelected: false,
                        size: size,
                      ),
                      ResourceTypeChip(
                        icon: Icons.school_outlined,
                        label: "Course",
                        isSelected: false,
                        size: size,
                      ),
                      ResourceTypeChip(
                        icon: Icons.menu_book_outlined,
                        label: "Book",
                        isSelected: false,
                        size: size,
                      ),
                      ResourceTypeChip(
                        icon: Icons.folder_outlined,
                        label: "Project",
                        isSelected: false,
                        size: size,
                      ),
                      ResourceTypeChip(
                        icon: Icons.description_outlined,
                        label: "Docs",
                        isSelected: false,
                        size: size,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.025),
                  Text.rich(
                    TextSpan(
                      text: 'Resource Title',
                      style: GoogleFonts.ptSans(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                      children: [
                        TextSpan(
                          text: '*',
                          style: GoogleFonts.ptSans(
                            color: AppColors.errorColor,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
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
                      hintText: "e.g., React Hooks Documentation",
                      prefixIconn: Icon(Icons.title_outlined, size: 20.sp),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(height: size.height * 0.025),
                  Text.rich(
                    TextSpan(
                      text: 'URL',
                      style: GoogleFonts.ptSans(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                      children: [
                        TextSpan(
                          text: '*',
                          style: GoogleFonts.ptSans(
                            color: AppColors.errorColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
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
                      hintText: "e.g., https://...",
                      keyboardType: TextInputType.url,
                      prefixIconn: Icon(Icons.link_outlined, size: 20.sp),
                    ),
                  ),
                  SizedBox(height: size.height * 0.025),
                  InAppText(
                    text: "Description",
                    size: 20.sp,
                    fontweight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(height: size.height * 0.012),
                  AppshadowContainer(
                    padding: EdgeInsets.all(size.width * 0.04),
                    color: AppColors.white,
                    child: ApptextField(
                      maxLine: 5,
                      hintText: "Why you're sharing this resource...",
                    ),
                  ),

                  SizedBox(height: size.height * 0.025),
                  InAppText(
                    text: "Share With",
                    size: 20,
                    fontweight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(height: size.height * 0.012),
                  MenteeSelectCard(
                    name: "Sarah Johnson",
                    category: "Web Development",
                    isSelected: true,
                    gradient: LinearGradient(
                      colors: [Colors.purple.shade400, Colors.pink.shade400],
                    ),
                    size: size,
                  ),
                  SizedBox(height: size.height * 0.012),
                  MenteeSelectCard(
                    name: "Mike Kim",
                    category: "Mobile Development",
                    isSelected: false,
                    gradient: LinearGradient(
                      colors: [AppColors.blue, AppColors.filledColor],
                    ),
                    size: size,
                  ),
                  SizedBox(height: size.height * 0.012),
                  AppshadowContainer(
                    padding: EdgeInsets.all(size.width * 0.04),
                    color: AppColors.inactive.withAlpha(30),
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
                            size: 24,
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
                                color: AppColors.blue,
                              ),
                              InAppText(
                                text: "Share with everyone",
                                size: 16,
                                color: AppColors.grey,
                              ),
                            ],
                          ),
                        ),
                        Radio(
                          value: true,
                          groupValue: true,
                          onChanged: (value) {},
                          activeColor: AppColors.blue,
                          splashRadius: size.width * 0.09,
                          toggleable: true,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.height * 0.04),
                  AppButton(
                    onTap: () {
                      // Handle share resource action
                    },
                    width: size.width,
                    buttonColor: AppColors.background,
                    label: 'Share Resource',
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
    );
  }
}

class ResourceTypeChip extends StatelessWidget {
  final IconData icon;
  final String label;

  final bool isSelected;
  final Size size;

  const ResourceTypeChip({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class MenteeSelectCard extends StatelessWidget {
  final String name;
  final String category;
  final bool isSelected;
  final Gradient gradient;
  final Size size;

  const MenteeSelectCard({
    super.key,
    required this.name,
    required this.category,
    required this.isSelected,
    required this.gradient,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AppshadowContainer(
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
                    InAppText(
                      text: category,
                      size: 16,
                      color: isSelected ? AppColors.white : AppColors.blue,
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
