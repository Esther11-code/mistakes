import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mistakes/features/Onboarding/data/images/images.dart';

class AppNetwokImage extends StatelessWidget {
  const AppNetwokImage(
      {super.key,
      required this.height,
      required this.width,
      this.fit,
      required this.imageUrl,
      this.radius,
      this.title = ''});
  final double height, width;
  final BoxFit? fit;
  final String imageUrl, title;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return imageUrl == ''
        ? ClipRRect(
            borderRadius: BorderRadius.circular(radius ?? 0),
            child: Image.asset(OnboardingImages.onboarding1,
                width: width, height: height, fit: fit),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(radius ?? 0),
            child: CachedNetworkImage(
                width: width,
                height: height,
                fit: fit,
                imageUrl: imageUrl,
                placeholder: (context, url) => ClipRRect(
                      borderRadius: BorderRadius.circular(radius ?? 0),
                      child: Image.asset(OnboardingImages.onboarding1,
                          width: width, height: height, fit: BoxFit.contain),
                    ),
                errorWidget: (context, url, error) => ClipRRect(
                      borderRadius: BorderRadius.circular(radius ?? 0),
                      child: Image.asset(imageUrl,
                          width: width, height: height, fit: BoxFit.contain),
                    )),
          );
  }
}
