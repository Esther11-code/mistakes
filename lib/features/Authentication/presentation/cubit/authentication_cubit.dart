import 'dart:developer';
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
      user.role = role;
    } else {
      role = 'Mentor';
      user.role = role;
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

  logout() async {
    emit(AuthLoadingState());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('login');
    emit(AuthLogoutState());
    user = UserModel();
  }

  signUp() async {
    emit(AuthLoadingState());
    await authRepo.signUp(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
    );
    emit(AuthLoadedState());
  }
}
