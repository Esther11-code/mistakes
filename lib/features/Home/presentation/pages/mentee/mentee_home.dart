import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          // Show error message if search fails
          if (state is UserSearchErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: AppColors.errorColor,
              ),
            );
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
                    10.verticalSpace,

                    // Search Field
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
                          labelStyle: TextStyle(
                            fontSize: 21.sp,
                            color: AppColors.blue,
                          ),
                          hintText: 'Example: Mentors, Years..',
                          hintStyle: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.grey,
                          ),
                          prefixIcon: Icon(Icons.search, color: AppColors.blue),
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
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.inactive),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.inactive),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.blue,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    10.verticalSpace,

                    // Header
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
                                  color: AppColors.blue,
                                  fontweight: FontWeight.w600,
                                  size: 20,
                                );
                              }
                              return InAppText(
                                text: 'Suggested Mentors',
                                color: AppColors.blue,
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
                    10.verticalSpace,

                    // Mentors List
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        if (state is UserSearchLoadingState) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(size.height * 0.05),
                              child: CircularProgressIndicator(
                                color: AppColors.blue,
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
                                      size: 60,
                                      color: AppColors.grey.withOpacity(0.5),
                                    ),
                                    SizedBox(height: 16),
                                    InAppText(
                                      text: "No mentors found",
                                      size: 18,
                                      fontweight: FontWeight.w600,
                                      color: AppColors.grey,
                                    ),
                                    SizedBox(height: 8),
                                    InAppText(
                                      text: "Try a different search term",
                                      size: 14,
                                      color: AppColors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          // Show only first 5 mentors
                          final displayMentors = state.users.take(5).toList();

                          return Column(
                            children: displayMentors.map((mentor) {
                              return MentorList(
                                size: size,
                                mentorId: mentor.id ?? "0",
                                mentorName: mentor.name ?? "rey",
                              );
                            }).toList(),
                          );
                        }

                        // Default fallback
                        return Column(
                          children: List.generate(
                            5,
                            (index) => MentorList(
                              size: size,
                              mentorId: 'mentor$index',
                              mentorName: 'Mentor Name $index',
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
