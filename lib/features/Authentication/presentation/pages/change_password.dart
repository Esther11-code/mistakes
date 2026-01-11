import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final watchAuthCubit = context.watch<AuthenticationCubit>();
    final readAuthCubit = context.read<AuthenticationCubit>();
    final size = MediaQuery.sizeOf(context);

    return AppScaffold(
      body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is PasswordResetSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: AppColors.white),
                    SizedBox(width: size.width * 0.03),
                    Expanded(
                      child: InAppText(
                        text: 'Password updated successfully!',
                        color: AppColors.white,
                        fontweight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                backgroundColor: AppColors.success,
              ),
            );
            Future.delayed(const Duration(seconds: 1), () {
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routename.login,
                  (route) => false,
                );
              }
            });
          }
          if (state is PasswordResetError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.error_outline, color: AppColors.white),
                    SizedBox(width: size.width * 0.03),
                    Expanded(
                      child: InAppText(
                        text: state.message,
                        color: AppColors.white,
                        fontweight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                backgroundColor: AppColors.errorColor,
              ),
            );
          }
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.error_outline, color: AppColors.white),
                    SizedBox(width: size.width * 0.03),
                    Expanded(
                      child: InAppText(
                        text: state.error,
                        color: AppColors.white,
                        fontweight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                backgroundColor: AppColors.errorColor,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoadingState;

          return AppScaffold(
            body: Column(
              children: [
                AppbarWidget(
                  title: 'Change Password',
                  size: size,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.all(size.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.02),

                      InAppText(
                        text: 'Secure Your Account',
                        size: 20,
                        fontweight: FontWeight.bold,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: size.width * 0.009),
                      InAppText(
                        text: 'Enter your new password below',
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: size.height * 0.04),
                      TextField(
                        controller: readAuthCubit.newPasswordController,
                        obscureText: watchAuthCubit.showPassword,
                        enabled: !isLoading,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          hintText: 'Enter new password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              watchAuthCubit.showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              readAuthCubit.changeShowpassword();
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              size.width * 0.03,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.width * 0.05),
                      TextField(
                        controller: readAuthCubit.confirmNewPasswordController,
                        obscureText: watchAuthCubit.showPassword,
                        enabled: !isLoading,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          hintText: 'Re-enter password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              watchAuthCubit.showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              readAuthCubit.changeShowpassword();
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              size.width * 0.03,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: size.height * 0.05),

                      AppButton(
                        isLoading: isLoading,
                        onTap: isLoading
                            ? null
                            : () {
                                readAuthCubit.updatePassword();
                              },

                        label: 'Update Password',
                        textSize: 20,
                        labelColor: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
