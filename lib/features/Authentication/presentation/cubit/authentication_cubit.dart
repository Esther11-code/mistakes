import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mistakes/features/Authentication/data/remote/auth_repo.dart';

import '../../data/model/user_model.dart';

part 'authentication_state.dart';

String bearerToken = '';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthRepo authRepo;
  AuthenticationCubit(this.authRepo) : super(AuthenticationInitial());

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final bioController = TextEditingController();
  final expertiseController = TextEditingController();
  final passwordResentEmailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();
  final yearsOfExperienceController = TextEditingController();

  bool isAbove18 = false;
  File? profileImage;

  void toggleAgeConfirmation() {
    emit(AuthLoadingState());
    isAbove18 = !isAbove18;
    emit(AddDetailsLoaded());
  }

  Future<void> pickImage(BuildContext context, ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (!context.mounted) return;
      emit(AuthLoadingState());
      if (image != null) {
        profileImage = File(image.path);
        log("Image path: ${profileImage!.path}");
     
        emit(AddDetailsLoaded());
      } else {
        log("No image selected");
        emit(AddDetailsLoaded());
      }
    } catch (e) {
      emit(AddDetailsError("Failed to pick image: ${e.toString()}"));
      log("Failed to pick image: ${e.toString()}");
      emit(AddDetailsLoaded());
    }
  }

  void validateAndSubmit(BuildContext context) {
    emit(AuthLoadingState());
    final expertise = expertiseController.text.trim();
    final bio = bioController.text.trim();

    if (expertise.isEmpty) {
      emit(AddDetailsError('Please enter your expertise'));
      emit(AddDetailsLoaded());
      return;
    }

    if (bio.isEmpty) {
      emit(AddDetailsError('Please enter your bio'));
      emit(AddDetailsLoaded());
      return;
    }

    if (!isAbove18) {
      emit(AddDetailsError('You must be 18 or older to continue'));
      emit(AddDetailsLoaded());
      return;
    }
    updateProfileDetails();
    emit(AddDetailsSuccess());
  }

  void skipDetails() {
    emit(AddDetailsSkipped());
  }

  String getInitials() {
    if (user.name == null || user.name!.isEmpty) return 'U';

    final nameParts = user.name!.trim().split(' ');

    if (nameParts.length == 1) {
      // Single name: return first letter
      return nameParts[0][0].toUpperCase();
    } else {
      // Multiple names: return first letter of first and last name
      final firstInitial = nameParts.first[0].toUpperCase();
      final lastInitial = nameParts.last[0].toUpperCase();
      return '$firstInitial$lastInitial';
    }
  }

  UserModel user = UserModel();

  bool stayLogin = false;
  bool agreetoterms = false;
  bool isMentee = true;
  String role = '';
  bool showPassword = true;

  changeShowpassword() {
    emit(AuthLoadingState());
    showPassword = !showPassword;
    log(showPassword.toString());
    emit(AuthLoadedState());
  }

  changeStaylogin() {
    emit(AuthLoadingState());
    stayLogin = !stayLogin;
    log(stayLogin.toString());
    emit(AuthLoadedState());
  }

  bool showTimer = true;
  changeShowTimer() {
    emit(AuthLoadingState());
    showTimer = !showTimer;
    emit(AuthLoadedState());
  }

  updateState() {
    emit(AuthLoadingState());
    emit(AuthLoadedState());
  }

  String field = '';
  enableInputFields(String value) {
    emit(AuthLoadingState());
    field = value;
    emit(AuthLoadedState());
  }

  changeAgreetoterms() {
    emit(AuthLoadingState());
    agreetoterms = !agreetoterms;
    log(agreetoterms.toString());
    emit(AuthLoadedState());
  }

  void changeRole({required bool isMentee}) {
    emit(AuthLoadingState());
    this.isMentee = isMentee;
    log(isMentee.toString());
    log("This$isMentee");
    if (isMentee) {
      role = 'Mentee';
      user.role = "mentee";
    } else {
      role = 'Mentor';
      user.role = "mentor";
    }
    log(role);
    log(user.role!);
    emit(AuthRoleChangedState());
  }

  void clear() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    confirmpasswordController.clear();
  }

  getUserInfo() async {
    emit(AuthLoadingState());
    nameController.text = user.name!;
    emailController.text = user.email!;
    emit(AuthLoadedState());
  }

  // Sign up
  signUp() async {
    if (!agreetoterms) {
      emit(AuthErrorState(error: 'Please agree to terms and conditions'));
      emit(AuthLoadedState());
      return;
    }

    emit(AuthLoadingState());
    try {
      final response = await authRepo.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        name: nameController.text.trim(),
        role: role.toLowerCase(),
      );

      user = UserModel.fromJson(response);

      log('Signup successful - User ID: ${user.id} - User: ${user.name}');
      clear();
      emit(AuthSignUpSuccessState());
    } catch (e) {
      log('Signup error: $e');
      emit(AuthErrorState(error: e.toString()));
      emit(AuthLoadedState());
    }
  }

  // Sign in
  signIn() async {
    emit(AuthLoadingState());
    try {
      final response = await authRepo.signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      user = UserModel.fromJson(response);

      log('Login successful - User: ${user.name}');
      log('Role: ${user.role}');
      log('Interests: ${user.interests?.length ?? 0}');

      if (stayLogin) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', user.id!);
        await prefs.setBool('login', true);
      }
      clear();
      emit(AuthSignInSuccessState());
    } catch (e) {
      log('Login error: $e');
      emit(AuthErrorState(error: e.toString()));
      emit(AuthLoadedState());
    }
  }

  // Save interests
  Future<void> saveUserInterests(List<String> interests) async {
    if (user.id == null) {
      emit(AuthErrorState(error: 'User not found'));
      emit(AuthLoadedState());
      return;
    }

    emit(AuthLoadingState());
    try {
      await authRepo.saveInterests(interests);

      user.interests = interests;
      // user.areaOfInterest = interests.join(', ');

      log('Interests saved: ${interests.length}');
      clear();
      emit(AuthInterestsSavedState());
    } catch (e) {
      log('Save interests error: $e');
      emit(AuthErrorState(error: e.toString()));
      emit(AuthLoadedState());
    }
  }

  // Update profile details (after signup)
  updateProfileDetails() async {
  emit(AuthLoadingState());
  try {
    String? profilePhotoUrl;

    // 1. ⭐ Upload photo FIRST if user selected one
    if (profileImage != null) {
      log('📸 Uploading profile photo...');
      
      // Delete old photo if exists
      if (user.profilePhotoUrl != null && user.profilePhotoUrl!.isNotEmpty) {
        try {
          await authRepo.deleteProfilePhoto(user.profilePhotoUrl!);
        } catch (e) {
          log('⚠️ Failed to delete old photo: $e');
        }
      }

      // Upload new photo
      profilePhotoUrl = await authRepo.uploadProfilePhoto(
        userId: user.id!,
        imageFile: profileImage!,
      );
      
      log('✅ Photo uploaded: $profilePhotoUrl');
    }

    // 2. Update profile with the PUBLIC URL (not local path)
    await authRepo.updateProfile(
      userId: user.id!,
      bio: bioController.text.trim(),
      expertise: expertiseController.text.trim(),
      yearsExperience: int.tryParse(yearsOfExperienceController.text.trim()) ?? 0,
      profilePhotoUrl: profilePhotoUrl, // ⭐ Use uploaded URL, not local path
    );

    log("Years: ${user.yearsExperience}");

    // 3. Update local user model
    user.bio = bioController.text.trim();
    user.expertise = expertiseController.text.trim();
    user.yearsExperience = int.tryParse(yearsOfExperienceController.text);
    
    if (profilePhotoUrl != null) {
      user.profilePhotoUrl = profilePhotoUrl; // ⭐ Save URL, not path
    }

    getUserInfo();
    checkLoginStatus();
    
    log('✅ Profile details updated');
    clear();
    
    emit(AuthProfileUpdatedState());
  } catch (e) {
    log('❌ Error updating profile: $e');
    emit(AuthErrorState(error: e.toString()));
    emit(AuthLoadedState());
  }
}

  // Check if user is already logged in (for splash screen)
  checkLoginStatus() async {
    emit(AuthLoadingState());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('login') ?? false;

      if (!isLoggedIn) {
        log('No active login session');
        emit(AuthLoadedState());
        return;
      }

      // Get current user from Supabase
      final userData = await authRepo.getCurrentUser();

      if (userData == null) {
        log('Session expired');
        await prefs.remove('login');
        emit(AuthLoadedState());
        return;
      }

      // Restore user data
      user.id = userData['user_id'];
      user.email = userData['email'];
      user.name = userData['name'];
      user.role = userData['role'];
      user.bio = userData['bio'];
      user.expertise = userData['expertise'];
      user.profilePhotoUrl = userData['profile_photo_url'];

      log('User session restored: ${user.email}');
      emit(AuthAutoLoginSuccessState());
    } catch (e) {
      log('Error checking login status: $e');
      emit(AuthLoadedState());
    }
  }

  // Logout
  logout() async {
    emit(AuthLoadingState());
    try {
      await authRepo.signOut();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('login');
      await prefs.remove('user_id');
      await prefs.remove('email');

      user = UserModel();
      clear();

      log('User logged out successfully');
      emit(AuthLogoutState());
    } catch (e) {
      log('Error in logout: $e');
      emit(AuthErrorState(error: e.toString()));
      emit(AuthLoadedState());
    }
  }

  // UPDATE the existing resetPassword method:
  resetPassword() async {
    if (passwordResentEmailController.text.trim().isEmpty) {
      emit(AuthErrorState(error: 'Please enter your email'));
      emit(AuthLoadedState());
      return;
    }

    if (!passwordResentEmailController.text.contains('@')) {
      emit(AuthErrorState(error: 'Please enter a valid email'));
      emit(AuthLoadedState());
      return;
    }

    emit(AuthLoadingState());
    try {
      await authRepo.resetPassword(
        email: passwordResentEmailController.text.trim(),
      );
      log('Password reset email sent');
      clear();
      emit(PasswordResetEmailSent(passwordResentEmailController.text.trim()));
    } catch (e) {
      log('Error sending reset email: $e');
      emit(AuthErrorState(error: e.toString()));
      emit(AuthLoadedState());
    }
  }

  // ADD THIS NEW METHOD:
  updatePassword() async {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmNewPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      emit(AuthErrorState(error: 'Please fill in all fields'));
      emit(AuthLoadedState());
      return;
    }

    if (newPassword.length < 6) {
      emit(AuthErrorState(error: 'Password must be at least 6 characters'));
      emit(AuthLoadedState());
      return;
    }

    if (newPassword != confirmPassword) {
      emit(AuthErrorState(error: 'Passwords do not match'));
      emit(AuthLoadedState());
      return;
    }

    emit(AuthLoadingState());
    try {
      await authRepo.updatePassword(newPassword: newPassword);
      log('Password updated successfully');

      // Clear the controllers
      newPasswordController.clear();
      confirmNewPasswordController.clear();

      emit(PasswordResetSuccess());
    } catch (e) {
      log('Error updating password: $e');
      emit(PasswordResetError(e.toString()));
      emit(AuthLoadedState());
    }
  }

  // ADD THIS METHOD to reset to initial state:
  resetState() {
    emit(AuthenticationInitial());
  }
}
