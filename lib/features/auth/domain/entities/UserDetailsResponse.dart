class UserDetailsResponseModel {
  final String message;
  final UserDetails userDetails;

  UserDetailsResponseModel({required this.message, required this.userDetails});

  factory UserDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsResponseModel(
      message: json['message'] as String,
      userDetails: UserDetails.fromJson(
        json['userDetails'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'userDetails': userDetails.toJson(),
  };
}

class UserDetails {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? address;
  final String? phone;
  final String? profileImage;
  final int? v;

  UserDetails({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.address,
    this.phone,
    this.profileImage,
    this.v,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['_id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      profileImage: json['profile_picture'] as String,
      v: json['__v'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'address': address,
    'phone': phone,
    'profile_picture': profileImage,
    '__v': v,
  };
}
