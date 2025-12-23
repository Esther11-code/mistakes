import 'package:flutter/material.dart';
import 'package:mistakes/config/detail/custom_page_route.dart';
import 'package:mistakes/features/Chat/presentation/pages/chat_setup.dart';
import 'package:mistakes/features/Chat/presentation/pages/mentee/chat.dart';
import 'package:mistakes/features/Dashboard/pages/mentee/mentee_dashboard.dart';
import 'package:mistakes/features/Goal/pages/Goals/add_goal.dart';
import 'package:mistakes/features/Goal/pages/Goals/goal_setup.dart';
import 'package:mistakes/features/Home/presentation/pages/booking_success.dart';
import 'package:mistakes/features/Home/presentation/pages/bottom_nav.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mistakes/features/Home/presentation/cubit/home_cubit.dart';
import 'package:mistakes/features/Home/presentation/pages/home_setup.dart';
import 'package:mistakes/features/Onboarding/presentation/pages/splashscreen.dart';
import 'package:mistakes/features/Profile/presentation/pages/Profiles/Mentee/mentee_account.dart';
import 'package:mistakes/features/Profile/presentation/pages/Profiles/Mentor/all_mentor.dart';
import 'package:mistakes/features/Profile/presentation/pages/Profiles/Mentor/mentor_account.dart';
import 'package:mistakes/features/Profile/presentation/pages/Profiles/Mentor/mentor_details.dart';
import 'package:mistakes/features/Profile/presentation/pages/profile.dart';
import 'package:mistakes/features/Rating&Reviews/pages/all_reviews.dart';
import '../../features/Authentication/presentation/pages/change_password.dart';
import '../../features/Authentication/presentation/pages/login.dart';
import '../../features/Authentication/presentation/pages/login_success.dart';
import '../../features/Authentication/presentation/pages/signup.dart';
import '../../features/Bookmark/pages/bookmark.dart';
import '../../features/Dashboard/pages/dashboard_setup.dart';
import '../../features/Dashboard/pages/mentor/mentor_dashboard.dart';
import '../../features/Goal/pages/Goals/progress.dart';
import '../../features/Goal/pages/edit_interests.dart';
import '../../features/Goal/pages/select_interest.dart';
import '../../features/Home/presentation/pages/home.dart';
import '../../features/Home/presentation/pages/requests/mentee/my_request.dart';
import '../../features/Home/presentation/pages/requests/mentee/request_mentorship.dart';
import '../../features/Notification/presentation/pages/notification.dart';
import '../../features/Onboarding/presentation/pages/onboarding_one.dart';
import '../../features/Onboarding/presentation/pages/onboarding_three.dart';
import '../../features/Onboarding/presentation/pages/onboarding_two.dart';
import '../../features/Onboarding/presentation/pages/welcome.dart';
import 'route_name.dart';

class AppRoute {
  static Route onGeneratedRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routename.splashScreen:
        return CustomPageRoute(
          child: const Splashscreen(),
          duration: 500,
          direction: AxisDirection.left,
        );
      case Routename.onboardingOne:
        return CustomPageRoute(
          child: const OnboardingOne(),
          duration: 500,
          direction: AxisDirection.left,
        );
      case Routename.onboardingTwo:
        return CustomPageRoute(
          child: const OnboardingTwo(),
          duration: 500,
          direction: AxisDirection.left,
        );
      case Routename.onboardingThree:
        return CustomPageRoute(
          child: const OnboardingThree(),
          duration: 500,
          direction: AxisDirection.left,
        );
      case Routename.welcome:
        return CustomPageRoute(
          child: const WelcomePage(),
          duration: 500,
          direction: AxisDirection.left,
        );
      case Routename.loginSuccess:
        return CustomPageRoute(child: const LoginSuccessPage());
      case Routename.home:
        return CustomPageRoute(child: const Home());
      case Routename.login:
        return CustomPageRoute(child: const LoginPage());
      case Routename.signup:
        return CustomPageRoute(child: const SignupPage());
      case Routename.notification:
        return CustomPageRoute(child: const NotificationPage());
      case Routename.goalSetUp:
        return CustomPageRoute(child: const GoalSetup());
      case Routename.chat:
        return CustomPageRoute(child: const MenteeChatPage(userName: 'Esther'));
      case Routename.profileSetup:
        return CustomPageRoute(child: const ProfileSetUp());
      case Routename.chatSetup:
        return CustomPageRoute(child: const ChatSetup());
      case Routename.dashboardSetup:
        return CustomPageRoute(child: const DashboardSetup());
      case Routename.homeSetup:
        return CustomPageRoute(child: const HomeSetup());

      case Routename.menteeAccount:
        return CustomPageRoute(child: const MenteeAccount());
      case Routename.mentorAccount:
        return CustomPageRoute(child: const MentorAccount());
      case Routename.allMentors:
        return CustomPageRoute(child: const AllMentor());
      case Routename.mentorDetails:
        return CustomPageRoute(child: const MentorDetails());
      case Routename.bookingSuccess:
        return CustomPageRoute(child: const BookingSuccess());
      case Routename.allReviews:
        return CustomPageRoute(child: const AllReviews());
      case Routename.requestMentorship:
        return CustomPageRoute(child: const RequestMentorship());
      case Routename.myRequests:
        return CustomPageRoute(child: const MyRequest());
      case Routename.menteeDashboard:
        return CustomPageRoute(child: const MenteeDashboard());
      case Routename.mentorDashboard:
        return CustomPageRoute(child: const MentorDashboard());

      case Routename.bookmark:
        return CustomPageRoute(child: const Bookmark());
      case Routename.progressDashboard:
        return CustomPageRoute(child: const ProgressDashboard());
      case Routename.addGoal:
        return CustomPageRoute(child: const AddGoal());
      case Routename.changePassword:
        return CustomPageRoute(child: const ChangePassword());
      case Routename.selectInterest:
        return CustomPageRoute(child: const SelectInterest());
      case Routename.editInterests:
        return CustomPageRoute(child: const EditInterests());
      case Routename.bottomNav:
        return CustomPageRoute(
          child: BlocProvider(
            create: (_) => HomeCubit(),
            child: const BottomNav(),
          ),
        );
      default:
        return CustomPageRoute(child: const LoginPage());
    }
  }
}
