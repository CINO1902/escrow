import 'dart:developer';


import '../../../../core/exceptions/network_exception.dart';
import '../../data/repositories/auth_repo.dart';
import '../entities/UserDetailsResponse.dart';
import '../entities/registerModel.dart';
import '../usecases/states.dart';

abstract class AuthRepository {
  Future<LoginResult> login(login);
  Future<RegisterResult> createacount(Registermodel createaccount);
  Future<EmailVerificationResult> verifyEmail(verifyEmail);
  Future<SendEmailVerificationResult> sendEmailVerification(String email);
  Future<UserDetailsResult> getUserDetails();
}

class AuthRepositoryImp implements AuthRepository {
  final AuthDatasource authDatasource;
  AuthRepositoryImp(this.authDatasource);
  @override
  Future<RegisterResult> createacount(createaccount) async {
    RegisterResult registerResult = RegisterResult(
      RegisterResultStates.isLoading,
      {},
      '',
    );

    try {
      print(createaccount.toJson());
      registerResult = await authDatasource.createacount(createaccount);
    } catch (e) {
      print(e.toString());
      log(e.toString());

      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        registerResult = RegisterResult(RegisterResultStates.isError, {
          "message": message,
        }, message);
      } else {
        registerResult = RegisterResult(RegisterResultStates.isError, {
          "message": "Something Went Wrong",
        }, 'Something Went Wrong');
      }
    }
    return registerResult;
  }

  @override
  Future<LoginResult> login(login) async {
    LoginResult loginResult = LoginResult(LoginResultStates.isLoading, {});
    try {
      loginResult = await authDatasource.login(login);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        print(message);
        loginResult = LoginResult(LoginResultStates.isError, {
          "message": message,
        });
      } else {
        loginResult = LoginResult(LoginResultStates.isError, {
          "message": "Something Went Wrong",
        });
      }
    }
    return loginResult;
  }

  @override
  Future<EmailVerificationResult> verifyEmail(verifyEmail) async {
    EmailVerificationResult emailVerificationResult = EmailVerificationResult(
      EmailVerificationResultState.isLoading,
      {},
    );
    try {
      emailVerificationResult = await authDatasource.verifyEmail(verifyEmail);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        emailVerificationResult = EmailVerificationResult(
          EmailVerificationResultState.isError,
          {"message": message},
        );
      } else {
        emailVerificationResult = EmailVerificationResult(
          EmailVerificationResultState.isError,
          {"message": "Something Went Wrong"},
        );
      }
    }
    return emailVerificationResult;
  }

  @override
  Future<SendEmailVerificationResult> sendEmailVerification(
    String email,
  ) async {
    SendEmailVerificationResult sendEmailVerificationResult =
        SendEmailVerificationResult(
          SendEmailVerificationResultState.isLoading,
          {},
        );
    try {
      sendEmailVerificationResult = await authDatasource.sendEmailVerification(
        email,
      );
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        sendEmailVerificationResult = SendEmailVerificationResult(
          SendEmailVerificationResultState.isError,
          {"message": message},
        );
      } else {
        sendEmailVerificationResult = SendEmailVerificationResult(
          SendEmailVerificationResultState.isError,
          {"message": "Something Went Wrong"},
        );
      }
    }
    return sendEmailVerificationResult;
  }

  @override
  Future<UserDetailsResult> getUserDetails() async {
    UserDetailsResult userDetailsResult = UserDetailsResult(
      UserDetailsResultState.isLoading,
      UserDetailsResponseModel(message: '', userDetails: UserDetails()),
    );
    try {
      userDetailsResult = await authDatasource.getUserDetails();
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        userDetailsResult = UserDetailsResult(
          UserDetailsResultState.isError,
          UserDetailsResponseModel(
            message: message,
            userDetails: UserDetails(),
          ),
        );
      } else {
        userDetailsResult = UserDetailsResult(
          UserDetailsResultState.isError,
          UserDetailsResponseModel(
            message: "Something Went Wrong",
            userDetails: UserDetails(),
          ),
        );
      }
    }
    return userDetailsResult;
  }
}
