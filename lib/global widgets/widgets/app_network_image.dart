import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Home/data/local/images/home_image.dart';
import 'package:mistakes/features/Onboarding/data/images/images.dart';

class AppNetwokImage extends StatelessWidget {
  const AppNetwokImage({
    super.key,
    required this.height,
    required this.width,
    this.fit,
    required this.imageUrl,
    this.radius,
    this.title = '',
    this.isCircular = false,
  });

  final double height, width;
  final BoxFit? fit;
  final String imageUrl, title;
  final double? radius;
  final bool isCircular;

  @override
  Widget build(BuildContext context) {
    return imageUrl == ''
        ? ClipRRect(
            borderRadius: BorderRadius.circular(radius ?? 0),
            child: Image.asset(
              OnboardingImages.onboarding1,
              width: width,
              height: height,
              fit: fit,
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(
              isCircular ? width / 2 : (radius ?? 0),
            ),
            child: CachedNetworkImage(
              
              width: width,
              height: height,
              fit: fit ?? BoxFit.cover,
              imageUrl: imageUrl,
              placeholder: (context, url) => Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(
                    isCircular ? width / 2 : (radius ?? 0),
                  ),
                ),
                child: Center(
                  child: LoadingAnimationWidget.fallingDot(
                    color: AppColors.background,
                    size: 50.sp,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(
                    isCircular ? width / 2 : (radius ?? 0),
                  ),
                ),
                child: Image.asset(
                  HomeImages.avatar,
                  width: width,
                  height: height,
                  fit: fit,
                ),
              ),
            ),
          );
  }
}
