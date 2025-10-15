import '../../../../constant/enum.dart';
import '../../../../core/service/http_service.dart';
import '../../domain/entities/UserDetailsResponse.dart';
import '../../domain/entities/loginModel.dart';
import '../../domain/entities/registerModel.dart';
import '../../domain/entities/verifyEmailModel.dart';
import '../../domain/usecases/states.dart';
import '../repositories/auth_repo.dart';

class AuthDatasourceImp implements AuthDatasource {
  final HttpService httpService;

  AuthDatasourceImp(this.httpService);
  @override
  Future<RegisterResult> createacount(createaccount) async {
    RegisterResult registerResult = RegisterResult(
      RegisterResultStates.isLoading,
      {},
      '',
    );
    final response = await httpService.request(
      url: '/auth/register',
      methodrequest: RequestMethod.post,
      data: registermodelToJson(createaccount),
    );

    if (response.statusCode == 201) {
      // token = response.data['access_token'];
      registerResult = RegisterResult(
        RegisterResultStates.isData,
        response.data,
        response.data['message'],
      );
    }

    return registerResult;
  }

  @override
  Future<LoginResult> login(login) async {
    LoginResult loginResult = LoginResult(LoginResultStates.isLoading, {});

    final response = await httpService.request(
      url: '/auth/login',
      methodrequest: RequestMethod.post,
      data: loginModelToJson(login),
    );

    if (response.statusCode == 200) {
      // final decodedresponse = LoginResponse.fromJson(response.data);
      loginResult = LoginResult(LoginResultStates.isData, response.data);
    }

    return loginResult;
  }

  @override
  Future<EmailVerificationResult> verifyEmail(verifyEmail) async {
    EmailVerificationResult emailVerificationResult = EmailVerificationResult(
      EmailVerificationResultState.isLoading,
      {},
    );

    final response = await httpService.request(
      url: '/auth/verify-otp',
      methodrequest: RequestMethod.post,
      data: verifyEmailModelToJson(verifyEmail),
    );

    if (response.statusCode == 200) {
      emailVerificationResult = EmailVerificationResult(
        EmailVerificationResultState.isData,
        response.data,
      );
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
    final response = await httpService.request(
      url: '/auth/request-otp',
      methodrequest: RequestMethod.post,
      data: {'email': email},
    );
    if (response.statusCode == 200) {
      sendEmailVerificationResult = SendEmailVerificationResult(
        SendEmailVerificationResultState.isData,
        response.data,
      );
    }
    return sendEmailVerificationResult;
  }

  @override
  Future<UserDetailsResult> getUserDetails() async {
    UserDetailsResult userDetailsResult = UserDetailsResult(
      UserDetailsResultState.isLoading,
      UserDetailsResponseModel(message: '', userDetails: UserDetails()),
    );
    final response = await httpService.request(
      url: '/auth/user-details',
      methodrequest: RequestMethod.get,
    );
    final decodedResponse = UserDetailsResponseModel.fromJson(response.data);
    if (response.statusCode == 200) {
      userDetailsResult = UserDetailsResult(
        UserDetailsResultState.isData,
        decodedResponse,
      );
    }
    return userDetailsResult;
  }
}
