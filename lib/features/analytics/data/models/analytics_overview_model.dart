import 'package:equatable/equatable.dart';
import 'package:zunosocial/features/queue/data/models/post_item_model.dart';

class AnalyticsOverviewModel extends Equatable {
  final int totalPostsPublished;
  final int totalImpressions;
  final double engagementRate;
  final double audienceGrowthPct;
  final List<double> weeklyPerformance;
  final List<PostItemModel> topPerformingPosts;

  const AnalyticsOverviewModel({
    required this.totalPostsPublished,
    required this.totalImpressions,
    required this.engagementRate,
    required this.audienceGrowthPct,
    required this.weeklyPerformance,
    required this.topPerformingPosts,
  });

  factory AnalyticsOverviewModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsOverviewModel(
      totalPostsPublished: json['totalPostsPublished'] as int,
      totalImpressions: json['totalImpressions'] as int,
      engagementRate: (json['engagementRate'] as num).toDouble(),
      audienceGrowthPct: (json['audienceGrowthPct'] as num).toDouble(),
      weeklyPerformance: (json['weeklyPerformance'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      topPerformingPosts: (json['topPerformingPosts'] as List<dynamic>)
          .map((e) => PostItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPostsPublished': totalPostsPublished,
      'totalImpressions': totalImpressions,
      'engagementRate': engagementRate,
      'audienceGrowthPct': audienceGrowthPct,
      'weeklyPerformance': weeklyPerformance,
      'topPerformingPosts': topPerformingPosts.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        totalPostsPublished,
        totalImpressions,
        engagementRate,
        audienceGrowthPct,
        weeklyPerformance,
        topPerformingPosts,
      ];

  factory AnalyticsOverviewModel.mock() {
    return AnalyticsOverviewModel(
      totalPostsPublished: 45,
      totalImpressions: 12400,
      engagementRate: 5.8,
      audienceGrowthPct: 12.4,
      weeklyPerformance: const [120, 450, 320, 600, 500, 800, 750],
      topPerformingPosts: [
        PostItemModel.mock(id: '1', status: PostStatus.published, scheduledFor: DateTime.now().subtract(const Duration(days: 2))),
        PostItemModel.mock(id: '2', status: PostStatus.published, scheduledFor: DateTime.now().subtract(const Duration(days: 5))),
      ],
    );
  }
}
