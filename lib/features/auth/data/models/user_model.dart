import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String? fullName;
  final String? referralCode;
  final String? planType;

  const UserModel({
    required this.id,
    required this.email,
    this.fullName,
    this.referralCode,
    this.planType,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      fullName: json['full_name'] as String?,
      referralCode: json['referral_code'] as String?,
      planType: json['plan_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'referral_code': referralCode,
      'plan_type': planType,
    };
  }

  @override
  List<Object?> get props => [id, email, fullName, referralCode, planType];
}
