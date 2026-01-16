import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mistakes/features/Home/presentation/cubit/home_cubit.dart';

import 'package:mistakes/features/Home/presentation/widgets/src/home_appbar.dart';
import 'package:mistakes/features/Profile/presentation/cubit/mentor_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';
import '../../../../../constants/utils/app_colors.dart';
import '../../../../Dashboard/data/local/dashboard_static_repo.dart';

class MentorHome extends StatefulWidget {
  const MentorHome({super.key});

  @override
  State<MentorHome> createState() => _MentorHomeState();
}

class _MentorHomeState extends State<MentorHome> {
  @override
  void initState() {
    super.initState();
    // Load mentor data when page loads
    final mentorCubit = context.read<MentorCubit>();
    final userId = context.read<HomeCubit>().user.id;
    
    if (userId != null) {
      mentorCubit.loadMentorDashboard(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    
    return BlocBuilder<MentorCubit, MentorState>(
      builder: (context, state) {
        final cubit = context.read<MentorCubit>();
        
        if (state is MentorLoadingState && cubit.stats.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        
        return AppScaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeAppbar(size: size),
              SizedBox(height: size.height * 0.025),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // STATS GRID (now with real data)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: size.width * 0.04,
                          mainAxisSpacing: size.height * 0.02,
                          childAspectRatio: 1,
                        ),
                        itemCount: _buildStatsList(cubit.stats).length,
                        itemBuilder: (context, index) {
                          return StatCard(
                            stat: _buildStatsList(cubit.stats)[index],
                            size: size,
                          );
                        },
                      ),
                      
                      SizedBox(height: size.height * 0.03),
                      
                      // RECENT ACTIVITIES
                      InAppText(
                        text: "Recent Activities",
                        size: 21,
                        fontweight: FontWeight.w700,
                      ),
                      SizedBox(height: size.height * 0.02),
                      
                      if (cubit.recentActivities.isEmpty)
                        _buildEmptyState("No recent activities"),
                      
                      ...cubit.recentActivities.map((activity) {
                        return _buildActivityCard(activity, size);
                      }),
                      
                      SizedBox(height: size.height * 0.03),
                      
                      // THIS WEEK'S TASKS
                      InAppText(
                        text: "This Week's Tasks",
                        size: 21,
                        fontweight: FontWeight.w700,
                      ),
                      SizedBox(height: size.height * 0.02),
                      
                      if (cubit.thisWeeksTasks.isEmpty)
                        _buildEmptyState("No tasks this week"),
                      
                      ...cubit.thisWeeksTasks.map((task) {
                        return _buildTaskCard(task, size);
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper to build stats list
  List<MentorStat> _buildStatsList(Map<String, int> stats) {
    return [
      MentorStat(
        count: stats['activeMentees'] ?? 0,
        label: 'Active Mentees',
        icon: Icons.people,
        color: Colors.blue,
      ),
      MentorStat(
        count: stats['pendingRequests'] ?? 0,
        label: 'Pending Requests',
        icon: Icons.pending_actions,
        color: Colors.orange,
      ),
      MentorStat(
        count: stats['completedMentorships'] ?? 0,
        label: 'Completed',
        icon: Icons.check_circle,
        color: Colors.green,
      ),
      MentorStat(
        count: stats['totalHours'] ?? 0,
        label: 'Total Hours',
        icon: Icons.schedule,
        color: Colors.purple,
      ),
    ];
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: InAppText(
          text: message,
          color: AppColors.grey,
        ),
      ),
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity, Size size) {
    // Implement based on your activity structure
    return AppshadowContainer(
      // ... your existing activity card design
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task, Size size) {
    // Implement based on your task structure
    return AppshadowContainer(
      // ... your existing task card design
    );
  }
}
class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.stat, required this.size});

  final MentorStat stat;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [stat.color, stat.color.withAlpha(70)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: stat.color.withAlpha(40),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(size.width * 0.025),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(stat.icon, color: Colors.white, size: 28),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InAppText(
                  text: '${stat.count}',
                  size: 32,
                  fontweight: FontWeight.bold,
                  color: Colors.white,
                  height: 1,
                ),
                SizedBox(height: size.height * 0.005),
                InAppText(
                  text: stat.label,
                  size: 14,
                  fontweight: FontWeight.w500,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
