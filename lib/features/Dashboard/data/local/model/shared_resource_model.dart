import 'package:flutter/material.dart';

class ResourceModel {
  final String id;
  final String title;
  final String type;
  final String mentorName;
  final String mentorId;
  final String date;
  final String description;
  final String? link;
  final IconData icon;
  final Color color;
  final bool isBookmarked;

  ResourceModel({
    required this.id,
    required this.title,
    required this.type,
    required this.mentorName,
    required this.mentorId,
    required this.date,
    required this.description,
    this.link,
    required this.icon,
    required this.color,
    this.isBookmarked = false,
  });

  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      mentorName: json['mentorName'],
      mentorId: json['mentorId'],
      date: json['date'],
      description: json['description'],
      link: json['link'],
      icon: _getIconFromType(json['type']),
      color: _getColorFromType(json['type']),
      isBookmarked: json['isBookmarked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'mentorName': mentorName,
      'mentorId': mentorId,
      'date': date,
      'description': description,
      'link': link,
      'isBookmarked': isBookmarked,
    };
  }

  ResourceModel copyWith({
    String? id,
    String? title,
    String? type,
    String? mentorName,
    String? mentorId,
    String? date,
    String? description,
    String? link,
    IconData? icon,
    Color? color,
    bool? isBookmarked,
  }) {
    return ResourceModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      mentorName: mentorName ?? this.mentorName,
      mentorId: mentorId ?? this.mentorId,
      date: date ?? this.date,
      description: description ?? this.description,
      link: link ?? this.link,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  static IconData _getIconFromType(String type) {
    switch (type.toLowerCase()) {
      case 'video':
        return Icons.play_circle_outline;
      case 'article':
        return Icons.article_outlined;
      case 'course':
        return Icons.school_outlined;
      case 'book':
        return Icons.menu_book_outlined;
      case 'project':
        return Icons.folder_outlined;
      case 'docs':
        return Icons.description_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  static Color _getColorFromType(String type) {
    switch (type.toLowerCase()) {
      case 'video':
        return Colors.red.shade400;
      case 'article':
        return Colors.blue.shade400;
      case 'course':
        return Colors.purple.shade400;
      case 'book':
        return Colors.orange.shade400;
      case 'project':
        return Colors.green.shade400;
      case 'docs':
        return Colors.teal.shade400;
      default:
        return Colors.grey.shade400;
    }
  }
}