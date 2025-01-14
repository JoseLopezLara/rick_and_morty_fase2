// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:rick_and_morty_fase_2/data/api/login_api.dart';
import 'package:rick_and_morty_fase_2/data/models/user.dart';
import 'package:rick_and_morty_fase_2/data/shared/utilis/logger.dart';

class LoginRepository {
  final LoginApi api;

  //Recibir y contruir
  LoginRepository({
    required this.api,
  });

  Future<User> login(String username, String password) async {
    final body = jsonEncode({'username': username, 'password': password});
    logger.i("[LoginRepository] Recived Parameters + $username  + $password");

    final response = await api.login(body);
    logger.i(
        "[LoginRepository] request successfully. I will return: ${User.fromMap(response).toString()}");

    return User.fromMap(response);
  }
}
