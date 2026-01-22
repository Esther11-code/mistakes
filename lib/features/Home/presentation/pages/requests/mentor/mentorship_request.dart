import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mistakes/features/Home/presentation/cubit/home_cubit.dart';
import 'package:mistakes/features/Profile/presentation/cubit/mentor_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';
import '../../../../../../constants/utils/app_colors.dart';
import '../../../widgets/mentorship_request_widgets.dart';

class MentorshipRequest extends StatefulWidget {
  const MentorshipRequest({super.key});

  @override
  State<MentorshipRequest> createState() => _MentorshipRequestState();
}

class _MentorshipRequestState extends State<MentorshipRequest> {
  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future<void> loadRequests() async {
    final mentorCubit = context.read<MentorCubit>();
    final userId = context.read<HomeCubit>().user.id;

    if (userId != null) {
      await mentorCubit.loadIncomingRequests(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(title: 'Mentorship Requests', size: size),
          SizedBox(height: size.height * 0.02),

          Expanded(
            child: BlocConsumer<MentorCubit, MentorState>(
              listener: (context, state) {
                if (state is MentorRequestAcceptedState) {
                  Fluttertoast.showToast(
                    msg: 'Request accepted successfully!',
                    backgroundColor: AppColors.success,
                  );
                } else if (state is MentorRequestDeclinedState) {
                  Fluttertoast.showToast(
                    msg: 'Request declined successfully!',
                    backgroundColor: AppColors.errorColor,
                  );
                } else if (state is MentorErrorState) {
                  Fluttertoast.showToast(
                    msg: "Failed to load requests",
                    backgroundColor: AppColors.errorColor,
                  );
                }
              },
              builder: (context, state) {
                final readMentorCubit = context.read<MentorCubit>();
                if (state is MentorLoadingState &&
                    readMentorCubit.incomingRequests.isEmpty) {
                  return Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: AppColors.background,
                      size: 50.sp,
                    ),
                  );
                }

                if (readMentorCubit.incomingRequests.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          size: 80.sp,
                          color: AppColors.blue.withAlpha(50),
                        ),
                        SizedBox(height: size.height * 0.02),
                        InAppText(
                          text: 'No Pending Requests',
                          size: 20,
                          fontweight: FontWeight.w600,
                          color: AppColors.blue,
                        ),
                        SizedBox(height: size.height * 0.01),
                        InAppText(
                          text: 'You don\'t have any mentorship requests yet',
                          size: 15,
                          color: AppColors.blue,
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: loadRequests,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: size.height * 0.02,
                            ),
                            child: Row(
                              children: [
                                InAppText(
                                  text:
                                      '${readMentorCubit.incomingRequests.length} Pending ${readMentorCubit.incomingRequests.length == 1 ? 'Request' : 'Requests'}',
                                  size: 16,
                                  fontweight: FontWeight.w600,
                                  color: AppColors.blue,
                                ),
                              ],
                            ),
                          ),

                          ...readMentorCubit.incomingRequests.map((request) {
                            return buildRequestCard(request, size, context);
                          }),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
