
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Goal/pages/widgets/add_goal_widget.dart';
import 'package:mistakes/global%20widgets/export.dart';

class EditMentorProfile extends StatelessWidget {
  const EditMentorProfile({super.key});
  void showImagePicker(BuildContext context) {
    final readAuthCubit = context.read<AuthenticationCubit>();
    final size = MediaQuery.sizeOf(context);

    showModalBottomSheet(
      backgroundColor: AppColors.white,
      barrierColor: Colors.transparent,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      builder: (BuildContext sheetContext) {
        return Container(
          color: AppColors.white,
          padding: EdgeInsets.all(size.width * 0.04),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.blue),
                title: InAppText(
                  text: 'Take Photo',
                  size: 18,
                  color: AppColors.blue,
                ),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await Future.delayed(Duration(milliseconds: 300));
                  if (context.mounted) {
                    await readAuthCubit.pickImage(context, ImageSource.camera);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: AppColors.blue),
                title: InAppText(
                  text: 'Choose from Gallery',
                  size: 18,
                  color: AppColors.lightblack,
                ),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await Future.delayed(Duration(milliseconds: 300));
                  if (context.mounted) {
                    await readAuthCubit.pickImage(context, ImageSource.gallery);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchAuthCubit = context.watch<AuthenticationCubit>();

    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthProfileUpdatedState) {
          Fluttertoast.showToast(
            msg: "Profile updated successfully!",
            gravity: ToastGravity.TOP,
            backgroundColor: AppColors.success,
          );
          Navigator.pop(context);
        }
        if (state is AuthErrorState) {
          Fluttertoast.showToast(
            msg: "Failed to update profile",
            gravity: ToastGravity.TOP,
            backgroundColor: AppColors.errorColor,
          );
        }
      },
      child: AppScaffold(
        body: Column(
          children: [
            AppbarWidget(
              title: 'Edit Profile',
              size: size,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.03),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: size.width * 0.3,
                          height: size.width * 0.3,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.grey.withAlpha(50),
                                blurRadius: 15,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white,
                            ),
                            child: Center(
                              child: watchAuthCubit.profileImage != null
                                  ? ClipOval(
                                      child: Image.file(
                                        watchAuthCubit.profileImage!,
                                        width: size.width * 0.3,
                                        height: size.width * 0.3,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : InAppText(
                                      text: watchAuthCubit.getInitials(),
                                      color: AppColors.blue,
                                      size: 40.sp,
                                      fontweight: FontWeight.w600,
                                    ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 5,
                          child: GestureDetector(
                            onTap: () => showImagePicker(context),
                            child: Container(
                              padding: EdgeInsets.all(size.width * 0.02),
                              decoration: BoxDecoration(
                                color: AppColors.blue,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.blue.withAlpha(100),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: AppColors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.025),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: 'Expertise',
                            style: GoogleFonts.ptSans(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blue,
                            ),
                            children: [
                              TextSpan(
                                text: '*',
                                style: GoogleFonts.ptSans(
                                  color: AppColors.errorColor,
                                  fontSize: 20.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.012),
                        AppshadowContainer(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.04,
                            vertical: size.height * 0.005,
                          ),
                          color: AppColors.white,
                          child: ApptextField(
                            hintText: "e.g., Senior Software Engineer",
                            controller: watchAuthCubit.expertiseController,
                            prefixIconn: Icon(
                              Icons.work_outline,
                              color: AppColors.blue,
                              size: 20,
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.015),
                        Text.rich(
                          TextSpan(
                            text: 'About',
                            style: GoogleFonts.ptSans(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blue,
                            ),
                            children: [
                              TextSpan(
                                text: '*',
                                style: GoogleFonts.ptSans(
                                  color: AppColors.errorColor,
                                  fontSize: 20.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppshadowContainer(
                          padding: EdgeInsets.all(size.width * 0.04),
                          color: AppColors.white,
                          child: ApptextField(
                            controller: watchAuthCubit.bioController,
                            maxLine: 5,
                            hintText: "Tell others about yourself...",
                          ),
                        ),
                        SizedBox(height: size.height * 0.015),
                        InAppText(
                          text: "Years of Experience",
                          size: 20,
                          fontweight: FontWeight.w600,
                          color: AppColors.blue,
                        ),
                        SizedBox(height: size.height * 0.012),
                        AppshadowContainer(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.04,
                            vertical: size.height * 0.005,
                          ),
                          color: AppColors.white,
                          child: ApptextField(
                            keyboardType: TextInputType.number,
                            controller:
                                watchAuthCubit.yearsOfExperienceController,
                            hintText: "e.g., 5",

                            prefixIconn: Icon(
                              Icons.calendar_today_outlined,
                              color: AppColors.blue,
                              size: 20,
                            ),
                          ),
                        ),

                        SizedBox(height: size.height * 0.035),
                        InfoBar(
                          size: size,
                          icon: Icons.info_outline,
                          text:
                              "A complete profile helps mentees find and connect with you more easily..Make sure to save your changes.",
                        ),
                        SizedBox(height: size.height * 0.03),
                        AppButton(
                          isLoading: watchAuthCubit.state is AuthLoadingState,
                          onTap: () {
                            final readAuthCubit = context
                                .read<AuthenticationCubit>()
                                .updateProfileDetails();
                            Future.delayed(Duration(milliseconds: 300), () {
                              readAuthCubit;
                            });
                          },
                          width: size.width,
                          buttonColor: AppColors.blue,
                          label: 'Save Changes',
                          textSize: 20,
                        ),
                        SizedBox(height: size.height * 0.015),
                        AppButton(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          width: size.width,
                          bordercolor: AppColors.errorColor,
                          label: 'Cancel',
                          labelColor: AppColors.errorColor,
                          buttonColor: Colors.transparent,
                          textSize: 20,
                        ),

                        SizedBox(height: size.height * 0.03),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
