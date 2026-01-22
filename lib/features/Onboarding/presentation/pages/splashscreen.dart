import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Onboarding/data/images/images.dart';

import '../../../../config/detail/route_name.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  late final Animation<double> _globeScale;
  late final Animation<Offset> _globeSlide;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _textFade;
  late final Animation<double> _switchToRow; 

  @override
  void initState() {
    super.initState();

    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    _globeScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.85,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.2,
          end: 0.95,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.95,
          end: 1.1,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.1,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.3,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
    ]).animate(CurvedAnimation(parent: _c, curve: const Interval(0.0, 0.80)));

    _globeSlide =
        Tween<Offset>(
          begin: const Offset(0.9, 0.0),
          end: const Offset(-0.24, 0.04),
        ).animate(
          CurvedAnimation(
            parent: _c,
            curve: const Interval(0.55, 0.90, curve: Curves.easeInOut),
          ),
        );

    _textSlide =
        Tween<Offset>(
          begin: const Offset(-0.9, 0.0),
          end: const Offset(0.15, 0.0),
        ).animate(
          CurvedAnimation(
            parent: _c,
            curve: const Interval(0.60, 0.95, curve: Curves.easeOutCubic),
          ),
        );

    // Text fade in
    _textFade = CurvedAnimation(parent: _c, curve: const Interval(0.60, 0.95));

    _switchToRow = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.55, 0.60),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = context;
      final futures = <Future<void>>[
        precacheImage(const AssetImage(OnboardingImages.globe), ctx),
        precacheImage(const AssetImage(OnboardingImages.applogo), ctx),
      ];

      Future.wait(futures).then((_) {
        if (!mounted) return;
        _c.forward();
      });
    });

    _c.addStatusListener((s) {
      if (s == AnimationStatus.completed && mounted) {
        Navigator.of(context).pushReplacementNamed(Routename.onboardingOne);
      }
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
 
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, _) {
              final globeCenter = Transform.scale(
                scale: _globeScale.value,
                child: Image.asset(
                  OnboardingImages.globe,
                  width: size.width * 0.4,
                  height: size.width * 0.4,
                  filterQuality: FilterQuality.high,
                ),
              );
              final globeRow = SlideTransition(
                position: _globeSlide,
                child: Transform.scale(
                  scale: _globeScale.value,
                  child: Image.asset(
                    OnboardingImages.globe,
                    width: size.width * 0.32,
                    height: size.width * 0.32,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              );

              final textRow = FadeTransition(
                opacity: _textFade,
                child: SlideTransition(
                  position: _textSlide,
                  child: Image.asset(
                    OnboardingImages.applogo,
                    height: size.height * 0.28,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              );
              return Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(opacity: 1 - _switchToRow.value, child: globeCenter),
                  Opacity(
                    opacity: _switchToRow.value,
                    child: SizedBox(
                      width: size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          textRow,
                          SizedBox(width: size.width * 0.03),
                          globeRow,
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      // ),
    );
  }
}
