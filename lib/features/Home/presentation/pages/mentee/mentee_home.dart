import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Home/presentation/cubit/home_cubit.dart';
import 'package:mistakes/features/Home/presentation/pages/home.dart';
import 'package:mistakes/features/Home/presentation/widgets/src/home_appbar.dart';
import 'package:mistakes/global%20widgets/export.dart';

class MenteeHome extends StatefulWidget {
  const MenteeHome({super.key});

  @override
  State<MenteeHome> createState() => MenteeHomeState();
}

class MenteeHomeState extends State<MenteeHome> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load mentors when screen opens
    context.read<HomeCubit>().searchAndFilter(role: 'mentor', reload: true);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AppScaffold(
      body: BlocListener<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is UserSearchErrorState) {
            Fluttertoast.showToast(msg: state.error);
            searchController.clear();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeAppbar(size: size),
            SizedBox(height: size.height * 0.025),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.02),
                    HomeCarousel(size: size),
                    SizedBox(height: size.height * 0.025),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          context.read<HomeCubit>().searchAndFilter(
                            query: value,
                            role: 'mentor',
                          );
                        },
                        decoration: InputDecoration(
                          labelText: 'What do you need?',
                          labelStyle: GoogleFonts.ptSans(
                            fontSize: 20.sp,
                            color: AppColors.blackColor,
                          ),
                          hintText: 'Example: Mentors, Years..',
                          hintStyle: GoogleFonts.ptSans(
                            fontSize: 15.sp,
                            color: AppColors.grey,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.blackColor,
                          ),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: AppColors.grey,
                                  ),
                                  onPressed: () {
                                    searchController.clear();
                                    context.read<HomeCubit>().searchAndFilter(
                                      query: '',
                                      role: 'mentor',
                                    );
                                    setState(() {});
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              size.width * 0.03,
                            ),
                            borderSide: BorderSide(color: AppColors.inactive),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              size.width * 0.03,
                            ),
                            borderSide: BorderSide(color: AppColors.inactive),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              size.width * 0.03,
                            ),
                            borderSide: BorderSide(
                              color: AppColors.blue,
                              width: size.width * 0.002,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.025),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlocBuilder<HomeCubit, HomeState>(
                            builder: (context, state) {
                              if (state is UserSearchLoadedState &&
                                  searchController.text.isNotEmpty) {
                                return InAppText(
                                  text:
                                      '${state.users.length} Mentor${state.users.length != 1 ? 's' : ''} Found',

                                  fontweight: FontWeight.w600,
                                  size: 20,
                                );
                              }
                              return InAppText(
                                text: 'Suggested Mentors',
                                fontweight: FontWeight.w600,
                                size: 20,
                              );
                            },
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              Routename.allMentors,
                            ),
                            child: const InAppText(text: 'View All', size: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        if (state is UserSearchLoadingState) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(size.height * 0.05),
                              child: LoadingAnimationWidget.dotsTriangle(
                                size: 70.sp,
                                color: AppColors.background,
                              ),
                            ),
                          );
                        }
                        if (state is UserSearchLoadedState) {
                          if (state.users.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(size.height * 0.05),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 70.sp,
                                      color: AppColors.grey.withAlpha(50),
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                    InAppText(
                                      text: "No mentors found",
                                      size: 20,
                                      fontweight: FontWeight.w600,
                                      color: AppColors.lightblack,
                                    ),
                                    InAppText(
                                      text: "Try a different search term",

                                      color: AppColors.lightblack,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          final displayMentors = state.users.take(5).toList();

                          return Column(
                            children: displayMentors.map((mentor) {
                              return MentorList(
                                size: size,
                                mentorId: mentor.id ?? "0",
                                mentorName: mentor.name ?? "rey",
                                rating: mentor.rating.toString(),
                                expertise: mentor.expertise ?? "Expertise",
                                yoe: mentor.yearsOfExperience.toString(),
                              );
                            }).toList(),
                          );
                        }
                        return Column(
                          children: List.generate(
                            5,
                            (index) => MentorList(
                              size: size,
                              mentorId: 'mentor$index',
                              mentorName: 'Mentor Name $index',
                              rating: '4.5',
                              expertise: 'Expertise $index',
                              yoe: 'YOE $index',
                            ),
                          ),
                        );
                      },
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
