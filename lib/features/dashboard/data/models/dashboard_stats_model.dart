import 'package:equatable/equatable.dart';

class DashboardStatsModel extends Equatable {
  final String? activeSegmentId;
  final String activeSegmentName;
  final DateTime? nextScheduledPost;
  final int postsUsed;
  final int totalPostsQuota;
  final bool isMetaConnected;
  final String planType;

  const DashboardStatsModel({
    this.activeSegmentId,
    required this.activeSegmentName,
    this.nextScheduledPost,
    required this.postsUsed,
    required this.totalPostsQuota,
    required this.isMetaConnected,
    required this.planType,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      activeSegmentId: json['activeSegmentId'] as String?,
      activeSegmentName: json['activeSegmentName'] as String,
      nextScheduledPost: json['nextScheduledPost'] != null 
          ? DateTime.parse(json['nextScheduledPost'] as String) 
          : null,
      postsUsed: json['postsUsed'] as int,
      totalPostsQuota: json['totalPostsQuota'] as int,
      isMetaConnected: json['isMetaConnected'] as bool? ?? false,
      planType: json['planType'] as String? ?? 'starter',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activeSegmentId': activeSegmentId,
      'activeSegmentName': activeSegmentName,
      'nextScheduledPost': nextScheduledPost?.toIso8601String(),
      'postsUsed': postsUsed,
      'totalPostsQuota': totalPostsQuota,
      'isMetaConnected': isMetaConnected,
      'planType': planType,
    };
  }

  factory DashboardStatsModel.mock() {
    return DashboardStatsModel(
      activeSegmentId: 'seg_1',
      activeSegmentName: 'AI Influencer Alpha',
      nextScheduledPost: DateTime.now().add(const Duration(hours: 4, minutes: 20)),
      postsUsed: 18,
      totalPostsQuota: 30,
      isMetaConnected: true,
      planType: 'pro',
    );
  }

  double get usageProgress => totalPostsQuota == 0 ? 0 : postsUsed / totalPostsQuota;

  @override
  List<Object?> get props => [
        activeSegmentId,
        activeSegmentName,
        nextScheduledPost,
        postsUsed,
        totalPostsQuota,
        isMetaConnected,
        planType,
      ];
}
