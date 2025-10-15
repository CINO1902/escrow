// To parse this JSON data, do
//
//     final registermodel = registermodelFromJson(jsonString);

import 'dart:convert';

Registermodel registermodelFromJson(String str) =>
    Registermodel.fromJson(json.decode(str));

String registermodelToJson(Registermodel data) => json.encode(data.toJson());

class Registermodel {
  String firstname;
  String lastname;
  String email;
  String password;
  String phoneNumber;
  String address;
  String? profileImage;
  Registermodel({
    required this.email,
    required this.password,
    required this.firstname,
    required this.lastname,
    required this.phoneNumber,
    required this.address,
    this.profileImage,
  });

  factory Registermodel.fromJson(Map<String, dynamic> json) => Registermodel(
    email: json["email"],
    password: json["password"],
    firstname: json["first_name"] ?? '',
    lastname: json["last_name"] ?? '',
    phoneNumber: json["phone"] ?? '',
    address: json["address"] ?? '',
    profileImage: json["profileImage"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "first_name": firstname,
    "last_name": lastname,
    "phone": phoneNumber,
    "address": address,
    if (profileImage != null) "profile_picture": profileImage,
  };
}
