import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/features/Home/data/local/home_static_repo.dart';
import 'package:mistakes/features/Home/presentation/cubit/home_cubit.dart';

import '../../../../constants/utils/app_colors.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final watchHome = context.watch<HomeCubit>();
    final readHome = context.read<HomeCubit>();
    final index = watchHome.bottonnavSelectedIndex;
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: watchHome.screens[index],
      extendBody: true,
      bottomNavigationBar:
          //  index == 3 || index == 2
          //     ? null
          //     :
          Theme(
            data: Theme.of(context).copyWith(
              iconTheme: IconThemeData(
                color: AppColors.background,
                size: 25.sp,
              ),
            ),
            child: Container(
              // Add a subtle shadow above the navigation bar.
              decoration: BoxDecoration(
                color: Colors.transparent,
                // borderRadius: const BorderRadius.only(
                //   topLeft: Radius.circular(24.0),
                //   topRight: Radius.circular(24.0),
                // ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lightgrey.withAlpha(100),
                    blurRadius: 8.0,
                    spreadRadius: 1.0,
                    offset: const Offset(0, -4), // shadow above the bar
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: CurvedNavigationBar(
                  items: HomeStaticRepo.bottomNavItems
                      .map((item) => Icon(item.icon))
                      .toList(),
                  height: size.height * 0.075,
                  backgroundColor: AppColors.background,
                  color: AppColors.white,
                  index: index,
                  onTap: (index) {
                    readHome.changebottomnavindex(index: index);
                  },
                ),
              ),
            ),
          ),
    );
  }
}
