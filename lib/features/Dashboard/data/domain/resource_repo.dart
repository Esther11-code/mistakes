

import 'package:mistakes/features/Dashboard/data/local/model/shared_resource_model.dart';

class ResourceRepository {
  static final List<Map<String, dynamic>> _staticData = [
    {
      'id': '1',
      'title': 'Flutter State Management Guide',
      'type': 'Article',
      'mentorName': 'Sarah Johnson',
      'mentorId': 'mentor_1',
      'date': '2 days ago',
      'description': 'Complete guide to state management in Flutter using Cubit and Bloc',
      'link': 'https://example.com/flutter-state-management',
      'isBookmarked': false,
    },
    {
      'id': '2',
      'title': 'Advanced Dart Programming',
      'type': 'Video',
      'mentorName': 'Sarah Johnson',
      'mentorId': 'mentor_1',
      'date': '5 days ago',
      'description': 'Learn advanced Dart concepts and best practices',
      'link': 'https://youtube.com/watch?v=example',
      'isBookmarked': false,
    },
    {
      'id': '3',
      'title': 'The Complete Flutter Course',
      'type': 'Course',
      'mentorName': 'Sarah Johnson',
      'mentorId': 'mentor_1',
      'date': '1 week ago',
      'description': 'Build production-ready mobile apps with Flutter',
      'link': 'https://example.com/flutter-course',
      'isBookmarked': true,
    },
    {
      'id': '4',
      'title': 'Clean Architecture Book',
      'type': 'Book',
      'mentorName': 'Sarah Johnson',
      'mentorId': 'mentor_1',
      'date': '1 week ago',
      'description': 'A comprehensive guide to clean architecture principles',
      'link': 'https://example.com/clean-architecture',
      'isBookmarked': false,
    },
    {
      'id': '5',
      'title': 'E-commerce App Project',
      'type': 'Project',
      'mentorName': 'Sarah Johnson',
      'mentorId': 'mentor_1',
      'date': '2 weeks ago',
      'description': 'Full-stack e-commerce application with Flutter and Firebase',
      'link': 'https://github.com/example/ecommerce-app',
      'isBookmarked': false,
    },
    {
      'id': '6',
      'title': 'API Documentation',
      'type': 'Docs',
      'mentorName': 'Sarah Johnson',
      'mentorId': 'mentor_1',
      'date': '2 weeks ago',
      'description': 'RESTful API documentation and integration guide',
      'link': 'https://example.com/api-docs',
      'isBookmarked': false,
    },
  ];

  Future<List<ResourceModel>> getAllResources() async {
    await Future.delayed(Duration(seconds: 1));
    // TODO: Replace with API call
    return _staticData.map((data) => ResourceModel.fromJson(data)).toList();
  }

  Future<bool> toggleBookmark(String resourceId, bool currentStatus) async {
    await Future.delayed(Duration(milliseconds: 300));
    // TODO: Replace with API call
    return !currentStatus;
  }

  Map<String, int> getResourceCounts(List<ResourceModel> resources) {
    final counts = <String, int>{
      'All': resources.length,
      'Video': 0,
      'Article': 0,
      'Course': 0,
      'Book': 0,
      'Project': 0,
      'Docs': 0,
    };

    for (var resource in resources) {
      counts[resource.type] = (counts[resource.type] ?? 0) + 1;
    }

    return counts;
  }
}