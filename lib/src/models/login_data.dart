// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:flutsign/src/models/sign_data.dart';

class LoginData extends Equatable with SignData {
  final String emailOrUsername;
  final String password;

  LoginData({
    required this.emailOrUsername,
    required this.password,
  });

  @override
  List<Object?> get props => [emailOrUsername, password];
}
