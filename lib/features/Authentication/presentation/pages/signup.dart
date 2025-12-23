import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/page%20route/page_route.dart';
import 'package:mistakes/constants/utils/toast_helper.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../constants/utils/app_colors.dart';
import '../../../../constants/utils/app_validation.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchAuthCubit = context.watch<AuthenticationCubit>();
    final readAuthCubit = context.read<AuthenticationCubit>();
    final formKey = GlobalKey<FormState>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.background,
              AppColors.blue,
              AppColors.active,
              // Color(0xFF003366), // Deep Blue
              // Color(0xFF00B8B0), // Teal accent
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        // 👇 Fill entire screen — under status & nav bars
        child: Scaffold(
          backgroundColor: Colors.transparent, // important!
          body: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                105.verticalSpace,
                Expanded(
                  child: Container(
                    height: size.height * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(size.width * 0.1),
                        topRight: Radius.circular(size.width * 0.1),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(size.width * 0.04),
                        child: Column(
                          children: [
                            AppText(
                              text: "Get Started",
                              fontweight: FontWeight.w900,
                              size: 28,
                              color: AppColors.blue,
                            ),
                            SizedBox(height: size.height * 0.03),
                            ApptextField(
                              validator: (value) {
                                return Validators.required(value, "Full Name");
                              },
                              controller: watchAuthCubit.nameController,
                              maxLine: 1,
                              hintText: "Enter Full Name",
                              labelText: "Full Name",
                              keyboardType: TextInputType.name,
                            ),
                            SizedBox(height: size.height * 0.04),
                            ApptextField(
                              validator: (value) {
                                return Validators.email(value);
                              },
                              controller: watchAuthCubit.emailController,
                              maxLine: 1,
                              hintText: "Enter Email",
                              labelText: "Email",
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: size.height * 0.04),
                            ApptextField(
                              controller: watchAuthCubit.passwordController,
                              validator: (value) {
                                return Validators.password(value!);
                              },
                              hintText: "Enter Password",
                              labelText: "Password",
                              keyboardType: TextInputType.visiblePassword,
                              maxLine: 1,
                              // prefixIcon: Icons.lock,
                              obscureText: watchAuthCubit.showPassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  watchAuthCubit.showPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.lightblack,
                                ),
                                onPressed: () {
                                  readAuthCubit.changeShowpassword();
                                },
                              ),
                            ),
                            SizedBox(height: size.height * 0.04),
                            ApptextField(
                              controller:
                                  watchAuthCubit.confirmpasswordController,
                              validator: (value) {
                                if (value !=
                                    watchAuthCubit.passwordController.text) {
                                  return "Password does not match";
                                }
                                return null;
                              },
                              hintText: "Confirm Password",
                              labelText: "Confirm Password",
                              keyboardType: TextInputType.visiblePassword,
                              maxLine: 1,
                              // prefixIcon: Icons.lock,
                              obscureText: watchAuthCubit.showPassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  watchAuthCubit.showPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.lightblack,
                                ),
                                onPressed: () {
                                  readAuthCubit.changeShowpassword();
                                },
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            AppText(
                              textAlign: TextAlign.left,
                              text: "I want to be a...",
                              fontweight: FontWeight.w500,
                              size: 18,
                              color: AppColors.lightblack,
                            ),
                            SizedBox(height: size.height * 0.009),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MentorOrMenteeContainer(
                                  onTap: () {
                                    readAuthCubit.changeRole(isMentee: false);
                                  },
                                  color: !watchAuthCubit.isMentee
                                      ? AppColors.filledColor
                                      : null,
                                  iconColor: !watchAuthCubit.isMentee
                                      ? Colors.white
                                      : null,
                                  textColor: !watchAuthCubit.isMentee
                                      ? Colors.white
                                      : null,
                                  borderColor: !watchAuthCubit.isMentee
                                      ? Colors.white
                                      : null,
                                  size: size,
                                  icon: Icons.lightbulb_outline,
                                ),
                                10.horizontalSpace,
                                MentorOrMenteeContainer(
                                  onTap: () {
                                    readAuthCubit.changeRole(isMentee: true);
                                  },
                                  color: watchAuthCubit.isMentee
                                      ? AppColors.filledColor
                                      : null,
                                  icon: Icons.school,
                                  iconColor: watchAuthCubit.isMentee
                                      ? Colors.white
                                      : null,
                                  textColor: watchAuthCubit.isMentee
                                      ? Colors.white
                                      : null,
                                  borderColor: watchAuthCubit.isMentee
                                      ? Colors.white
                                      : null,
                                  size: size,
                                  text: "Mentee",
                                  subText: "Learn & Grow",
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppCheckbox(
                                  status: watchAuthCubit.agreetoterms,
                                  ontap: () {
                                    readAuthCubit.changeAgreetoterms();
                                  },
                                ),
                                10.horizontalSpace,
                                Text.rich(
                                  TextSpan(
                                    text: 'I agree to the sharing of my',
                                    style: TextStyle(
                                      color: AppColors.lightblack,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: ' Personal Data',
                                        style: TextStyle(
                                          color: AppColors.blue,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.02),
                            AppButton(
                              buttonColor: AppColors.filledColor,
                              onTap: () {
                                formKey.currentState!.save();
                                readAuthCubit.changeRole(
                                  isMentee: watchAuthCubit.isMentee,
                                );
                                if (formKey.currentState!.validate() &&
                                    watchAuthCubit.agreetoterms &&
                                    watchAuthCubit.role != '') {
                                  log("worked");
                                  log("hey");

                                  // readAuthCubit.signUp();
                                  Navigator.pushNamed(
                                    context,
                                    Routename.selectInterest,
                                  );
                                  readAuthCubit.clear();
                                } else {
                                  log("not worked");
                                  ToastMessage.showErrorToast(
                                    message:
                                        "Please correctly fill all the fields",
                                  );
                                }
                              },
                              textSize: 18,
                              label: "Sign Up",
                              width: size.width * 0.9,
                              height: size.height * 0.06,
                            ),
                            10.verticalSpace,
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, Routename.login);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText(
                                    text: "Already have an account?",
                                    fontweight: FontWeight.w500,
                                    size: 18,
                                    color: AppColors.lightblack,
                                  ),
                                  5.horizontalSpace,
                                  AppText(
                                    text: "Login",
                                    fontweight: FontWeight.w700,
                                    size: 18,
                                    color: AppColors.blue,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
