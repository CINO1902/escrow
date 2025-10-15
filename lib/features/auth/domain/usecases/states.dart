import '../entities/UserDetailsResponse.dart';

class LoginResult {
  final LoginResultStates state;
  final Map<dynamic, dynamic> response;

  LoginResult(this.state, this.response);
}

enum LoginResultStates { isLoading, isError, isData, isIdle }

class RegisterResult {
  final RegisterResultStates state;
  final String? message;
  final Map<String, dynamic> response;

  RegisterResult(this.state, this.response, this.message);
}

enum RegisterResultStates { isLoading, isError, isData, isIdle }

class EmailVerificationResult {
  final EmailVerificationResultState state;
  final Map<String, dynamic> response;

  EmailVerificationResult(this.state, this.response);
}

enum EmailVerificationResultState { isLoading, isError, isData, isIdle }

class SendEmailVerificationResult {
  final SendEmailVerificationResultState state;
  final Map<String, dynamic> response;

  SendEmailVerificationResult(this.state, this.response);
}

enum SendEmailVerificationResultState { isLoading, isError, isData, isIdle }

class UserDetailsResult {
  final UserDetailsResultState state;
  final UserDetailsResponseModel response;

  UserDetailsResult(this.state, this.response);
}

enum UserDetailsResultState { isLoading, isError, isData, isIdle }
