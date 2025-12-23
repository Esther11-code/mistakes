import 'dart:convert';

import 'package:http/http.dart';
import 'package:mistakes/features/Authentication/data/domain/auth_repo_interface.dart';

import '../../../../constants/apis/api_constants.dart';

class AuthRepo implements AuthRepoInterface {
  var client = Client();
  @override
  Future<Response> login({
    required String email,
    required String password,
  }) async {
    var body = {'email': email, 'password': password};
    return await client.post(
      Uri.parse(Apis.login),
      body: jsonEncode(body),
      headers: ApiHeaders.unaunthenticatedHeader,
    );
  }

  @override
  Future<Response> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    var body = {
      'email': email,
      'password': password,
      'name': name
    };
    return await client.post(Uri.parse(Apis.register),
        body: jsonEncode(body), headers: ApiHeaders.unaunthenticatedHeader);
  }
}
