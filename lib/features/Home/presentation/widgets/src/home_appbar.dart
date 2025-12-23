import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/features/Onboarding/data/images/images.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../../constants/utils/app_colors.dart';
import '../../../../../constants/utils/utils.dart';
import '../../../../Authentication/presentation/cubit/authentication_cubit.dart';
import '../../../data/local/images/home_image.dart';

import 'home_textfield.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
      child: Row(
        children: [
          AppshadowContainer(
            onTap: () {
              Navigator.pushNamed(context, Routename.menteeAccount);
            },
            radius: size.width * 0.075,
            shadowcolour: AppColors.inactive,
            child: AppNetwokImage(
              height: size.width * 0.12,
              fit: BoxFit.cover,
              width: size.width * 0.12,
              radius: size.width * 0.075,
              imageUrl: HomeImages.avatar,
            ),
          ),
          SizedBox(width: size.width * 0.03),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                color: AppColors.blue,
                text:
                    '${Utils.getGreting()}, ${context.watch<AuthenticationCubit>().user.name ?? "Dear User"}',
                fontweight: FontWeight.w700,
              ),
              AppText(
                text: 'Let\'s grow together!',
                size: 14,
                color: AppColors.blue,
              ),
            ],
          ),
          const Spacer(),
          NotificationIcon(colors: AppColors.background),
        ],
      ),
    );
  }
}

//
class HomeSearchField extends StatelessWidget {
  const HomeSearchField({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return HomeTextfield(
      // onChange: (value) {
      //   context
      //       .read<HomeCubit>()
      //       .searchCategories(value, HomeStaticRepo.services);
      // },
      size: size,
      prefixicon: Icon(Icons.search, size: 25.sp),
      hintext: 'Search...',
    );
  }
}

class HomeCarousel extends StatelessWidget {
  const HomeCarousel({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppshadowContainer(
          width: size.width,
          color: AppColors.background,
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.03),
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: size.width * 0.38,
                child: AppText(
                  maxline: 6,
                  text: 'Get the best services providers with our services',
                  color: AppColors.white,
                  fontweight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: size.width * 0.5,
                child: Image.asset(
                  OnboardingImages.onboarding1,
                  height: size.height * 0.18,
                ),
              ),
            ],
          ),
        ),
        10.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (index) => AppshadowContainer(
              border: index != 0,
              borderColor: AppColors.background,
              margin: EdgeInsets.only(right: size.width * 0.02),
              color: index == 0 ? AppColors.background : AppColors.inactive,
              width: index == 0 ? size.width * 0.15 : size.width * 0.04,
              height: size.width * 0.04,
            ),
          ),
        ),
      ],
    );
  }
}
