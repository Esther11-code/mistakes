// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:mistakes/constants/utils/app_colors.dart';
// import 'package:mistakes/global%20widgets/export.dart';

// class ProgressDashboard extends StatelessWidget {
//   const ProgressDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.sizeOf(context);

//     return AppScaffold(
//       body: Column(
//         children: [
//           AppbarWidget(title: 'Progress Dashboard', size: size),
//           Expanded(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: size.height * 0.025),

//                   // Overall Progress Card
//                   Container(
//                     width: size.width,
//                     padding: EdgeInsets.all(size.width * 0.05),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [AppColors.blue, AppColors.filledColor],
//                       ),
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: AppColors.blue.withAlpha(80),
//                           blurRadius: 20,
//                           offset: Offset(0, 10),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         InAppText(
//                           text: "Overall Progress",
//                           size: 16,
//                           fontweight: FontWeight.w600,
//                           color: Colors.white.withOpacity(0.9),
//                         ),
//                         SizedBox(height: size.height * 0.02),
//                         Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             SizedBox(
//                               width: 150,
//                               height: 150,
//                               child: CircularProgressIndicator(
//                                 value: 0.75,
//                                 strokeWidth: 12,
//                                 backgroundColor: Colors.white.withOpacity(0.3),
//                                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                               ),
//                             ),
//                             Column(
//                               children: [
//                                 InAppText(
//                                   text: "75%",
//                                   size: 40,
//                                   fontweight: FontWeight.w900,
//                                   color: Colors.white,
//                                 ),
//                                 InAppText(
//                                   text: "Complete",
//                                   size: 14,
//                                   color: Colors.white.withOpacity(0.9),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: size.height * 0.02),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Column(
//                               children: [
//                                 InAppText(
//                                   text: "8/10",
//                                   size: 20,
//                                   fontweight: FontWeight.w700,
//                                   color: Colors.white,
//                                 ),
//                                 InAppText(
//                                   text: "Goals",
//                                   size: 13,
//                                   color: Colors.white.withOpacity(0.9),
//                                 ),
//                               ],
//                             ),
//                             Container(
//                               width: 1,
//                               height: 40,
//                               color: Colors.white.withOpacity(0.3),
//                             ),
//                             Column(
//                               children: [
//                                 InAppText(
//                                   text: "15",
//                                   size: 20,
//                                   fontweight: FontWeight.w700,
//                                   color: Colors.white,
//                                 ),
//                                 InAppText(
//                                   text: "Sessions",
//                                   size: 13,
//                                   color: Colors.white.withOpacity(0.9),
//                                 ),
//                               ],
//                             ),
//                             Container(
//                               width: 1,
//                               height: 40,
//                               color: Colors.white.withOpacity(0.3),
//                             ),
//                             Column(
//                               children: [
//                                 InAppText(
//                                   text: "45",
//                                   size: 20,
//                                   fontweight: FontWeight.w700,
//                                   color: Colors.white,
//                                 ),
//                                 InAppText(
//                                   text: "Days",
//                                   size: 13,
//                                   color: Colors.white.withOpacity(0.9),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),

//                   SizedBox(height: size.height * 0.03),

//                   // Goals Progress
//                   Row(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.green.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Icon(
//                           Icons.flag_outlined,
//                           color: Colors.green.shade600,
//                           size: 20,
//                         ),
//                       ),
//                       SizedBox(width: size.width * 0.03),
//                       InAppText(
//                         text: "Active Goals",
//                         size: 20,
//                         fontweight: FontWeight.w700,
//                         color: AppColors.blue,
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: size.height * 0.015),

//                   Column(
//                     children: List.generate(
//                       3,
//                       (index) => GoalProgressCard(
//                         goalName: index == 0
//                             ? "Master Flutter"
//                             : index == 1
//                                 ? "Learn System Design"
//                                 : "Improve Communication",
//                         progress: index == 0
//                             ? 0.8
//                             : index == 1
//                                 ? 0.6
//                                 : 0.4,
//                         color: index == 0
//                             ? Colors.blue.shade400
//                             : index == 1
//                                 ? Colors.purple.shade400
//                                 : Colors.orange.shade400,
//                         size: size,
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: size.height * 0.03),

//                   // Recent Activities
//                   Row(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: AppColors.orange.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Icon(
//                           Icons.history,
//                           color: AppColors.orange,
//                           size: 20,
//                         ),
//                       ),
//                       SizedBox(width: size.width * 0.03),
//                       InAppText(
//                         text: "Recent Activities",
//                         size: 20,
//                         fontweight: FontWeight.w700,
//                         color: AppColors.blue,
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: size.height * 0.015),

//                   Column(
//                     children: List.generate(
//                       4,
//                       (index) {
//                         final activities = [
//                           {'icon': Icons.check_circle, 'text': 'Completed Flutter module', 'time': '2h ago'},
//                           {'icon': Icons.book, 'text': 'Read System Design article', 'time': '5h ago'},
//                           {'icon': Icons.video_library, 'text': 'Watched tutorial video', 'time': '1d ago'},
//                           {'icon': Icons.chat, 'text': 'Had mentorship session', 'time': '2d ago'},
//                         ];
//                         return ActivityTile(
//                           icon: activities[index]['icon'] as IconData,
//                           text: activities[index]['text'] as String,
//                           time: activities[index]['time'] as String,
//                           size: size,
//                         );
//                       },
//                     ),
//                   ),

//                   SizedBox(height: size.height * 0.03),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Goal Progress Card
// class GoalProgressCard extends StatelessWidget {
//   final String goalName;
//   final double progress;
//   final Color color;
//   final Size size;

//   const GoalProgressCard({
//     super.key,
//     required this.goalName,
//     required this.progress,
//     required this.color,
//     required this.size,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AppshadowContainer(
//       margin: EdgeInsets.only(bottom: size.height * 0.015),
//       padding: EdgeInsets.all(size.width * 0.04),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: InAppText(
//                   text: goalName,
//                   size: 17,
//                   fontweight: FontWeight.w600,
//                   color: AppColors.blue,
//                 ),
//               ),
//               InAppText(
//                 text: "${(progress * 100).toInt()}%",
//                 size: 18,
//                 fontweight: FontWeight.w700,
//                 color: color,
//               ),
//             ],
//           ),
//           SizedBox(height: size.height * 0.012),
//           Container(
//             height: 10,
//             decoration: BoxDecoration(
//               color: AppColors.inactive,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Stack(
//               children: [
//                 FractionallySizedBox(
//                   widthFactor: progress,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [color, color.withOpacity(0.7)],
//                       ),
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: color.withOpacity(0.3),
//                           blurRadius: 8,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Activity Tile
// class ActivityTile extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   final String time;
//   final Size size;

//   const ActivityTile({
//     super.key,
//     required this.icon,
//     required this.text,
//     required this.time,
//     required this.size,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AppshadowContainer(
//       margin: EdgeInsets.only(bottom: size.height * 0.012),
//       padding: EdgeInsets.all(size.width * 0.04),
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: AppColors.blue.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(
//               icon,
//               color: AppColors.blue,
//               size: 20,
//             ),
//           ),
//           SizedBox(width: size.width * 0.03),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 InAppText(
//                   text: text,
//                   size: 15,
//                   fontweight: FontWeight.w500,
//                   color: AppColors.blue,
//                 ),
//                 SizedBox(height: 2),
//                 InAppText(
//                   text: time,
//                   size: 13,
//                   color: AppColors.grey,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }