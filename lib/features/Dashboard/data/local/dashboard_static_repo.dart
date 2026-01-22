import 'package:flutter/material.dart';

class DashboardStaticRepo {
  static List<DashboardStatModel> stats = [
    DashboardStatModel(stat: '8', title: 'Goals Created'),
    DashboardStatModel(stat: '25', title: 'Completed'),
    DashboardStatModel(stat: '168', title: 'Hours Together'),
    DashboardStatModel(stat: '6', title: 'Skills gained'),
  ];
  static final List<MentorStat> mentorStats = [
  MentorStat(
    icon: Icons.people,
    count: 8,
    label: 'Active Mentees',
    color: Color(0xFF6C5CE7), 
    flex: 2, 
  ),
  MentorStat(
    icon: Icons.calendar_today,
    count: 12,
    label: 'Sessions',
    color: Color(0xFF00B894), 
    flex: 1,
  ),
  MentorStat(
    icon: Icons.star,
    count: 4,
    label: 'Reviews',
    color: Color(0xFFFD79A8), 
    flex: 1,
  ),
  MentorStat(
    icon: Icons.trending_up,
    count: 95,
    label: 'Success Rate',
    color: Color(0xFF0984E3), 
    flex: 2, 
  ),
];

}

class DashboardStatModel {
  final String title, stat;

  DashboardStatModel({required this.stat, required this.title});
}

class MentorStat {
  final IconData icon;
  final int count;
  final String label;
  final Color color;
  final int flex; 

  MentorStat({
    required this.icon,
    required this.count,
    required this.label,
    required this.color,
    this.flex = 1,
  });
}