import 'package:http/http.dart';

abstract class AuthRepoInterface{
  Future<Response> signUp(
      {required String email,
      required String password,
      required String name});
  Future<Response> login({required String email, required String password});

}