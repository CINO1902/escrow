import 'dart:convert';

VerifyEmailModel verifyEmailModelFromJson(String str) =>
    VerifyEmailModel.fromJson(json.decode(str));

String verifyEmailModelToJson(VerifyEmailModel data) =>
    json.encode(data.toJson());

class VerifyEmailModel {
  String email;
  String otp;

  VerifyEmailModel({required this.email, required this.otp});

  factory VerifyEmailModel.fromJson(Map<String, dynamic> json) =>
      VerifyEmailModel(email: json['email'], otp: json['otp']);

  Map<String, dynamic> toJson() => {'email': email, 'otp': otp};
}
