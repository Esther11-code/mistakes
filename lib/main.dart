import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/page%20route/page_route.dart';
import 'package:mistakes/features/Authentication/data/remote/auth_repo.dart';
import 'package:mistakes/features/Bookmark/cubit/bookmark_cubit.dart';
import 'package:mistakes/features/Bookmark/data/remote/bookmark_repo.dart';
import 'package:mistakes/features/Chat/data/chat_repo.dart';
import 'package:mistakes/features/Chat/presentation/cubit/chat_cubit.dart';
import 'package:mistakes/features/Dashboard/data/local/remote/dash_repo.dart';
import 'package:mistakes/features/Dashboard/pages/cubit/dashboard_cubit.dart';
import 'package:mistakes/features/Goal/data/domain/goal_repo.dart';
import 'package:mistakes/features/Home/data/remote/home_repo.dart';
import 'package:mistakes/features/Home/presentation/cubit/home_cubit.dart';
import 'package:mistakes/features/Notification/data/remote/notification_repo.dart';
import 'package:mistakes/features/Notification/presentation/cubit/notification_cubit.dart';
import 'package:mistakes/features/Onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:mistakes/features/Profile/data/remote/match_repo.dart';
import 'package:mistakes/features/Profile/data/remote/mentor_repo.dart';
import 'package:mistakes/features/Profile/presentation/cubit/mentor_cubit.dart';
import 'package:mistakes/features/Profile/presentation/cubit/profile_cubit.dart';
import 'package:mistakes/features/Rating&Reviews/data/repo/feedback_repo.dart';
import 'package:mistakes/features/Rating&Reviews/pages/cubit/review_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'features/Goal/pages/cubit/goal_cubit.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// The main entry point of the application. Ensures that the
/// [WidgetsFlutterBinding] is initialized and then runs the
/// [MyApp] widget.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://ivdufdbrhvjixmyfaabt.supabase.co',
    anonKey: 'sb_publishable_DxFSSj5dvwtJCyY3u1kFBA_3Lxb3mKc',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
    realtimeClientOptions: const RealtimeClientOptions(
      logLevel: RealtimeLogLevel.info,
    ),
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  late AppLinks appLinks;

  @override
  void initState() {
    super.initState();
    setupAuthListener(); // This is the key!
    initDeepLinks();
  }

  void setupAuthListener() {
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      log(' Auth event: $event');

      // This triggers when user clicks the email link
      if (event == AuthChangeEvent.passwordRecovery) {
        log('🔑 Password recovery event detected!');
        log('🔑 Session: ${data.session?.accessToken}');

        // Give a small delay to ensure navigation context is ready
        Future.delayed(const Duration(milliseconds: 500), () {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            Routename.changePassword,
            (route) => false,
          );
        });
      }
    });
  }

  Future<void> initDeepLinks() async {
    appLinks = AppLinks();

    appLinks.uriLinkStream.listen((uri) {
      log('📱 Deep link received: $uri');
      _handleDeepLink(uri);
    });

    try {
      final uri = await appLinks.getInitialLink();
      if (uri != null) {
        log('📱 Initial link: $uri');
        // Delay to ensure app is fully initialized
        Future.delayed(const Duration(seconds: 1), () {
          _handleDeepLink(uri);
        });
      }
    } catch (err) {
      log(' Initial link error: $err');
    }
  }

  void _handleDeepLink(Uri uri) {
    log('🔗 Handling deep link: $uri');
    log('🔗 Fragment: ${uri.fragment}');

    if (uri.host == 'reset-password' || uri.path.contains('reset-password')) {
      log('Navigating to reset password');
      Future.delayed(const Duration(milliseconds: 500), () {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          Routename.changePassword,
          (route) => false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => OnboardingCubit()),
        BlocProvider(create: (context) => AuthenticationCubit(AuthRepo())),
        BlocProvider(create: (context) => GoalCubit(GoalRepo())),
        BlocProvider(create: (context) => ProfileCubit(MatchesRepo())),
        BlocProvider(create: (context) => ChatCubit(ChatRepo())),
        BlocProvider(create: (context) => HomeCubit(HomeRepo())),
        BlocProvider(create: (context) => DashboardCubit(DashboardRepo())),
        BlocProvider(create: (context) => ReviewCubit(FeedbackRepo())),
        BlocProvider(create: (context) => BookmarksCubit(BookmarkRepo())),
        BlocProvider(create: (context) => MentorCubit(MentorRepo())),
        BlocProvider(create: (context) => NotificationCubit(NotificationRepo())),
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
              setupAuthListener();
              initDeepLinks();
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
