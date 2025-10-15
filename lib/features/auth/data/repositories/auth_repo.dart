import '../../domain/entities/registerModel.dart';
import '../../domain/usecases/states.dart';

abstract class AuthDatasource {
  Future<LoginResult> login(login);
  Future<RegisterResult> createacount(Registermodel createaccount);
  Future<EmailVerificationResult> verifyEmail(verifyEmail);
  Future<SendEmailVerificationResult> sendEmailVerification(String email);
  Future<UserDetailsResult> getUserDetails();
}
