import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/page%20route/page_route.dart';
import 'package:mistakes/constants/utils/app_validation.dart';
import 'package:mistakes/constants/utils/toast_helper.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../constants/utils/app_colors.dart';
import '../cubit/authentication_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchAuthCubit = context.watch<AuthenticationCubit>();
    final readAuthCubit = context.read<AuthenticationCubit>();
    final formkey = GlobalKey<FormState>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // 👇 Optional: makes status bar text/icons visible on gradient
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
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                200.verticalSpace,
                Expanded(
                  child: Container(
                    height: size.height * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(size.width * 0.1),
                        topRight: Radius.circular(size.width * 0.1),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(size.width * 0.05),
                        child: Column(
                          children: [
                            SizedBox(height: size.height * 0.03),
                            AppText(
                              text: "Welcome Back",
                              fontweight: FontWeight.w900,
                              size: 28,
                              color: AppColors.blue,
                            ),
                            SizedBox(height: size.height * 0.03),

                            ApptextField(
                              controller: readAuthCubit.emailController,
                              maxLine: 1,
                              hintText: "Enter Email",
                              labelText: "Email",
                              validator: (value) {
                                return Validators.required(value, "Email");
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: size.height * 0.03),
                            ApptextField(
                              controller: readAuthCubit.passwordController,
                              hintText: "Enter Password",
                              labelText: "Password",
                              keyboardType: TextInputType.visiblePassword,
                              maxLine: 1,
                              obscureText: watchAuthCubit.showPassword,
                              validator: (value) {
                                return Validators.required(value, "Password");
                              },
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: size.width * 0.45,
                                  child: CheckboxAndLabel(
                                    watchAuthCubit: watchAuthCubit,
                                    readAuthCubit: readAuthCubit,
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.45,
                                  child: AppText(
                                    text: "Forgot Password?",
                                    fontweight: FontWeight.w500,
                                    size: 16,
                                    color: AppColors.blue,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.03),
                            AppButton(
                              buttonColor: AppColors.filledColor,
                              onTap: () {
                                if (formkey.currentState!.validate()) {
                                  // readAuthCubit.login();
                                  Navigator.pushNamed(
                                    context,
                                    Routename.loginSuccess,
                                  );
                                } else {
                                  log("error");
                                  ToastMessage.showErrorToast(
                                    message: "Please fill required fields",
                                  );
                                }
                              },
                              label: "Login",
                              textSize: 18,

                              width: size.width * 0.9,
                              height: size.height * 0.06,
                            ),
                            10.verticalSpace,
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, Routename.signup);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText(
                                    text: "Don't have an account?",
                                    fontweight: FontWeight.w500,
                                    size: 18,
                                    color: AppColors.lightblack,
                                  ),
                                  5.horizontalSpace,
                                  AppText(
                                    text: "Signup",
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

class CheckboxAndLabel extends StatelessWidget {
  const CheckboxAndLabel({
    super.key,
    required this.watchAuthCubit,
    required this.readAuthCubit,
  });

  final AuthenticationCubit watchAuthCubit;
  final AuthenticationCubit readAuthCubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppCheckbox(
          status: watchAuthCubit.stayLogin,
          ontap: () {
            readAuthCubit.changeStaylogin();
          },
        ),
        10.horizontalSpace,
        AppText(
          text: "Stay logged in",
          fontweight: FontWeight.w500,
          size: 16,
          color: AppColors.lightblack,
        ),
      ],
    );
  }
}
