import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final readAuthCubit = context.read<AuthenticationCubit>();
    final size = MediaQuery.sizeOf(context);

    return AppScaffold(
      body: BlocListener<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is PasswordResetEmailSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: AppColors.white),
                    SizedBox(width: size.width * 0.02),
                    Expanded(
                      child: InAppText(
                        text: 'Reset link sent to ${state.email}',
                        color: AppColors.white,
                        fontweight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                backgroundColor: AppColors.success,
                duration: const Duration(seconds: 3),
              ),
            );
            Future.delayed(const Duration(seconds: 2), () {
              if (context.mounted) {
                Navigator.pop(context);
              }
            });
          }

          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.error_outline, color: AppColors.white),
                    SizedBox(width: size.width * 0.02),
                    Expanded(child: InAppText(text: state.error)),
                  ],
                ),
                backgroundColor: AppColors.errorColor,
              ),
            );
          }
        },
        child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
          builder: (context, state) {
            final isLoading = state is AuthLoadingState;
            final isSuccess = state is PasswordResetEmailSent;
            return AppScaffold(
              body: Column(
                children: [
                  AppbarWidget(
                    title: "Forgot Password",
                    size: size,
                    onTap: () => Navigator.pop(context),
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.all(size.width * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height * 0.02),
                        InAppText(
                          text: isSuccess
                              ? 'Check Your Email'
                              : 'Can\'t remember your password?',
                          fontweight: FontWeight.w700,
                        ),
                        SizedBox(height: size.width * 0.01),
                        InAppText(
                          text: isSuccess
                              ? 'We\'ve sent a password reset link to your email.'
                              : 'Enter your email address and we\'ll send you a link to reset your password.',
                        ),

                        SizedBox(height: size.width * 0.07),

                        TextField(
                          controller:
                              readAuthCubit.passwordResentEmailController,
                          keyboardType: TextInputType.emailAddress,
                          enabled: !isLoading && !isSuccess,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                size.width * 0.03,
                              ),
                            ),
                            filled: isSuccess,
                            fillColor: isSuccess ? Colors.grey[100] : null,
                          ),
                        ),

                        SizedBox(height: size.height * 0.05),

                        if (!isSuccess)
                          AppButton(
                            isLoading: isLoading,
                            onTap: isLoading
                                ? null
                                : () {
                                    readAuthCubit.resetPassword();
                                  },

                            label: 'Send Reset Link',
                            buttonColor: AppColors.blackColor,
                            labelColor: AppColors.white,
                            textSize: 20,
                          ),

                        SizedBox(height: size.height * 0.04),

                        GestureDetector(
                          onTap: isLoading
                              ? null
                              : () {
                                  readAuthCubit.resetState();
                                  Navigator.pop(context);
                                },
                          child: InAppText(
                            text: isSuccess ? 'Back to Login' : 'Cancel',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
