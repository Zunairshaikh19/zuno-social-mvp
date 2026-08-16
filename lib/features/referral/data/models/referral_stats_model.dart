import 'package:equatable/equatable.dart';

class ReferralStatsModel extends Equatable {
  final String referralCode;
  final String shareableLink;
  final int totalInvited;
  final int activeSubscribers;
  final double creditsEarnedUsd;
  final int freePostsUnlocked;

  const ReferralStatsModel({
    required this.referralCode,
    required this.shareableLink,
    required this.totalInvited,
    required this.activeSubscribers,
    required this.creditsEarnedUsd,
    required this.freePostsUnlocked,
  });

  factory ReferralStatsModel.fromJson(Map<String, dynamic> json) {
    return ReferralStatsModel(
      referralCode: json['referralCode'] as String,
      shareableLink: json['shareableLink'] as String,
      totalInvited: json['totalInvited'] as int,
      activeSubscribers: json['activeSubscribers'] as int,
      creditsEarnedUsd: (json['creditsEarnedUsd'] as num).toDouble(),
      freePostsUnlocked: json['freePostsUnlocked'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'referralCode': referralCode,
      'shareableLink': shareableLink,
      'totalInvited': totalInvited,
      'activeSubscribers': activeSubscribers,
      'creditsEarnedUsd': creditsEarnedUsd,
      'freePostsUnlocked': freePostsUnlocked,
    };
  }

  @override
  List<Object?> get props => [
        referralCode,
        shareableLink,
        totalInvited,
        activeSubscribers,
        creditsEarnedUsd,
        freePostsUnlocked,
      ];

  factory ReferralStatsModel.mock() {
    return const ReferralStatsModel(
      referralCode: 'ZUNO_VIP_88',
      shareableLink: 'https://zunosocial.com/invite/ZUNO_VIP_88',
      totalInvited: 12,
      activeSubscribers: 3,
      creditsEarnedUsd: 45.0,
      freePostsUnlocked: 10,
    );
  }
}
