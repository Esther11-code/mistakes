import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Goal/pages/Goals/add_goal.dart';
import 'package:mistakes/global%20widgets/export.dart';

class AddDetails extends StatelessWidget {
  const AddDetails({super.key});

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
    final readAuthCubit = context.read<AuthenticationCubit>();
    final watchAuthCubit = context.watch<AuthenticationCubit>();
    final formKey = GlobalKey<FormState>();
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AddDetailsError) {
          Fluttertoast.showToast(
            msg: "Failed to add details",
            gravity: ToastGravity.TOP,
            backgroundColor: AppColors.errorColor,
          );
        } else if (state is AddDetailsSuccess) {
          Navigator.pushNamed(context, Routename.bottomNav);
        } else if (state is AddDetailsSkipped) {
          Fluttertoast.showToast(
            msg: "Please you have to fill your details",
            gravity: ToastGravity.TOP,
            backgroundColor: AppColors.blue,
          );
        }
      },
      child: AppScaffold(
        body: Form(
          key: formKey,
          child: Column(
            children: [
              AppbarWidget(
                title: 'Complete Your Profile',
                size: size,
                onTap: () => Navigator.pop(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.03),

                      // Profile Picture Section
                      BlocBuilder<AuthenticationCubit, AuthenticationState>(
                        builder: (context, state) {
                          return Stack(
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
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.white,
                                  ),
                                  child: watchAuthCubit.profileImage != null
                                      ? ClipOval(
                                          child: Image.file(
                                            watchAuthCubit.profileImage!,
                                            width: size.width * 0.3,
                                            height: size.width * 0.3,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                            watchAuthCubit.getInitials(),
                                            style: GoogleFonts.ptSans(
                                              fontSize: 40.sp,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.blue,
                                            ),
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
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: AppColors.white,
                                      size: 20.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: size.height * 0.015),
                      InAppText(
                        text: "Upload your profile picture",
                        size: 16,
                        color: AppColors.grey,
                      ),
                      SizedBox(height: size.height * 0.03),

                      // Expertise Field
                      ExpertiseField(),
                      SizedBox(height: size.height * 0.015),

                      // YOE Field
                      YoeField(),
                      SizedBox(height: size.height * 0.015),

                      // Bio Field
                      BioField(),
                      SizedBox(height: size.height * 0.025),

                      // Age Confirmation Checkbox
                      BlocBuilder<AuthenticationCubit, AuthenticationState>(
                        builder: (context, state) {
                          return AppshadowContainer(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.04,
                              vertical: size.height * 0.02,
                            ),
                            color: AppColors.white,
                            child: Row(
                              children: [
                                AppCheckbox(
                                  status: watchAuthCubit.isAbove18,
                                  ontap: () =>
                                      readAuthCubit.toggleAgeConfirmation(),
                                ),
                                SizedBox(width: size.width * 0.03),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      text: 'I confirm that I am',
                                      style: GoogleFonts.ptSans(
                                        color: AppColors.lightblack,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: ' 18 years or older',
                                          style: GoogleFonts.ptSans(
                                            color: AppColors.blue,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: size.height * 0.035),

                      // Info Bar
                      InfoBar(
                        size: size,
                        icon: Icons.info_outline,
                        text:
                            "Complete your profile to get the best experience and connect with the right people.",
                      ),
                      SizedBox(height: size.height * 0.03),

                      // Continue Button
                      AppButton(
                        onTap: () => readAuthCubit.validateAndSubmit(context),
                        width: size.width,
                        buttonColor: AppColors.blue,
                        label: 'Continue',
                        textSize: 20,
                      ),
                      SizedBox(height: size.height * 0.015),

                      // Skip Button
                      AppButton(
                        onTap: () => readAuthCubit.skipDetails(),
                        width: size.width,
                        bordercolor: AppColors.grey,
                        label: 'Skip for now',
                        labelColor: AppColors.grey,
                        buttonColor: Colors.transparent,
                        textSize: 20,
                      ),
                      SizedBox(height: size.height * 0.03),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpertiseField extends StatelessWidget {
  const ExpertiseField({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final watchAuthCubit = context.watch<AuthenticationCubit>();
    return Column(
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
        SizedBox(height: size.height * 0.01),
        AppshadowContainer(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
            vertical: size.height * 0.005,
          ),
          color: AppColors.white,
          child: ApptextField(
            controller: watchAuthCubit.expertiseController,
            hintText: "e.g., Senior Software Engineer",
            prefixIconn: Icon(
              Icons.work_outline,
              color: AppColors.blue,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class BioField extends StatelessWidget {
  const BioField({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final watchAuthCubit = context.watch<AuthenticationCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: 'Bio',
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
        SizedBox(height: size.height * 0.01),
        AppshadowContainer(
          padding: EdgeInsets.all(size.width * 0.04),
          color: AppColors.white,
          child: ApptextField(
            controller: watchAuthCubit.bioController,
            maxLine: 5,
            hintText: "Tell us about yourself...",
          ),
        ),
      ],
    );
  }
}

class YoeField extends StatelessWidget {
  const YoeField({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final watchAuthCubit = context.watch<AuthenticationCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: 'Years of Experience',
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
            controller: watchAuthCubit.yearsOfExperienceController,
            hintText: "What is your years of experience?",
          ),
        ),
      ],
    );
  }
}
