import 'package:flutter/material.dart';
import 'package:mistakes/features/Home/presentation/pages/home.dart';
import 'package:mistakes/global%20widgets/export.dart';

class Bookmark extends StatelessWidget {
  const Bookmark({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(title: 'Saved Mentors', size: size),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: List.generate(
                      10,
                      (index) => MentorBookmarkContainer(size: size),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MentorBookmarkContainer extends StatelessWidget {
  const MentorBookmarkContainer({super.key, required this.size});
  final Size size;

  @override
  Widget build(BuildContext context) {
    return MentorList(size: size);
  }
}
