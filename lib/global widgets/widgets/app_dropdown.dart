import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/global%20widgets/widgets/app_text.dart';

import '../../constants/utils/app_colors.dart';
import 'app_textfield.dart';

class DropdownWidget extends StatefulWidget {
  const DropdownWidget({
    super.key,
    required this.hintText,
    required this.onSelected,
    required this.values,
    this.validator,
    this.height,
    required this.title,
    required this.prefixIcon,
  }) : assert(values.length > 0);

  final String hintText, title;
  final List<String> values;
  final void Function(String?)? onSelected;
  final String? Function(String?)? validator;
  final double? height;
  final IconData prefixIcon;

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  bool showDropDown = false;
  final FocusNode _focusNode = FocusNode(
    skipTraversal: true, // Skip keyboard navigation
    canRequestFocus: false, // Can't receive focus
  );

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late Size size = MediaQuery.sizeOf(context);
    
    return PopUpOverlay(
      visible: showDropDown,
      offset: Offset(0, 67.h),
      onClose: () {
        if (mounted) {
          setState(() => showDropDown = false);
        }
      },
      modal: Container(
        height: widget.height,
        width: size.width * 0.88,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.blackColor.withAlpha(0x40)),
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              widget.values.length,
              (index) => _DropdownTile(
                title: widget.values[index],
                onTap: () {
                  if (mounted) {
                    setState(() => showDropDown = false);
                  }
                  widget.onSelected?.call(widget.values[index]);
                },
              ),
            ),
          ),
        ),
      ),
      child: IgnorePointer( // Better than AbsorbPointer for this use case
        ignoring: false,
        child: GestureDetector(
          onTap: () {
            // Remove any keyboard focus first
            FocusScope.of(context).unfocus();
            
            if (mounted) {
              setState(() => showDropDown = !showDropDown);
            }
          },
          child: AbsorbPointer(
            child: ApptextField(
              focusNode: _focusNode,
              prefixIcon: widget.prefixIcon,
              title: widget.title,
              validator: widget.validator,
              hintText: widget.hintText,
              readOnly: true,
              sufixIcon: Icons.keyboard_arrow_down,
            ),
          ),
        ),
      ),
    );
  }
}

class _DropdownTile extends StatelessWidget {
  const _DropdownTile({
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    late Size size = MediaQuery.sizeOf(context);
    
    return InkWell( // Better than GestureDetector for material ripple
      onTap: onTap,
      child: SizedBox(
        width: size.width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: AppText(text: title),
        ),
      ),
    );
  }
}
class PopUpOverlay extends StatelessWidget {
  const PopUpOverlay({
    super.key,
    required this.visible,
    required this.onClose,
    required this.modal,
    required this.child,
    this.follower = Alignment.topLeft,
    this.target = Alignment.topLeft,
    this.offset = Offset.zero,
  });

  final Widget child;
  final Widget modal;
  final bool visible;
  final VoidCallback onClose;
  final Alignment follower;
  final Alignment target;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return Barrier(
      visible: visible,
      onClose: onClose,
      child: PortalTarget(
        anchor: Aligned(follower: follower, target: target, offset: offset),
        visible: visible,
        closeDuration: kThemeAnimationDuration,
        portalFollower: TweenAnimationBuilder<double>(
          duration: kThemeAnimationDuration,
          curve: Curves.easeOut,
          tween: Tween(begin: 0, end: visible ? 1 : 0),
          builder: (context, progress, child) {
            return Transform(
              transform: Matrix4.translationValues(0, (1 - progress) * 50, 0),
              child: Opacity(opacity: progress, child: child),
            );
          },
          child: modal,
        ),
        child: child,
      ),
    );
  }
}

class Barrier extends StatelessWidget {
  const Barrier({
    super.key,
    required this.onClose,
    required this.visible,
    required this.child,
  });

  final Widget child;
  final VoidCallback onClose;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: visible,
      closeDuration: kThemeAnimationDuration,
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onClose,
        child: TweenAnimationBuilder<Color>(
          duration: kThemeAnimationDuration,
          tween: ColorTween(begin: Colors.transparent, end: Colors.transparent),
          builder: (context, color, child) {
            return ColoredBox(color: color);
          },
        ),
      ),
      child: child,
    );
  }
}

/// Non-nullable version of ColorTween
class ColorTween extends Tween<Color> {
  ColorTween({required Color begin, required Color end})
    : super(begin: begin, end: end);

  @override
  Color lerp(double t) => Color.lerp(begin, end, t)!;
}
