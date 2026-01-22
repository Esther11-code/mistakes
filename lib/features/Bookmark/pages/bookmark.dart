import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Bookmark/pages/cubit/bookmark_cubit.dart';
import 'package:mistakes/features/Bookmark/pages/widgets/bookmark_widgets.dart';
import 'package:mistakes/global%20widgets/export.dart';
import '../../../../constants/utils/app_colors.dart';

class Bookmark extends StatefulWidget {
  const Bookmark({super.key});

  @override
  State<Bookmark> createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  void _loadBookmarks() {
    final userId = context.read<AuthenticationCubit>().user.id;
    if (userId != null) {
      context.read<BookmarksCubit>().loadAllBookmarks(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchBookmarksCubit = context.watch<BookmarksCubit>();
    final readBookmarksCubit = context.read<BookmarksCubit>();

    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(
            title: 'Saved Items',
            size: size,
            onTap: () => Navigator.pop(context),
          ),
          SizedBox(height: size.height * 0.02),
          AppshadowContainer(
            border: true,
            borderColor: AppColors.filledColor,
            color: Colors.transparent,
            width: size.width * 0.92,
            padding: EdgeInsets.all(4),
            child: Row(
              children: List.generate(
                watchBookmarksCubit.bookmarkTabs.length,
                (int index) => Expanded(
                  child: AppshadowContainer(
                    color: watchBookmarksCubit.selectedTabIndex == index
                        ? AppColors.filledColor
                        : Colors.transparent,
                    onTap: () => readBookmarksCubit.changeTab(index),
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.015,
                      horizontal: size.width * 0.02,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InAppText(
                            text: watchBookmarksCubit.bookmarkTabs[index],
                            color: watchBookmarksCubit.selectedTabIndex == index
                                ? AppColors.white
                                : AppColors.grey,
                            fontweight: FontWeight.w600,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: size.height * 0.02),
          Expanded(
            child: BlocConsumer<BookmarksCubit, BookmarksState>(
              listener: (context, state) {
                if (state is MentorBookmarkRemovedState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Mentor removed from favorites'),
                      backgroundColor: Colors.orange,
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else if (state is ResourceBookmarkRemovedState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Resource removed from favorites'),
                      backgroundColor: Colors.orange,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is BookmarksLoadingState) {
                  return Center(
                    child: LoadingAnimationWidget.hexagonDots(
                      color: AppColors.background,
                      size: 50.sp,
                    ),
                  );
                }
                if (watchBookmarksCubit.selectedTabIndex == 0) {
                  return BuildMentorsTab();
                } else {
                  return BuildResourcesTab();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
