import 'package:flutter/material.dart';

class HomeStaticRepo {
  static List<BottomNavModel> bottomNavItems = [
    BottomNavModel(icon: Icons.home_filled, title: 'Home'),
    BottomNavModel(icon: Icons.favorite, title: 'Favorites'),
    BottomNavModel(icon: Icons.person, title: 'My mentor'),
    BottomNavModel(icon: Icons.chat, title: 'Chat'),
    BottomNavModel(icon: Icons.account_circle, title: 'Profile'),
  ];
  static List<BottomNavModel> mentorBottomNavItems = [
    BottomNavModel(icon: Icons.home_filled, title: 'Home'),
    BottomNavModel(icon: Icons.connect_without_contact, title: 'Requests'),
    BottomNavModel(icon: Icons.people, title: 'Mentees'),
    BottomNavModel(icon: Icons.chat, title: 'Chat'),
    BottomNavModel(icon: Icons.settings, title: 'Profile'),
  ];
}

class BottomNavModel {
  final String title;
  final IconData icon;
  BottomNavModel({required this.icon, required this.title});
}
