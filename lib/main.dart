import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/page%20route/page_route.dart';
import 'package:mistakes/features/Authentication/data/remote/auth_repo.dart';
import 'package:mistakes/features/Chat/presentation/cubit/chat_cubit.dart';
import 'package:mistakes/features/Home/presentation/cubit/home_cubit.dart';
import 'package:mistakes/features/Onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:mistakes/features/Profile/presentation/cubit/profile_cubit.dart';

import 'features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'features/Goal/pages/cubit/goal_cubit.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
/// The main entry point of the application. Ensures that the
/// [WidgetsFlutterBinding] is initialized and then runs the
/// [MyApp] widget.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => OnboardingCubit()),
      BlocProvider(create: (context) => AuthenticationCubit(AuthRepo())),
      BlocProvider(create: (context) => GoalCubit()),
      BlocProvider(create: (context) => ProfileCubit()),
      BlocProvider(create: (context) => ChatCubit()),
      BlocProvider(create: (context) => HomeCubit()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(370, 800),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            builder: (context, child) {
              final mediaQuery = MediaQuery.of(context);
              if (kDebugMode) {
                log("Width: ${mediaQuery.size.width}");
                log("Height: ${mediaQuery.size.height}");
                log("Device Pixel Ratio: ${mediaQuery.devicePixelRatio}");
                log("Text Scale Factor: ${mediaQuery.textScaler}");
              }
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(0.9)),
                child: child!,
              );
            },
            debugShowCheckedModeBanner: false,
            title: 'Mentor App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
              useMaterial3: true,
            ),
            initialRoute: Routename.splashScreen,
            onGenerateRoute: AppRoute.onGeneratedRoute,
            navigatorKey: navigatorKey,
          );
        },
      ),
    );
  }
}

