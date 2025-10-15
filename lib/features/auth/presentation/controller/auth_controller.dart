import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/UserDetailsResponse.dart';
import '../../domain/entities/loginModel.dart';
import '../../domain/entities/registerModel.dart';
import '../../domain/entities/verifyEmailModel.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/states.dart';

/// A provider class responsible for all authentication-related operations,
/// including login, registration, OTP verification, and user profile management.
class AuthController extends ChangeNotifier {
  AuthController(this._authRepository) {
    // Call your "on-create" method here:
    _init();
  }

  final AuthRepository _authRepository;

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    emailLogin = prefs.getString('emailLogin') ?? '';
    // Load remember me state
    _rememberMe = prefs.getBool('rememberMe') ?? false;
    // print(emailLogin);
    notifyListeners();
  }

  /// Local state fields

  String emailLogin = '';
  bool _rememberMe = false;

  bool get rememberMe => _rememberMe;

  /// Result states for various API calls
  LoginResult loginResult = LoginResult(LoginResultStates.isIdle, {});

  /// Result states for various API calls
  RegisterResult registerResult = RegisterResult(
    RegisterResultStates.isIdle,
    {},
    '',
  );

  EmailVerificationResult verifyEmailResult = EmailVerificationResult(
    EmailVerificationResultState.isIdle,
    {},
  );

  SendEmailVerificationResult sendEmailVerificationResult =
      SendEmailVerificationResult(SendEmailVerificationResultState.isIdle, {});

  UserDetails userDetails = UserDetails();

  /// Performs login and stores JWT on success
  Future<void> login({required String email, required String password}) async {
    final loginModel = LoginModel(email: email, password: password);
    loginResult = LoginResult(LoginResultStates.isLoading, {});
    notifyListeners();

    final response = await _authRepository.login(loginModel);

    if (response.state == LoginResultStates.isData) {
      final token = response.response['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token ?? '');
      final userDetail = response.response['userDetails'];
      print(userDetail);
      final user = UserDetails.fromJson(userDetail);
      await prefs.setString('userDetails', jsonEncode(user.toJson()));

      userDetails = user;
      loadSavedPayload();
    }
    loginResult = response;
    notifyListeners();
  }

  Future<UserDetails?> loadSavedPayload() async {
    final prefs = await SharedPreferences.getInstance();
    final storedString = prefs.getString('userDetails');
    print(storedString);
    if (storedString == null) return null;

    final Map<String, dynamic> decoded = json.decode(storedString);
    print(decoded);
    final restored = UserDetails.fromJson(decoded);
    userDetails = restored;

    notifyListeners();
    return restored;
  }

  Future<void> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final decodedUserDetails = prefs.getString('userDetails');
    final userDetails = UserDetails.fromJson(
      jsonDecode(decodedUserDetails ?? '{}'),
    );
    this.userDetails = userDetails;

    final response = await _authRepository.getUserDetails();
    if (response.state == UserDetailsResultState.isData) {
      final user = response.response.userDetails;
      this.userDetails = user;
    }
  }

  /// Call this from the UI for registration with optional profile image
  Future<void> registerWithProfileImage({
    required String email,
    required String password,
    required String address,
    required String firstname,
    required String lastname,
    required String phoneNumber,
    File? profileImage,
  }) async {
    registerResult = RegisterResult(RegisterResultStates.isLoading, {}, '');
    notifyListeners();
    String? profileImageUrl;
    try {
      if (profileImage != null) {
        profileImageUrl = await _uploadProfileImage(profileImage);
        if (profileImageUrl == null) {
          registerResult = RegisterResult(
            RegisterResultStates.isError,
            {},
            'Image upload failed. Please try again.',
          );
          notifyListeners();
          return;
        }
        final response = await _register(
          email: email,
          password: password,
          address: address,
          firstname: firstname,
          lastname: lastname,
          phoneNumber: phoneNumber,
          profileImageUrl: profileImageUrl,
        );
        registerResult = response;
      } else {
        registerResult = RegisterResult(
          RegisterResultStates.isError,
          {},
          'Please select an image',
        );
        notifyListeners();
        return;
      }
      print(registerResult.message);
      notifyListeners();
    } catch (e) {
      registerResult = RegisterResult(
        RegisterResultStates.isError,
        {},
        e.toString(),
      );
      notifyListeners();
    }
  }

  /// Private: handles actual registration
  Future<RegisterResult> _register({
    required String email,
    required String password,
    required String address,
    required String firstname,
    required String lastname,
    required String phoneNumber,
    String? profileImageUrl,
  }) async {
    final registerModel = Registermodel(
      email: email,
      password: password,
      address: address,
      firstname: firstname,
      lastname: lastname,
      phoneNumber: phoneNumber,
      profileImage: profileImageUrl,
    );
    print(registerModel.toJson());
    registerResult = RegisterResult(RegisterResultStates.isLoading, {}, '');
    notifyListeners();

    final response = await _authRepository.createacount(registerModel);

    if (response.state == RegisterResultStates.isData) {
      // final token = response.response.payload?.accessToken;
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString('jwt_token', token ?? '');
    }
    return response;
  }

  /// Private: handles Cloudinary upload
  Future<String?> _uploadProfileImage(File image) async {
    // Replace with your Cloudinary details
    //  String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;
    const String cloudName = 'drvnpclui';
    const String uploadPreset = 'escrow_profile_image';
    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', image.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final data = jsonDecode(respStr);
      return data['secure_url'] as String?;
    } else {
      return null;
    }
  }

  Future<void> sendemailVerification({required String email}) async {
    sendEmailVerificationResult = SendEmailVerificationResult(
      SendEmailVerificationResultState.isLoading,
      {},
    );
    notifyListeners();

    final response = await _authRepository.sendEmailVerification(email);
    sendEmailVerificationResult = response;
    notifyListeners();
  }

  Future<void> verifyEmail({required String email, required String otp}) async {
    final verifyEmailModel = VerifyEmailModel(email: email, otp: otp);
    verifyEmailResult = EmailVerificationResult(
      EmailVerificationResultState.isLoading,
      {},
    );
    notifyListeners();

    final response = await _authRepository.verifyEmail(verifyEmailModel);
    verifyEmailResult = response;
    notifyListeners();
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('userDetails');
    userDetails = UserDetails();
    notifyListeners();
  }

  /// Save email for Remember Me
  Future<void> saveRememberedEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('emailLogin', email);
    emailLogin = email;
    notifyListeners();
  }

  /// Clear remembered email
  Future<void> clearRememberedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('emailLogin');
    emailLogin = '';
    notifyListeners();
  }

  /// Save remember me checkbox state
  Future<void> saveRememberMeState(bool rememberMe) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', rememberMe);
    _rememberMe = rememberMe;
    notifyListeners();
  }
}
