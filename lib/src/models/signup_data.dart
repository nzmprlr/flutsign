// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:flutsign/src/models/sign_data.dart';

class SignupData extends Equatable with SignData {
  final String email;
  final String username;
  final String password;

  SignupData({
    required this.email,
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [email, username, password];
}
