import 'package:flutter/material.dart';



class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  final AxisDirection direction;
   final int? duration;

  CustomPageRoute({
    required this.child,
    this.direction = AxisDirection.right,
    this.duration,
  }) : super(
          transitionDuration: Duration(milliseconds: duration??20),
          reverseTransitionDuration:  Duration(milliseconds:duration?? 20),
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
   
    return SlideTransition(
      position: animation.drive(Tween<Offset>(begin: begin, end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut))),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
  Offset get begin {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0, 1);
      case AxisDirection.down:
        return const Offset(0, -1);
      case AxisDirection.left:
        return const Offset(1, 0);
      case AxisDirection.right:
        return const Offset(-1, 0);
    }
  }
}

