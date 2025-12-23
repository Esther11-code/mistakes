import 'package:flutter/material.dart';
import 'package:mistakes/features/Home/presentation/pages/home.dart';
import 'package:mistakes/global%20widgets/export.dart';

class AllMentor extends StatelessWidget {
  const AllMentor({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(title: 'All Mentors', size: size),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(10, (index) => MentorList(size: size)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
